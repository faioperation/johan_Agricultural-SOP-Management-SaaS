import 'package:farm_check_support/app/token_service.dart';
import 'package:farm_check_support/app/urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:get/get.dart';
class SocketMessagePackage {
  final String event;
  final Map<String, dynamic> data;
  SocketMessagePackage(this.event, this.data);
}

class SocketService {
  io.Socket? socket;
  final Map<String, List<Function(dynamic)>> _persistentListeners = {};
  final Rxn<SocketMessagePackage> messageStream = Rxn<SocketMessagePackage>();

  void connect() {
    if (socket?.connected ?? false) return;

    print('🌐 Connecting to Socket: ${ApiUrls.serverUrl}');
    socket = io.io(ApiUrls.serverUrl, io.OptionBuilder()
      .setTransports(['websocket'])
      .setAuth({'token': TokenService.accessToken})
      .setQuery({'token': TokenService.accessToken})
      .disableAutoConnect()
      .setExtraHeaders({
        'Authorization': 'Bearer ${TokenService.accessToken}',
      })
      .build());

    socket?.connect();

    socket?.onConnect((_) {
      print('✅ Socket Connected. My ID: ${TokenService.userId}');
      
      // Setup global message hub for common events
      final hubEvents = ['message', 'chat', 'new-message', 'new_message', 'msg', 'receive-message', 'receive_message'];
      if (TokenService.userId != null) hubEvents.add(TokenService.userId!);
      
      for (var hubEvent in hubEvents) {
        socket?.on(hubEvent, (data) {
          print('📢 Socket Hub Reception [$hubEvent]');
          if (data is Map<String, dynamic>) {
            messageStream.value = SocketMessagePackage(hubEvent, data);
          }
        });
      }

      // Re-apply persistent listeners on every connection
      _persistentListeners.forEach((event, callbacks) {
        socket?.off(event); // Clear any transient ones
        for (var cb in callbacks) {
          socket?.on(event, (data) {
            print('📩 Socket Event [$event]: $data');
            cb(data);
          });
        }
      });

      if (TokenService.accessToken != null) {
        print('🆔 Emitting identity/authenticate events...');
        socket?.emit('identify', {'token': TokenService.accessToken});
        socket?.emit('authenticate', {'token': TokenService.accessToken});
        
        if (TokenService.userId != null) {
          print('👤 Joining personal room: ${TokenService.userId}');
          socket?.emit('join', TokenService.userId);
          socket?.emit('join', {'room': TokenService.userId}); // Variation
          socket?.emit('identify', TokenService.userId);
        }
      }
    });

    socket?.onAny((event, data) {
      print('🔥 Socket wildcard event [$event]: $data');
      if (data is Map<String, dynamic>) {
        // If data looks like a message, push it to the stream regardless of event name
        bool looksLikeMessage = data.containsKey('content') || 
                               data.containsKey('message') || 
                               data.containsKey('text') ||
                               (data.containsKey('data') && data['data'] is Map);
        
        if (looksLikeMessage) {
          print('📢 Auto-pushing wildcard event [$event] to messageStream');
          messageStream.value = SocketMessagePackage(event, data);
        }
      }
    });

    socket?.onDisconnect((_) {
      print('❌ Socket Disconnected');
    });

    socket?.onConnectError((err) {
      print('❌ Socket Connection Error: $err');
    });

    socket?.onError((err) {
      print('❌ Socket Error: $err');
    });
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
  }

  void on(String event, Function(dynamic) callback) {
    // Add to persistent registry
    _persistentListeners.putIfAbsent(event, () => []).add(callback);
    
    // Apply immediately if already connected
    if (socket?.connected ?? false) {
      socket?.on(event, (data) {
        print('📩 Socket Event [$event]: $data');
        callback(data);
      });
    }
  }

  void off(String event) {
    _persistentListeners.remove(event);
    socket?.off(event);
  }

  void clearListeners(List<String> events) {
    for (var event in events) {
      off(event);
    }
  }

  void emit(String event, dynamic data) {
    print('📤 Socket Emit [$event]: $data');
    socket?.emit(event, data);
  }

  void reidentify() {
    if (socket?.connected ?? false) {
      print('🆔 Re-identifying socket (My ID: ${TokenService.userId})');
      if (TokenService.accessToken != null) {
        socket?.emit('identify', {'token': TokenService.accessToken});
        socket?.emit('authenticate', {'token': TokenService.accessToken});
      }
      if (TokenService.userId != null) {
        socket?.emit('join', TokenService.userId);
        socket?.emit('join', {'room': TokenService.userId});
        socket?.emit('identify', TokenService.userId);
      }
    } else {
      connect();
    }
  }
}
