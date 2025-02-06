import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Localizador {
  static StreamSubscription<Position>? _localizacaoSubscription;
  static final StreamController<Position> _localizacaoController = StreamController<Position>.broadcast();
  static Stream<Position> get localizacaoStream => _localizacaoController.stream;

  static Future<bool?> liberar() async {
    bool? liberado = false;

    bool habilitado = await Geolocator.isLocationServiceEnabled();
    if (!habilitado) {
      await Geolocator.openLocationSettings();
      return liberado;
    }

    PermissionStatus permitido = await Permission.location.request();
    if (permitido.isGranted) {
      PermissionStatus permitidoSempre = await Permission.locationAlways.request();
      liberado = permitidoSempre.isGranted;
      
    } else  {
      liberado = false;
    }

    if (liberado == true) {
      encerrar();
      _localizacaoSubscription = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 30),
      )).listen((Position novaPosicao) async {
        _localizacaoController.add(novaPosicao);
      });
    }

    return liberado;
  }

  static void encerrar() {
    _localizacaoSubscription?.cancel();
  }

  static bool checarDistancia(Position? ultimaPosicao, Position novaPosicao) {
    if (ultimaPosicao == null) return true;

    double conversor = 1;
    double uLat = ultimaPosicao.latitude * conversor;
    double uLon = ultimaPosicao.longitude * conversor;
    double nLat = novaPosicao.latitude * conversor;
    double nLon = novaPosicao.longitude * conversor;

    double distancia = Geolocator.distanceBetween(uLat, uLon, nLat, nLon);

    return (distancia > 0);
  }
}
