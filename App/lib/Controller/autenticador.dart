import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/motorista.dart';

class Autenticador {
  // chamada por controle.selecionarTela
  static Future<bool> checar() async {
    final preferencias = await SharedPreferences.getInstance();
    return preferencias.containsKey("id_motorista");
  }

  // chamada por controle.iniciarConexao
  static Future<bool?> logar(String senhaTentativa) async {
    //List<Map<String, dynamic>>? motoristas = await Autenticador._acessarAPI();
    List<Map<String, dynamic>>? motoristas = [
      {"id": "motorista", "senha": "senha123", "login": "rotaX"},
      {"id": "motorista", "senha": "senha321", "login": "rotaX"}
    ];

    if (motoristas != null) {
      // Compara os resultados da requisição com a senha inserida
      for (Map<String, dynamic> motorista in motoristas) {
        if (motorista["senha"]?.compareTo(senhaTentativa) == 0) {
          _setMotorista(motorista);
          return true;
        }
      }
      return false;
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> _acessarAPI() async {
    String link = "https://8293-177-12-9-161.ngrok-free.app/usuarios";
    http.Response resposta = await http.get(Uri.parse(link));

    if (resposta.statusCode == 200) {
      List<dynamic> dados = json.decode(resposta.body);
      List<Map<String, dynamic>> listaConvertida =
          dados.map((item) => Map<String, dynamic>.from(item)).toList();
      return listaConvertida;
    }

    return null;
  }

  static Future<void> _setMotorista(Map<String, dynamic> motorista) async {
    final preferencias = await SharedPreferences.getInstance();
    await preferencias.setString("id_motorista", motorista["id"].toString() ?? "");
    await preferencias.setString("senha_motorista", motorista["senha"] ?? "");
    await preferencias.setString("rota_motorista", motorista["login"] ?? "");
  }

  // chamada por controle.encerrarConexao
  static Future<void> deslogar() async {
    final preferencias = await SharedPreferences.getInstance();
    preferencias.clear();
  }

  // chamada por controle.selecionarTela e controle.iniciarConexao
  static Future<Motorista?> getMotorista() async {
    final preferencias = await SharedPreferences.getInstance();
    String? idMotorista = preferencias.getString("id_motorista");
    String? senhaMotorista = preferencias.getString("senha_motorista");
    String? rotaMotorista = preferencias.getString("rota_motorista");

    if (idMotorista == null || senhaMotorista == null || rotaMotorista == null) {
      return null; 
    }
    return Motorista(idMotorista, senhaMotorista, rotaMotorista);
  }
}
