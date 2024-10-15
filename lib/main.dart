import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário de Validação',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String _nome = '';
  String _email = '';
  String _senha = '';
  bool _isLoading = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (!value.contains('@')) {
      return 'E-mail inválido';
    }
    return null;
  }

  String? _validateSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  Future<void> _simulateNetworkCall() async {
    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });
      await _simulateNetworkCall();
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            nome: _nome,
            email: _email,
            senha: _senha,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Validação'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                      onSaved: (value) => _nome = value!,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: _validateEmail,
                      onSaved: (value) => _email = value!,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      obscureText: true,
                      validator: _validateSenha,
                      onSaved: (value) => _senha = value!,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      onPressed: _submitForm,
                      child: Text('Enviar'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final String nome;
  final String email;
  final String senha;

  ResultPage({required this.nome, required this.email, required this.senha});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados Salvos'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: $nome', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('E-mail: $email', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Senha: $senha', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
