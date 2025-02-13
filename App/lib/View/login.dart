import 'package:flutter/material.dart';
import '../View/home.dart';
import '../Controller/controle.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // VARIÁVEL DA SENHA
  TextEditingController senhaController = TextEditingController();

  void _mensagemErro(BuildContext context, String erro) {
    var snackBar = SnackBar(
      content: Text(erro),
      backgroundColor: const Color.fromRGBO(209, 97, 97, 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(36, 105, 166, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // IMAGEM
              Image.asset('assets/onibus.png', width: MediaQuery.of(context).size.width * 0.45, height: 100),

              // ÁREA DE LOGIN
              Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // CAMPO DA SENHA
                    TextField(
                      controller: senhaController,
                      decoration: InputDecoration(
                        labelText: "Digite sua senha",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    
                    const SizedBox(height: 20),

                    // BOTÃO DE ENVIAR
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final sucessoLogin = await Controle.iniciarConexao(senhaController.text);

                        if (sucessoLogin == true) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home(motorista: Controle.motoristaLogado)));

                        } else if (sucessoLogin == false) {
                          _mensagemErro(context, "Senha incorreta. Tente novamente!");

                        } else {
                          _mensagemErro(context, "Sistema fora do ar!");
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(36, 105, 166, 1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      
                      child: const Text("Enviar"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
