import 'package:flutter/material.dart';
import 'package:npsh/models/point.dart';

class NpshProvider extends ChangeNotifier {
  final List<num> percentages = [100, 95, 90, 85, 80];
  late List<Point> _points = [];
  num _rpmNom = 1200;
  String _marca = '';
  String _serie = '';
  num _potencia = 0;

  NpshProvider() {
    initializePoints();
  }

  List<Point> get allPoints => _points;

  num get rpmNom => _rpmNom;
  String get marca => _marca;
  String get serie => _serie;
  num get potencia => _potencia;

  void initializePoints() {
    _points = percentages
        .map((percentage) => Point(
            rpmNom: _rpmNom,
            percentageRpmNom: percentage,
            qInicial: 0,
            presionTresSuccion: 0))
        .toList();
  }

  void updatePointQInicial({required String id, required num newQInicial}) {
    int pointIndex = _points.indexWhere((point) => point.id == id);
    if (pointIndex == -1) return;

    Point pointToEdit = _points[pointIndex];
    _points[pointIndex] = Point(
        rpmNom: _rpmNom,
        percentageRpmNom: pointToEdit.percentageRpmNom,
        qInicial: newQInicial,
        presionTresSuccion: pointToEdit.presionTresSuccion);

    notifyListeners();
  }

  void updatePresionTresSuccion(
      {required String id, required num newPresionTres}) {
    int pointIndex = _points.indexWhere((point) => point.id == id);
    if (pointIndex == -1) return;

    Point pointToEdit = _points[pointIndex];
    _points[pointIndex] = Point(
        rpmNom: 1200,
        percentageRpmNom: pointToEdit.percentageRpmNom,
        qInicial: pointToEdit.qInicial,
        presionTresSuccion: newPresionTres);

    notifyListeners();
  }

  void updateRpmNom({required num newRpmNom}) {
    _rpmNom = newRpmNom;
    _points = _points
        .map((point) => Point(
            rpmNom: newRpmNom,
            percentageRpmNom: point.percentageRpmNom,
            presionTresSuccion: point.presionTresSuccion,
            qInicial: point.qInicial))
        .toList();
    notifyListeners();
  }

  void updateMarca({required String newMarca}) {
    _marca = newMarca;
  }

  void updateSerie({required String newSerie}) {
    _serie = newSerie;
  }

  void updatePotencia({required num newPotencia}) {
    _potencia = newPotencia;
  }

  bool get isReady => _points.every((point) =>
      point.qInicial != 0 &&
      point.presionTresSuccion != 0 &&
      point.qInicial.toString().isNotEmpty &&
      point.presionTresSuccion.toString().isNotEmpty);
}
