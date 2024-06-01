import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../Client/ClientDetails.dart';
import '../../Client/Clients.dart';
import '../../constants.dart';

class WelcomeScreen extends StatelessWidget {
  ClientGetController clients = Get.find<ClientGetController>();

  WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    clients.getIp();
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  const Spacer(flex: 2), //2/6
                      GestureDetector(
                          child: Container(
                        alignment: Alignment.topCenter,
                        height: 190,
                        child: Text("Quiz App",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 80,
                                    wordSpacing: 2)),
                      )),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.topCenter,
                          height: 50,
                          child: Text("Let's Play Quiz,",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40)),
                        ),
                      ),

                      GestureDetector(
                        child: Container(
                          alignment: Alignment.topCenter,
                          height: 50,
                          child: Text("Enter your informations below",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(color: Colors.black, fontSize: 20)),
                        ),
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                      //const Spacer(),
                      // // 1/6
                      Obx(
                        () {
                          return getTextInputField(
                              clients.nameController, 'Enter name');
                        },
                      ),

                      // const Spacer(), // 1/6
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      // Obx(
                      //   () {
                      //     return getTextInputField(
                      //         clients.ipController, 'Enter Ip');
                      //   },
                      // ),

                      // const Spacer(), // 1/6
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          if (clients.ipController.value.text != "" &&
                              clients.nameController.value.text != "") {
                            // if sockets uncomment it

                            // Get.defaultDialog(
                            //     backgroundColor: Colors.black38,
                            //     barrierDismissible: false,
                            //     title: '',
                            //     content: const SizedBox(
                            //       width: 300,
                            //       height: 100,
                            //       child: Column(
                            //         children: [
                            //           Text('Trying to connect...'),
                            //           SizedBox(
                            //             height: 10,
                            //           ),
                            //           CircularProgressIndicator()
                            //         ],
                            //       ),
                            //     ));
                            EasyLoading.show(
                                status: 'Trying to connect...',
                                dismissOnTap: false);
                            ClientGetController clientGetController =
                                Get.find<ClientGetController>();
                            await clientGetController.connectToServer(
                                context.read<ClientProvider>());

                            //     context.read<ClientProvider>());

                            // if serverpod uncomment it

                            // await client.pixorama.sendStreamMessage(MyMessage(
                            //     todo: 'connected',
                            //     value: clients.nameController.value.text));
                            // Get.back();
                          } else if (clients.nameController.value.text == "") {
                            Get.snackbar('', 'Please enter name',
                                colorText: Colors.black);
                          } else if (clients.ipController.value.text == "") {
                            Get.snackbar('', 'Please enter ip Address',
                                colorText: Colors.black);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          // alignment: Alignment.center,
                          padding:
                              const EdgeInsets.all(kDefaultPadding * 1.5), // 15
                          decoration: const BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Text(
                            "Join",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: Colors.black, fontSize: 30),
                          ),
                        ),
                      ),
                      // const Spacer(flex: 2), // it will take 2/6 spaces
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
