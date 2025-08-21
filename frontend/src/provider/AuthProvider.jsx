import { createContext, useEffect, useState } from "react";
import Cookies from "js-cookie";


export const AuthContext = createContext(null);

const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  // Initialize auth state from cookies
  useEffect(() => {
    const token = Cookies.get("token");
    const role = Cookies.get("userRole");
    if (token) {
        setUser({ token, role }); 
    }
    setLoading(false);
  }, []);

  const logOutUser = () => {
    setLoading(true);
    Cookies.remove("token");
    Cookies.remove("refreshToken");
    Cookies.remove("userRole");
    setUser(null);
    setLoading(false);
  };

  const authInfo = {
    user,
    setUser,
    loading,
    setLoading,
    logOutUser
  };

  return (
    <AuthContext.Provider value={authInfo}>{children}</AuthContext.Provider>
  );
};

export default AuthProvider;
