import 'package:app_motorista/View/login.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../Model/motorista.dart';
import '../Controller/controle.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.motorista});
  final Motorista? motorista;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Controle.liberarAcesso();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(36, 105, 166, 1),
        title: const Text(
          "Rastreador do BusUFF",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Controle.encerrarConexao();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Login()));
            },
            icon: const Icon(
              Icons.cancel,
              semanticLabel: "Sair",
              color: Color.fromRGBO(208, 97, 97, 1),
              size: 30,
            ),
          )
        ],
      ),
      
      body: Center(
        child: StreamBuilder<Position>(
          stream: Controle.receberLocalizacao(),
          builder: (context, snapshot) {
            Position? novaPosicao = snapshot.data;
            bool? acessoLiberado = Controle.liberado;

            // LIBEROU A LOCALIZAÇÃO
            if (acessoLiberado == true) {
              if (novaPosicao != null) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rocket_launch, color: Colors.green, size: 80),
                    SizedBox(height: 15),
                    Text("Compartilhando localização!")
                  ],
                );
              } else {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color.fromRGBO(245, 205, 22, 1)),
                    SizedBox(height: 15),
                    Text("Aguardando localização...")
                  ],
                );
              }

            // NEGOU A LOCALIZAÇÃO PRA SEMPRE
            } else if (acessoLiberado == false) {
              return ElevatedButton(
                onPressed: () async {Controle.liberarAcesso();},
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(208, 97, 97, 1)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide.none)),
                ),
                child: const Text(
                  "Permissão negada. Clique para tentar novamente.",
                  style: TextStyle(color: Colors.white),
                ),
              );

            // AGUARDANDO
            } else {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color.fromRGBO(245, 205, 22, 1)),
                  SizedBox(height: 15),
                  Text("Aguardando permissão...", textAlign: TextAlign.center)
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
