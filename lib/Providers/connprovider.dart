// Assume this is in connectivity_provider.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:io';

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  ConnectivityProvider() {
    checkInternetConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      checkInternetConnectivity();
    });
  }

  Future<void> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _isConnected = false;
    } else {
      try {
        final result = await InternetAddress.lookup('google.com');
        _isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        _isConnected = false;
      }
    }
    notifyListeners();
  }
}
