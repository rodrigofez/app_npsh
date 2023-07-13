import "dart:math";
import 'package:uuid/uuid.dart';

class Point {
  final num rpmNom;
  final num percentageRpmNom;
  late num qInicial;
  late num presionTresSuccion;

  late String _id;
  late num _rpmEnsayo;
  late num _reynolds;
  late num _factorFriccion;
  late num _hbInicial;
  late num _qTres;
  late num _npshTres;

  String get id => _id;
  num get rpmEnsayo => _rpmEnsayo;
  num get reynolds => _reynolds;
  num get factorFriccion => _factorFriccion;
  num get hbInicial => _hbInicial;
  num get qTres => _qTres;
  num get npshTres => _npshTres;

  Point(
      {required this.rpmNom,
      required this.percentageRpmNom,
      required this.qInicial,
      required this.presionTresSuccion}) {
    _id = const Uuid().v4();
    _rpmEnsayo = calculateRpmEnsayo();
    _reynolds = calculateReynolds();
    _factorFriccion = calculateFactorFriccion(re: _reynolds);
    _hbInicial = calculateHbInicial(f: _factorFriccion);
    _qTres = calculateQTres(hbI: _hbInicial, f: _factorFriccion);
    _npshTres = calculateNpshTres(qTres: _qTres);
  }

  num calculateRpmEnsayo() => rpmNom * (percentageRpmNom / 100);

  num calculateReynolds() => 2416.23 * qInicial;

  num calculateFactorFriccion({required num re}) =>
      pow(1 / ((-1.8) * (log(6.9 / re)) / log(10)), 2);

  num calculateHbInicial({required num f}) =>
      ((0.00017174 * pow(qInicial, 2) * ((187.63 * f) + 4.1)) + 0.33);

  num calculateQTres({required num hbI, required num f}) =>
      15850.3 * sqrt(((0.97 * hbI) - 0.33) / (43146.88 * ((187.63 * f) + 6)));

  num calculateNpshTres({required qTres}) =>
      (((-(presionTresSuccion.abs()) + 98.155) * 1000) / (9780.57)) +
      (0.00017174 * pow(qTres, 2));
}
