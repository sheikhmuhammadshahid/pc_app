import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_competition_flutter/main.dart';
import 'package:quiz_competition_flutter/screens/serverside/dashboard.dart';
// import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
// import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        child: Container(
          width: 260,
          padding: const EdgeInsets.all(16),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SignInWithEmailButton(
              //   caller: client.modules.auth,
              //   minPasswordLength: 4,
              //   onSignedIn: () async {
              //     Get.to(const DashBoardScreen());
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
