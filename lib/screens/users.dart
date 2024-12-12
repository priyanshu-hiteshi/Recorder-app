import 'dart:convert';
import 'package:chatapp/app_config.dart';
import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/helper/local_point.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  List<dynamic> userList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Fetch users from the API
  Future<void> _fetchUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(LocalPoint.authToken); // Retrieve the token

    if (token == null) {
      // Handle the case when there is no token
      print("No token found. Please login.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}${EndPoints.users}'),
        headers: {
          'Authorization': 'Bearer $token', // Pass the token as a Bearer token
        },
      ).timeout(const Duration(seconds: 10)); // Timeout after 10 seconds

      if (response.statusCode == 200) {
        setState(() {
          userList = json.decode(response.body); // Parse the response body
          print(userList); // For debugging
          isLoading = false;
        });
      } else {
        // Handle non-200 response
        print("Failed to load users: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle any exceptions that occur during the API call
      print("Error during API request: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color:
            const Color.fromARGB(255, 206, 233, 255), // Light background color
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator()) // Show loading indicator
            : ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];
                  return Card(
                    color: Colors.white,
                    shape: null,
                    margin:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          user['name'][0], // First letter of the user's name
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        user['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(user['email']), // Show the user's email
                      trailing:
                          const Icon(Icons.message, color: Colors.blueAccent),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatScreen(userName: user['name']),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
