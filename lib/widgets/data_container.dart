import 'package:flutter/material.dart';

class DataContainer extends StatelessWidget {
  const DataContainer({
    Key? key,
    required this.value,
  }) : super(key: key);

  final num value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, right: 6),
      child: SizedBox(
          height: 50,
          width: 100,
          child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(100, 245, 247, 255),
                  borderRadius: BorderRadius.circular(6)),
              child: Center(child: Text(value.toStringAsPrecision(4))))),
    );
  }
}
