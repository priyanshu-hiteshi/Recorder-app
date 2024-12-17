import 'dart:convert';
import 'package:chatapp/app_config.dart';
import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/helper/local_point.dart';
import 'package:chatapp/screens/user-helper/user_fetch_function.dart';
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
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? loggedInUserEmail = prefs.getString(LocalPoint.userEmail);
      final users = await UserFetchFunction.fetchUsers();

      final filteredUsers = users.where((user) {
        return user['email'] != loggedInUserEmail;
      }).toList();

      setState(() {
        userList = filteredUsers;
        isLoading = false;
      });
    } catch (e) {
      // Handle errors during user fetching
      print("Error loading users: $e");
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
        color: const Color.fromARGB(255, 206, 233, 255),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : userList.isEmpty
                ? const Center(child: Text("No users found."))
                : ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final user = userList[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              user['name'] != null && user['name'].isNotEmpty
                                  ? user['name'][0]
                                  : '?', // Fallback for empty name
                            ),
                          ),
                          title: Text(user['name'] ?? 'Unknown'),
                          subtitle: Text(user['email'] ?? 'No email'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatScreen(userName: user['name'] , userId: user['id'] as int),
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
