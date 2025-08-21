import React, { createContext, useContext, useEffect, useState } from "react";
import io from "socket.io-client";
import useAuth from "../hooks/useAuth";
import { BASE_URL } from "../config/api";

const SocketContext = createContext(null);

export const useSocket = () => {
  return useContext(SocketContext);
};

// Helper to decode JWT manually since we don't have jwt-decode
const parseJwt = (token) => {
  try {
    return JSON.parse(atob(token.split('.')[1]));
  } catch (e) {
    return null;
  }
};

export const SocketProvider = ({ children }) => {
  const [socket, setSocket] = useState(null);
  const [error, setError] = useState(null);
  const { user } = useAuth();

  useEffect(() => {
    // If we have a token but no explicit ID, try to decode it
    let userId = user?.id;
    let farmId = user?.farmId;
    let role = user?.role;
    let token = user?.token;

    // If user object only has token (from AuthProvider), decode it
    if (!userId && token) {
      const decoded = parseJwt(token);
      if (decoded) {
        userId = decoded.id || decoded.userId || decoded.sub; // Try common fields
        farmId = decoded.farmId;
        role = decoded.role || role;
      }
    }

    if (!userId || !BASE_URL) return;

    const socketUrl = new URL(BASE_URL).origin;

    console.log("🔌 Connecting socket for user:", userId);

    const newSocket = io(socketUrl, {
      query: {
        userId: userId,
        farmId: farmId, // Pass farmId if backend middleware needs it
        token: token,   // Pass token for middleware auth
      },
      auth: {
        userId: userId,
        token: token,   // Standard auth field
      },
      transports: ["websocket", "polling"], // Allow polling fallback
      reconnection: true,
      reconnectionAttempts: 10,
      reconnectionDelay: 1000,
    });

    setSocket(newSocket);

    newSocket.on("connect", () => {
      console.log("✅ Socket connected:", newSocket.id);
      setError(null);

      // Join rooms manually just in case
      newSocket.emit("join", {
        userId: userId,
        farmId: farmId,
        role: role,
      });
    });

    newSocket.on("connect_error", (err) => {
      console.error("    Socket connection error:", err);
      setError(err.message);
    });

    newSocket.on("disconnect", (reason) => {
      console.warn("⚠️ Socket disconnected:", reason);
    });

    return () => {
      newSocket.disconnect();
      setSocket(null);
    };
  }, [user, user?.token]); 

  return (
    <SocketContext.Provider value={{ socket, error }}>
      {children}
    </SocketContext.Provider>
  );
};
