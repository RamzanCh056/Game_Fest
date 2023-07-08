

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesKey{
  static const String emailKey="email";
  static const String passwordKey="password";

}
class PreferencesServices{

  setPreferences(String email,String password)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    await prefs.setString(PreferencesKey.emailKey, email);
    await prefs.setString(PreferencesKey.passwordKey, password);
  }


  getEmailPreferences()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String email = prefs.getString(PreferencesKey.emailKey)!;
    return email;
  }
  getPasswordPreferences()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String password = prefs.getString(PreferencesKey.passwordKey)!;
    return password;
  }


}