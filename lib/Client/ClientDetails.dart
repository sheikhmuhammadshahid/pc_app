import 'dart:io';

import 'package:flutter/material.dart';

class ClientProvider extends ChangeNotifier {
  List<String> messages = [];
  Socket? socket;
  addMessage(String message) {
    messages.add(message);
    notifyListeners();
  }

  addSocket(Socket socket) {
    this.socket = socket;
    notifyListeners();
  }
}
