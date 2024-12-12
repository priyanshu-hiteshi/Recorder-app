import 'package:chatapp/screens/auth/background.dart';
import 'package:chatapp/screens/auth/button_widget/elevated_button_widget.dart';
import 'package:chatapp/screens/auth/input_widgets/email_input_field.dart';
import 'package:chatapp/screens/auth/input_widgets/password_input_field.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EmailInputField(emailController: _emailController),
              const SizedBox(height: 20),
              PasswordInputField(passwordController: _passwordController),
              const SizedBox(height: 20),
              ElevatedButtonWidget(
                buttonName: 'SIGN UP',
                backgroundColor: Colors.amber,
                onPressed: () {
                  // context.read<AuthProvider>().login();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
