import 'authentication.dart';
import 'package:flutter/material.dart';
import 'package:howdy/services/auth.dart';
import 'package:howdy/widgets/loading.dart';
import 'package:howdy/widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService _auth = AuthService();
  FirebaseAuth a = FirebaseAuth.instance;
  String _email = '', _password = '', _error = '';
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  /*GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  _gLogin() async {
    var user = await _handleSignIn();
    print(user == null);
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    //final FirebaseUser user = (await a.signInWithCredential(credential)).user;
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print('Entró ' + user.displayName);
    return user;
  }*/

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(title: Text('Iniciar sesión'), centerTitle: true),
            body: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Correo electrónico',
                                icon: Icon(Icons.person)),
                            validator: (val) =>
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? 'Verifique su correo electrónico'
                                    : null,
                            onChanged: (val) {
                              setState(() => _email = val);
                            }),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Contraseña',
                                  icon: Icon(Icons.person)),
                              validator: (val) =>
                                  val.isEmpty ? 'Ingrese su contraseña' : null,
                              onChanged: (val) {
                                setState(() => _password = val);
                              })),
                      Text(_error, style: TextStyle(color: Colors.red[900])),
                      ElevatedButton(
                          child: Text('Continuar'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => _loading = true);
                              dynamic result =
                                  await _auth.signInEmail(_email, _password);
                              if (result == null) {
                                setState(() {
                                  _error = 'Por favor, verifique sus datos';
                                  _loading = false;
                                });
                              }
                            }
                          }),
                      Text('¿Aún no tienes una cuenta?'),
                      TextButton(
                          onPressed: () => goToPage(2, horizontal: false),
                          child: Text('Crea una cuenta')),
                      TextButton(
                          child: Text('Iniciar con Google'),
                          onPressed: () {}) //_gLogin()),
                    ])));
  }
}
