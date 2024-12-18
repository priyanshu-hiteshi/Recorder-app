import 'dart:convert';
import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/helper/local_point.dart';
import 'package:chatapp/helper/msg_helper.dart';
import 'package:chatapp/screens/auth/auth-helper/login_api_function.dart';
import 'package:chatapp/screens/auth/background.dart';
import 'package:chatapp/screens/auth/button_widget/elevated_button_widget.dart';
import 'package:chatapp/screens/auth/signup.dart';
import 'package:chatapp/screens/auth/input_widgets/email_input_field.dart';
import 'package:chatapp/screens/auth/input_widgets/password_input_field.dart';
import 'package:chatapp/services/auth_api.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/screens/users.dart'; // Replace with your actual screen

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Text controllers for the input fields
  final TextEditingController _emailController =
      TextEditingController(text: "chattest1@yopmail.come");
  final TextEditingController _passwordController =
      TextEditingController(text: "chattest");
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();

  // Method to handle login
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BackgroundWidget(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Login to continue chatting',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Email Input Field
                  EmailInputField(emailController: _emailController),
                  const SizedBox(height: 20),

                  // Password Input Field
                  PasswordInputField(passwordController: _passwordController),
                  const SizedBox(height: 20),

                  // Login Button
                  ElevatedButtonWidget(
                    buttonName: 'LOGIN',
                    onPressed: () async {
                      if (_formKey.currentState == null ||
                          !_formKey.currentState!.validate()) {

                          
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      await LoginApiFunction.login(
                        email: _emailController.text,
                        password: _passwordController.text,
                        context: context,
                        onSuccess: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(
                              LocalPoint.userEmail, _emailController.text);

                               setState(() {
                            isLoading = false;
                          });

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Users(),
                            ),
                          );

                         
                        },
                      );
                    },
                  ),
                       const SizedBox(height: 40),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Signup Link
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return Signup();
                        },
                      ));
                      // Navigate to signup screen logic here
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
