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

import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/screens/recorder_home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Text controllers for the input fields
  final TextEditingController _emailController =
      TextEditingController(text: "chattest1@yopmail.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "chattest");

  // Loading state and form key
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
                    'Welcome Back !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Login to continue Recording',
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

                      // Set loading to true when login starts
                    

                      try {
                        // Call login API function
                        await LoginApiFunction.login(
                          email: _emailController.text,
                          password: _passwordController.text,
                          context: context,
                          onSuccess: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString(
                                LocalPoint.userEmail, _emailController.text);

                            // Stop loading
                            setState(() {
                              isLoading = false;
                            });

                            // Navigate to the Users screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const 
                                RecorderHome(),
                              ),
                            );
                          },
                        );
                      } catch (error) {
                        // Handle any errors and stop loading
                        setState(() {
                          isLoading = false;
                        });

                        // Show error message
                        showError(context, "Login failed. Please try again.");
                      }
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
