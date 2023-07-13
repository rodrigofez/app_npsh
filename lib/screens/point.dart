import 'package:flutter/material.dart';
import 'package:npsh/models/point.dart';
import 'package:npsh/providers/npsh.dart';
import 'package:npsh/widgets/data_container.dart';
import 'package:npsh/widgets/data_field.dart';
import 'package:provider/provider.dart';

class PointRow extends StatefulWidget {
  final Point point;

  const PointRow({super.key, required this.point});

  @override
  State<PointRow> createState() => _PointRowState();
}

class _PointRowState extends State<PointRow> {
  final qInicialController = TextEditingController();
  final pTresController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    qInicialController.addListener(_updateQInicial);
    pTresController.addListener(_updatePTres);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _updateQInicial listener.
    qInicialController.dispose();
    pTresController.dispose();

    super.dispose();
  }

  void _updateQInicial() {
    if (qInicialController.text.isEmpty) return;
    Provider.of<NpshProvider>(context, listen: false).updatePointQInicial(
        id: widget.point.id,
        newQInicial: double.parse(qInicialController.text));
    print('First text field: ${qInicialController.text}');
  }

  void _updatePTres() {
    if (pTresController.text.isEmpty) return;

    Provider.of<NpshProvider>(context, listen: false).updatePresionTresSuccion(
        id: widget.point.id,
        newPresionTres: double.parse(pTresController.text));
    print('Second text field: ${pTresController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DataContainer(value: widget.point.percentageRpmNom),
        DataContainer(value: widget.point.rpmEnsayo),
        DataField(controller: qInicialController),
        DataContainer(value: widget.point.reynolds),
        DataContainer(value: widget.point.factorFriccion),
        DataContainer(value: widget.point.hbInicial),
        DataContainer(value: widget.point.qTres),
        DataField(controller: pTresController),
        DataContainer(value: widget.point.npshTres),
      ],
    );
  }
}
