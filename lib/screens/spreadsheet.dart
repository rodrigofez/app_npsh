import 'package:flutter/material.dart';
import 'package:npsh/providers/npsh.dart';
import 'package:npsh/screens/plotter.dart';
import 'package:npsh/screens/point.dart';
import 'package:npsh/widgets/data_field.dart';
import 'package:npsh/widgets/extended_field.dart';
import 'package:provider/provider.dart';

class SpreadSheetScreen extends StatefulWidget {
  const SpreadSheetScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SpreadSheetScreenState();
  }
}

class _SpreadSheetScreenState extends State<SpreadSheetScreen> {
  Widget _buildHeader({required String title, String subtitle = ""}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6, right: 6),
      child: SizedBox(
          height: 48,
          width: 100,
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(10, 0, 0, 50),
                borderRadius: BorderRadius.circular(6)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (subtitle.isNotEmpty) Text(subtitle)
              ],
            ),
          )),
    );
  }

  late TextEditingController rpmNomController;
  late TextEditingController marcaController;
  late TextEditingController serieController;
  late TextEditingController potenciaController;

  void _updateRpmNom() {
    if (rpmNomController.text.isEmpty) return;
    Provider.of<NpshProvider>(context, listen: false)
        .updateRpmNom(newRpmNom: double.parse(rpmNomController.text));
  }

  void _updateMarca() {
    if (marcaController.text.isEmpty) return;
    Provider.of<NpshProvider>(context, listen: false)
        .updateMarca(newMarca: marcaController.text);
  }

  void _updateSerie() {
    if (serieController.text.isEmpty) return;
    Provider.of<NpshProvider>(context, listen: false)
        .updateSerie(newSerie: serieController.text);
  }

  void _updatePotencia() {
    if (potenciaController.text.isEmpty) return;
    Provider.of<NpshProvider>(context, listen: false)
        .updatePotencia(newPotencia: double.parse(potenciaController.text));
  }

  @override
  void initState() {
    super.initState();

    rpmNomController = TextEditingController(
        text: Provider.of<NpshProvider>(context, listen: false)
            .rpmNom
            .toString());
    rpmNomController.addListener(_updateRpmNom);

    marcaController = TextEditingController(
        text: Provider.of<NpshProvider>(context, listen: false).marca);
    marcaController.addListener(_updateMarca);

    serieController = TextEditingController(
        text: Provider.of<NpshProvider>(context, listen: false).serie);

    serieController.addListener(_updateSerie);

    potenciaController = TextEditingController(
        text: Provider.of<NpshProvider>(context, listen: false)
            .potencia
            .toString());

    potenciaController.addListener(_updatePotencia);
  }

  @override
  void dispose() {
    rpmNomController.dispose();
    marcaController.dispose();
    serieController.dispose();
    potenciaController.dispose();

    super.dispose();
  }

  void _plot(BuildContext context) {
    bool isReady = Provider.of<NpshProvider>(context, listen: false).isReady;

    if (!isReady) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Debes llenar todos los campos antes de continuar'),
          duration: const Duration(milliseconds: 1500),
          width: 280.0, // Width of the SnackBar.
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Plotter()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final NpshProvider npshProvider = Provider.of<NpshProvider>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('NPSH3 APP'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _plot(context);
          },
          child: const Icon(Icons.play_arrow_rounded),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Datos de la bomba (opcionales)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildHeader(title: "Marca"),
                          ExtendedField(
                            controller: marcaController,
                            width: 840,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          _buildHeader(title: "Serie"),
                          ExtendedField(
                            controller: serieController,
                            width: 840,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          _buildHeader(title: "Potencia (hp)"),
                          ExtendedField(
                            controller: potenciaController,
                            isNumber: true,
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: 940,
                    height: 1,
                    color: Colors.grey[200],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Datos del ensayo",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildHeader(title: "RPM nom"),
                          DataField(controller: rpmNomController)
                        ],
                      ),
                      Row(
                        children: [
                          _buildHeader(title: "% RPM nom"),
                          _buildHeader(title: "RPM ensayo"),
                          _buildHeader(title: "Q inicial", subtitle: "(gpm)"),
                          _buildHeader(title: "Re"),
                          _buildHeader(title: "f"),
                          _buildHeader(title: "H inicial", subtitle: "(m)"),
                          _buildHeader(title: "Q 3%", subtitle: "(gpm)"),
                          _buildHeader(title: "P 3%", subtitle: "(kPa)"),
                          _buildHeader(title: "NPSH3", subtitle: "(m)"),
                        ],
                      ),
                      SizedBox(width: 6),
                      ...npshProvider.allPoints
                          .map((point) => PointRow(
                                point: point,
                              ))
                          .toList(),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
