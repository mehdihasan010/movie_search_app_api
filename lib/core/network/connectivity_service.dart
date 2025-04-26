import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  ConnectivityService() {
    // Initialize the connectivity service
    _init();
  }

  void _init() {
    // Listen for connectivity changes
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _checkConnectionStatus(result);
    });

    // Check initial connectivity
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final List<ConnectivityResult> result =
        await _connectivity.checkConnectivity();
    _checkConnectionStatus(result);
  }

  void _checkConnectionStatus(List<ConnectivityResult> results) {
    // Consider connected if WiFi or mobile data is available
    final bool isConnected = results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet);

    _connectionStatusController.add(isConnected);
  }

  Future<bool> isConnected() async {
    final List<ConnectivityResult> results =
        await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet);
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
