import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../Client/ClientDetails.dart';
import '../../../constants.dart';
import '../../../controllers/question_controller.dart';
import '../../../models/Question.dart';
import '../../quiz/components/option.dart';

class QuestionCard extends StatelessWidget {
  QuestionCard({
    Key? key,
    // it means we have to pass this
    @required this.question,
  }) : super(key: key);

  Question? question;
  Rx<Color> QBColor =
      const Color.fromARGB(255, 206, 198, 247).withOpacity(.6).obs;
  QuestionController controller = Get.find<QuestionController>();
  @override
  Widget build(BuildContext context) {
    ClientProvider clientProvider = context.read<ClientProvider>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: const EdgeInsets.all(kDefaultPadding * .52),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: SingleChildScrollView(
        child: Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: Obx(() {
                return Container(
                  width: clientProvider.round != 'rapid'
                      ? MediaQuery.of(context).size.width * .45
                      : MediaQuery.of(context).size.width * .6,
                  margin: const EdgeInsets.only(top: kDefaultPadding),
                  padding: const EdgeInsets.all(kDefaultPadding * 0.6),
                  decoration: BoxDecoration(
                    color: QBColor.value,
                    border: Border.all(
                        color: const Color.fromARGB(255, 154, 182, 248)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    question!.ques,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.black),
                  ),
                );
              }),
            ),
            const SizedBox(width: kDefaultPadding),
            if (clientProvider.round != 'rapid')
              Container(
                width: MediaQuery.of(context).size.width * .45,
                margin: const EdgeInsets.only(top: kDefaultPadding),
                padding: const EdgeInsets.all(kDefaultPadding / 3.6),
                // decoration: BoxDecoration(
                //   color: const Color.fromARGB(255, 205, 220, 254),
                //   border:
                //       Border.all(color: const Color.fromARGB(255, 154, 182, 248)),
                //   borderRadius: BorderRadius.circular(15),
                // ),
                child: Column(
                  children: [
                    // ...List.generate(
                    //   question!.options.length,
                    //   (index) => Option(
                    //     index: index,
                    //     text: question!.options[index],
                    //     press: () => controller.checkAns(question!, index),
                    //   ),
                    // ),
                    Option(
                      index: 0,
                      text: question!.opt1,
                      press: () {
                        controller.checkAns(question!, question!.opt1);
                      },
                    ),
                    Option(
                      index: 1,
                      text: question!.opt2,
                      press: () {
                        // controller.checkAns(question!, question!.opt2);
                      },
                    ),
                    Option(
                      index: 2,
                      text: question!.opt3,
                      press: () {
                        // controller.checkAns(question!, question!.opt3);
                      },
                    ),
                    Option(
                      index: 3,
                      text: question!.opt4,
                      press: () {
                        // controller.checkAns(question!, question!.opt4);
                      },
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
