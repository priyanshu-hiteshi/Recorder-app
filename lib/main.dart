
import 'package:chatapp/provider/auth_provider.dart';
import 'package:chatapp/provider/player_provider.dart';
import 'package:chatapp/provider/recorder_provider.dart';
import 'package:chatapp/screens/auth/login.dart';
import 'package:chatapp/screens/recorder_home.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

void main() {
  runApp(MultiProvider(
    providers: [
      // ChangeNotifierProvider(create: (_) => MessageProvider()),
      ChangeNotifierProvider(create: (_) => RecorderProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()) , 
      ChangeNotifierProvider(create: (_) => PlayerProvider()) , 
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
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
     
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isAuthenticated == null) {
            return const Center(child: CircularProgressIndicator());
          }
          // return authProvider.isAuthenticated ? const RecorderHome() : const Login();
            return const RecorderHome(); 
        },
      ),
    );
  }
}