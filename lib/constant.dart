import 'package:flutter/material.dart';

TextEditingController quesController = TextEditingController();
TextEditingController opt1Controller = TextEditingController();
TextEditingController opt2Controller = TextEditingController();
TextEditingController opt3Controller = TextEditingController();
TextEditingController opt4Controller = TextEditingController();
final formKey = GlobalKey<FormState>();
getTextInputField1(controller, hint, validator, maxLine,
    {bool isEnabled = true}) {
  return TextFormField(
    enabled: isEnabled,
    validator: validator,
    maxLines: maxLine,
    controller: controller,
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color.fromARGB(255, 240, 227, 202),
      hintText: hint,

      hintStyle: const TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
      //focusColor: Colors.black,
      //focusedBorder: const OutlineInputBorder(),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  );
  // const Spacer(), // 1/6
}
