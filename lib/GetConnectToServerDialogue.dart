import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pc_app/Client/ClientDetails.dart';
import 'package:pc_app/Client/Clients.dart';
import 'package:pc_app/constants.dart';
import 'package:provider/provider.dart';

getConnectToServerDialogue({required BuildContext context}) async {
  Client client = Get.find<Client>();
  final formKey = GlobalKey<FormState>();
  await showCupertinoModalPopup(
    context: context,
    builder: (context) => AlertDialog(
      icon: Align(
        alignment: Alignment.topRight,
        child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.cancel,
              color: Colors.red,
            )),
      ),
      content: SizedBox(
        height: context.height * 0.2,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                getTextInputField1(client.nameController.value, 'Enter name',
                    (v) {
                  if (v == '') {
                    return 'please enter name';
                  }
                  return null;
                }, 1),
                const SizedBox(
                  height: 10,
                ),
                getTextInputField1(
                    client.ipController.value, "Enter Server's ip Address",
                    (String? v) {
                  if (v == '') {
                    return 'please enter ip';
                  } else if (v!.split('.').length != 4) {
                    return 'Ip address is not valid';
                  }
                  return null;
                }, 1)
              ],
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Get.back();
                await Get.find<Client>().connectToServer(
                    client.ipController.value.text,
                    context.read<ClientProvider>());
              }
            },
            child: const Text('Connect'))
      ],
    ),
  );
}
