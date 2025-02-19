import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../Model/motorista.dart';
import '../View/home.dart';
import '../View/login.dart';
import 'autenticador.dart';
import 'localizador.dart';

class Controle {
  static Motorista motoristaLogado = Motorista(null, null, null);
  static bool? liberado;

  // chamada por main
  static Future<Widget> selecionarTela() async {
    bool conectado = await Autenticador.checar();

    if (conectado) {
      Motorista? motoristaArmazenado = await Autenticador.getMotorista();
      if (motoristaArmazenado != null) {
        motoristaLogado = motoristaArmazenado;
        return Home(motorista: motoristaLogado);
      }
    }
    return const Login();
  }

  // chamada por login
  static Future<bool?> iniciarConexao(String senhaTentativa) async {
    bool? logado = await Autenticador.logar(senhaTentativa);

    if (logado == true) {
      Motorista? motoristaArmazenado = await Autenticador.getMotorista();
      if (motoristaArmazenado != null) {
        motoristaLogado = motoristaArmazenado;
      }
    }

    return logado;
  }

  // chamada por home
  static void encerrarConexao() async {
    await Autenticador.deslogar();
    Localizador.encerrar();
    FlutterBackgroundService().invoke("stopService");
  }

  // chamada por home
  static void liberarAcesso() async {
    liberado = await Localizador.liberar();
    _liberarSegundoPlano();
  }

  static void _liberarSegundoPlano() async {
    final segundoPlano = FlutterBackgroundService();
    await segundoPlano.configure(
      androidConfiguration: AndroidConfiguration(onStart: _atividadeSegundoPlano, isForegroundMode: true, autoStart: true),
      iosConfiguration: IosConfiguration(onForeground: _atividadeSegundoPlano, autoStart: true),
    );
    segundoPlano.startService();
  }

  static void _atividadeSegundoPlano(ServiceInstance service) async {
    if (service is AndroidServiceInstance) {service.setAsForegroundService();}

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (service is AndroidServiceInstance && await service.isForegroundService()) {
        Position position = await Geolocator.getCurrentPosition();
        enviarLocalizacao(position);
      }
    });
  }

  static void enviarLocalizacao(Position atualPosicao) {
    debugPrint("ANTIGA: ${motoristaLogado.ultimaPosicao}");
    debugPrint("NOVA: $atualPosicao");
    if (Localizador.checarDistancia(motoristaLogado.ultimaPosicao, atualPosicao)) {
      // enviar posição
      motoristaLogado.ultimaPosicao = atualPosicao;
    }
  }

  // chamada por home
  static Stream<Position> receberLocalizacao() {
    return Localizador.localizacaoStream;
  }
}
