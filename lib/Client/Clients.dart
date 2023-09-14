import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pc_app/Client/ClientDetails.dart';
import 'package:pc_app/screens/serverside/dashboard.dart';

class Client extends GetxController {
  Rx<TextEditingController> ipController = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  late ClientProvider clientProvider;
  connect(ip, port) async {
    try {
      Socket socket = await Socket.connect(ip, port);
      clientProvider.addSocket(socket);
      return socket;
    } catch (e) {
      EasyLoading.show(status: e.toString(), dismissOnTap: true);

      return null;
    }
  }

  Future<void> connectToServer(String ip, ClientProvider clientProvidr) async {
    try {
      // Set the server's IP address and port number
      String ipAddress = ip;
      const int port = 1234;
      clientProvider = clientProvidr;
      if (await connect(ip, port) != null) {
        print('Connected to the server.');

        if (nameController.value.text.toLowerCase() == 'admin') {
          Get.to(const DashBoardScreen());
        } else {
          Get.back();
          EasyLoading.show(
              dismissOnTap: false, status: 'Waiting for others to connect...');
        }
        sendMessage(nameController.value.text.trim());

        // Start listening for messages from the server
        clientProvidr.socket!.listen(
          (data) {
            String message = String.fromCharCodes(data).trim();
            print('Received from server: $message');
            clientProvidr.addMessage(message);
            EasyLoading.showToast(message);
          },
          onError: (error) {
            print('Error: $error');
            clientProvidr.socket?.destroy();
            clientProvider.notifyListeners();
          },
          onDone: () {
            print('Disconnected from the server.');
            clientProvidr.socket?.destroy();

            clientProvider.notifyListeners();
          },
        );
      }
    } catch (e) {
      EasyLoading.show(status: e.toString(), dismissOnTap: true);

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
