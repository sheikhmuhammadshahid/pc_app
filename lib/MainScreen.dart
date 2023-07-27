import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pc_app/Client/ClientDetails.dart';

import 'Client/Clients.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late Client socketClient = Get.find<Client>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController ipController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  late ClientProvider clientProvider;
  @override
  Widget build(BuildContext context) {
    clientProvider = context.read<ClientProvider>();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: ipController,
                decoration: const InputDecoration(
                    hintText: 'enter Ip adress', border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (ipController.text.isNotEmpty &&
                        clientProvider.socket == null) {
                      socketClient.connectToServer(
                          ipController.text.trim(), clientProvider);
                    } else if (clientProvider.socket == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please enter Server ip address')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Already Connected')));
                    }
                  },
                  child: const Text('Connect')),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                    hintText: 'enter message', border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (messageController.text.isNotEmpty &&
                        clientProvider.socket != null) {
                      socketClient.sendMessage(messageController.text.trim());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please enter something to send ')));
                    }
                  },
                  child: const Text('Send')),
              const Text('Messages Received'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  itemCount: context.watch<ClientProvider>().messages.length,
                  itemBuilder: (context, index) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(clientProvider.messages[index]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
