import 'package:flutter/material.dart';
import 'Controller/controle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget tela = await Controle.selecionarTela();
  runApp(AppMotorista(telaInicial: tela));
}

class AppMotorista extends StatelessWidget {
  const AppMotorista({super.key, required this.telaInicial});
  final Widget telaInicial;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Rastreador do BusUFF",
      home: telaInicial
    );
  }
}
