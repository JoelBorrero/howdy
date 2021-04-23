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
  TextEditingController _emailController = TextEditingController(),
      _nameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _phoneController = TextEditingController(),
      _usernameController = TextEditingController();
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
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                        controller: _nameController,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Nombre completo*',
                            icon: Icon(Icons.person_outline)),
                        keyboardType: TextInputType.name,
                        validator: (val) =>
                            val.isEmpty ? 'Ingrese su nombre' : null),
                    TextFormField(
                        controller: _usernameController,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Nombre de usuario*',
                            icon: Icon(Icons.person)),
                        keyboardType: TextInputType.text,
                        validator: (val) => val.isEmpty
                            ? 'Ingrese su nombre de usuario'
                            : null),
                    TextFormField(
                        controller: _emailController,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Correo electrónico',
                            icon: Icon(Icons.email_outlined)),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) =>
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)
                                ? 'Verifique su correo electrónico'
                                : null),
                    TextFormField(
                        controller: _passwordController,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Contraseña',
                            icon: Icon(Icons.visibility_off)),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        validator: (val) => val.length < 8
                            ? 'Debe tener mínimo 8 caracteres'
                            : null),
                    TextFormField(
                        controller: _phoneController,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Teléfono', icon: Icon(Icons.phone)),
                        keyboardType: TextInputType.phone),
                    ElevatedButton(
                        child: Text('Crear cuenta'),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => _loading = true);
                            await _auth.registerEmail(
                                _emailController.text,
                                _passwordController.text,
                                _nameController.text,
                                _usernameController.text,
                                _phoneController.text);
                            _loading = false;
                          }
                        }),
                    Text('¿Ya tienes una cuenta?'),
                    TextButton(
                        onPressed: () => goToPage(1, horizontal: false),
                        child: Text('Inicia sesión'))
                  ],
                ),
              ),
            ),
          );
  }
}
