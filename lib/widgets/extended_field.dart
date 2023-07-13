import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExtendedField extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  final bool isNumber;

  const ExtendedField(
      {super.key,
      required this.controller,
      this.width = 100,
      this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6, right: 6),
      child: SizedBox(
          height: 50,
          width: width,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: isNumber
                ? const TextInputType.numberWithOptions(decimal: true)
                : null,
            inputFormatters: isNumber
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) => newValue.copyWith(
                        text: newValue.text.replaceAll('.', '.'),
                      ),
                    ),
                  ]
                : null,
            controller: controller,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                filled: true,
                fillColor: Color.fromARGB(244, 245, 247, 255)),
          )),
    );
  }
}
