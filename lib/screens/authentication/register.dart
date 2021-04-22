import '../../widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:howdy/services/auth.dart';
import 'package:howdy/widgets/loading.dart';
import 'package:howdy/screens/authentication/authentication.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AuthService _auth = AuthService();
  String _name = '', _email = '', _username = '', _password = '';
  TextEditingController _phoneController = TextEditingController();
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(title: Text('Crear cuenta'), centerTitle: true),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Nombre completo*',
                            icon: Icon(Icons.person_outline)),
                        validator: (val) =>
                            val.isEmpty ? 'Ingrese su nombre' : null,
                        onChanged: (val) {
                          setState(() => _name = val);
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Nombre de usuario*',
                            icon: Icon(Icons.person)),
                        validator: (val) =>
                            val.isEmpty ? 'Ingrese su nombre de usuario' : null,
                        onChanged: (val) {
                          setState(() => _username = val);
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Contraseña',
                            icon: Icon(Icons.visibility_off)),
                        validator: (val) => val.length < 8
                            ? 'Debe tener mínimo 8 caracteres'
                            : null,
                        onChanged: (val) {
                          setState(() => _password = val);
                        }),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Teléfono', icon: Icon(Icons.phone)),
                        controller: _phoneController,
                      )),
                  ElevatedButton(
                      child: Text('Crear cuenta'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => _loading = true);
                          dynamic result = await _auth.registerEmail(
                              _email,
                              _password,
                              _name,
                              _username,
                              _phoneController.text);
                          if (result == null) {
                            setState(() {
                              _loading = false;
                            });
                          }
                        }
                      }),
                  Text('¿Ya tienes una cuenta?'),
                  TextButton(
                      onPressed: () => goToPage(1, horizontal: false),
                      child: Text('Inicia sesión'))
                ],
              ),
            ),
          );
  }
}
