
import 'package:chatapp/screens/auth/login.dart';
import 'package:chatapp/screens/recorder_home.dart'; // Import the Users screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

void main() {
  runApp(MultiProvider(
    providers: [
      // ChangeNotifierProvider(create: (_) => MessageProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recorder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 203, 235, 250)),
        useMaterial3: true,
      ),
      home: const AuthChecker(), // Use a widget that checks the token
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthToken();
  }

  // Check if the token is present in SharedPreferences
  Future<void> _checkAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Retrieve the token

    if (token != null) {
      // If token exists, navigate to the Users screen
      setState(() {
        _isAuthenticated = true;
      });
    } else {
      // If no token, navigate to the Login screen
      setState(() {
        _isAuthenticated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If the authentication status is still being determined, show a loading spinner
    if (_isAuthenticated == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Otherwise, navigate to the appropriate screen based on auth status
    return _isAuthenticated ? const Login() : const RecorderHome();
  }
}
