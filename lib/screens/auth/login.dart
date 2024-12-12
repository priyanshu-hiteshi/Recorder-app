import 'dart:convert';
import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/helper/local_point.dart';
import 'package:chatapp/helper/msg_helper.dart';
import 'package:chatapp/screens/auth/background.dart';
import 'package:chatapp/screens/auth/button_widget/elevated_button_widget.dart';
import 'package:chatapp/screens/auth/signup.dart';
import 'package:chatapp/screens/auth/input_widgets/email_input_field.dart';
import 'package:chatapp/screens/auth/input_widgets/password_input_field.dart';
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
  // final TextEditingController _emailController =
  //     TextEditingController(text: "loken82002@gmail.com");
  // final TextEditingController _passwordController =
  //     TextEditingController(text: "12345678");
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Method to handle login
  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      final body = {
        "email": email,
        "password": password,
        "socketId": "", // You can include the socketId if needed
      };
      final response = await ApiService.postRequest(
        endPoint: EndPoints.login,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        print("token from the api response $token");

        if (token != null) {
          // Store the token in shared preferences
          // SharedPreferencesHelper.setString(LocalPoint.authToken, token)
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              LocalPoint.authToken, token); // Wait for the token to be saved
          print("token stored $token");

          // Wait a short time to ensure the token is saved
          await Future.delayed(
              const Duration(milliseconds: 500)); // Wait for 500 ms

          // Navigate to the next screen (Users screen)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Users()),
          );
        } else {
          showError(context, "Token not received");
        }
      } else {
        showError(context, "Login failed. Please check your credentials.");
      }
    } else {
      showError(context, "Please enter both email and password.");
    }
  }

  // Method to show error messages

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
                    onPressed: () {
                      if (_formKey.currentState == null ||
                          !_formKey.currentState!.validate()) {
                        return;
                      } else {
                        _login();
                      }
                    },
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
