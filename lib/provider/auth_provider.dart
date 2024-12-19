import 'package:chatapp/helper/local_point.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider  extends ChangeNotifier{
 bool _isAuthenticated = false ; 
 bool get isAuthenticated => _isAuthenticated ; 

 AuthProvider(){
  _checkAuthToken();
 }

Future<void>_checkAuthToken() async {
  final prefs = await SharedPreferences.getInstance() ; 
  final token = prefs.getString(LocalPoint.authToken) ; 

  if(token != null){
    _isAuthenticated = true ; 
  }else{
    _isAuthenticated = false  ; 
  }

  notifyListeners() ; 
}



Future<void>logout() async {
  final prefs = await SharedPreferences.getInstance() ; 
  await prefs.remove(LocalPoint.authToken) ; 
  _isAuthenticated = false ; 
  notifyListeners() ; 
}
}