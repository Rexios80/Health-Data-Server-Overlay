import 'package:hds_overlay/services/connection/connection_base.dart';

// This makes the compiler happy
class SocketServer extends ConnectionBase {
  @override
  Future<void> start(
    String ip,
    int port,
    String clientName,
    List<String> serverIps,
    String overlayId,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> stop() {
    throw UnimplementedError();
  }
}
