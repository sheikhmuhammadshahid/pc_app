import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../Client/ClientDetails.dart';
import '../../../constants.dart';
import '../../../controllers/question_controller.dart';
import 'progress_bar.dart';
import 'question_card.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ClientProvider clientProvider = context.read<ClientProvider>();
    clientProvider.pageController = PageController();
    return Stack(
      children: [
        SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ProgressBar(),
              ),
              const SizedBox(height: kDefaultPadding),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Text.rich(
                  TextSpan(
                    text:
                        "Question ${context.watch<ClientProvider>().questionNo + 1}",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: kSecondaryColor),
                    children: [
                      TextSpan(
                        text:
                            "/${context.watch<ClientProvider>().questions.length}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: kSecondaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(thickness: 1.5),
              const SizedBox(height: kDefaultPadding),
              Expanded(
                child: PageView.builder(
                  // Block swipe to next qn
                  physics: const NeverScrollableScrollPhysics(),
                  controller: clientProvider.pageController,
                  //onPageChanged: questionController.updateTheQnNum,
                  itemCount: clientProvider.questions.length,
                  itemBuilder: (context, index) =>
                      QuestionCard(question: clientProvider.questions[index]),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        )
      ],
    );
  }
}
