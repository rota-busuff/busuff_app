import 'package:geolocator/geolocator.dart';

class Motorista {
  final String? id;
  final String? senha;
  final String? rota;
  late Position ultimaPosicao;

  Motorista(this.id, this.senha, this.rota) {
    ultimaPosicao = Position(
      latitude: 0.0,
      longitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
      floor: 0
    );
  }
}
