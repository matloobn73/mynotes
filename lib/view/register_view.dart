import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import '../services/auth/auth_exceptions.dart';
import '../utilities/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: "Enter your email address"),
          ),
          TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: "Enter your password")),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await AuthService.firebase().createUser(
                        email: email, password: password)
                    .then((value) async {
                  await AuthService.firebase().sendEmailVerification()
                      .then((value) =>
                          Navigator.of(context).pushNamed(verifyEmail));
                });
              }
              on WeakPasswordAuthException catch (e){
                showErrorDialog(
                  context,
                  'Password is too weak!',
                );
              } on EmailAlreadyInUseAuthException catch(e){
                await showErrorDialog(
                  context,
                  'Email is already in use!',
                );
              }on InvalidEmailAuthException catch(e){
                await showErrorDialog(
                  context,
                  'Invalid email entered!',
                );

              }on GenericAuthException{
                await showErrorDialog(
                  context,
                  "Registration Error",
                );
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Already have an account? Sign In"))
        ],
      ),
    );
  }
}
