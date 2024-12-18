import 'dart:convert';

import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/helper/local_point.dart';
import 'package:chatapp/helper/msg_helper.dart';
import 'package:chatapp/screens/auth/auth-helper/signup_api_function.dart';
import 'package:chatapp/screens/auth/background.dart';
import 'package:chatapp/screens/auth/button_widget/elevated_button_widget.dart';
import 'package:chatapp/screens/auth/input_widgets/email_input_field.dart';
import 'package:chatapp/screens/auth/input_widgets/name_input_field.dart';
import 'package:chatapp/screens/auth/input_widgets/password_input_field.dart';
import 'package:chatapp/screens/auth/login.dart';
import 'package:chatapp/screens/otp/otp.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  //  final _emailController = TextEditingController(text: "testchat@yopmail.com");
  // final _passwordController = TextEditingController(text: "12345678");
  // final _nameController = TextEditingController(text: "testchat");


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text("Well to signup",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                NameInputField(nameController: _nameController),
                SizedBox(height: 20),
                EmailInputField(emailController: _emailController),
                const SizedBox(height: 20),
                PasswordInputField(passwordController: _passwordController),
                const SizedBox(height: 20),
                ElevatedButtonWidget(
                  buttonName: 'SIGN UP',
                  onPressed: () async {
                    // context.read<AuthProvider>().login();
                    // if (_formKey.currentState == null ||
                    //     !_formKey.currentState!.validate()) {
                    //   return;
                    // }

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OtpScreen(),
                          ),
                        );

                    await SignupApiFunction.signup(
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      context: context,
                      onSuccess: () {
                      
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
