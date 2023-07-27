import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pc_app/Client/ClientDetails.dart';

class Client extends GetxController {
  Rx<TextEditingController> ipController = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  late ClientProvider clientProvider;
  Future<void> connectToServer(String ip, ClientProvider clientProvidr) async {
    try {
      // Set the server's IP address and port number
      String ipAddress = ip;
      const int port = 1234;
      clientProvider = clientProvidr;
      clientProvidr.socket = await Socket.connect(ipAddress, port);
      print('Connected to the server.');
      Get.back();
      // Start listening for messages from the server
      clientProvidr.socket!.listen(
        (List<int> data) {
          String message = String.fromCharCodes(data).trim();
          print('Received from server: $message');
          clientProvidr.addMessage(message);
        },
        onError: (error) {
          print('Error: $error');
          clientProvidr.socket?.destroy();
        },
        onDone: () {
          print('Disconnected from the server.');
          clientProvidr.socket?.destroy();
        },
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  void sendMessage(String message) {
    if (clientProvider.socket != null) {
      clientProvider.socket!.write(message);
    } else {
      print('Not connected to the server.');
    }
  }

  void disconnect() {
    clientProvider.socket?.destroy();
    print('Disconnected from the server.');
  }

  getIp() async {
    try {
      // Get a list of network interfaces
      List<NetworkInterface> interfaces = await NetworkInterface.list();

      // Loop through the interfaces
      for (NetworkInterface ni in interfaces) {
        // Check if the interface is a WiFi interface
        if (ni.name.startsWith('Wi')) {
          // Get the gateway address of the WiFi interface
          List<InternetAddress> addresses = ni.addresses;
          for (InternetAddress address in addresses) {
            ipController.value.text = address.address;
          }
        }
      }
    } catch (ex) {
      Get.snackbar('', 'Could not load IP address.\nTry Again');
    }
    return ipController.value.text;
  }
}
