import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:woocommerce_app/screen/dashboard_page.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/screen/forget-login_page.dart';
import 'package:woocommerce_app/screen/customer_add.dart';
import 'package:woocommerce_app/screen/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
/*
class WordPressAuthService {
  final Dio _dio = Dio();

  Future<bool> login(String username, String password) async {
    print("fqsgedsg ");

    var response = await Constword.wc_apiword.loginPostAsync("token", {
      "email": username,
      "password": password,
    });

    print(response);
    print("fqsgedsg fsdqf");
    try {


      if (response.statusCode == 200) {
        final token = response.data['jwt_token'];
        await saveToken(token);
        return true;
      } else {
        // Handle login failure
        return false;
      }
    } catch (error) {
      print('Error during login: $error');
      return false;
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('jwt_token', token);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return token != null;
  }
}*/

class LoginPage extends StatefulWidget {
  LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();

  // Add a method to clear user information

  Future<void> clearUserInformation(BuildContext context) async {
    final storage = FlutterSecureStorage();

    // Delete stored values
    await storage.delete(key: 'userId');
    await storage.delete(key: 'username');
    await storage.delete(key: 'email');
    await storage.delete(key: 'phone');
    await storage.delete(key: 'first_name');
    await storage.delete(key: 'last_name');
    await storage.delete(key: 'billing_naissance');
    await storage.delete(key: 'billing_sexe');
    await storage.delete(key: 'role');

    // Navigate to the home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Define _scaffoldKey
  bool isPasswordVisible = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String userId = '';
  late String username= '';

  Future<void> loginUser() async {
    final String email = emailController.text;
    var responseCustomers = await Const.wc_api.getLoginAsync("customers", email: email);
    var existeemail = responseCustomers.any((user) => user['email'] == email);

    if (!existeemail) {
      showDefaultSnackbar();
    } else{
      if (responseCustomers.isNotEmpty) {
        var user = responseCustomers[0];
        // final String username = usernameController.text;
        final String username = user['username'];
        print(username);
        final String password = passwordController.text;
        final String apiUrlusers = 'https://www.drg.deveoo.net/wp-json/wp/v2/users/${user['id']}';
        print(apiUrlusers);
        //${user['id']}
        // final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';
        final String basicAuthusers = 'Basic ' +
            base64Encode(utf8.encode('$username:$password'));
        print(basicAuthusers);
        print("basicAuthusers");

        try {
          final http.Response responseusers = await http.get(
            Uri.parse(apiUrlusers),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': basicAuthusers,
            },
          );
          print("responseusers");
          print(responseusers.body);
          if (responseusers.statusCode == 201 ||
              responseusers.statusCode == 200) {
            // Save login information securely
            final storage = FlutterSecureStorage();
            await storage.write(key: 'userId', value: user['id'].toString());
            await storage.write(key: 'username', value: user['username']);
            await storage.write(key: 'first_name', value: user['billing']['first_name']);
            await storage.write(key: 'last_name', value: user['billing']['last_name']);
            await storage.write(key: 'email', value: user['email']);
            await storage.write(key: 'phone', value: user['billing']['phone']);
            await storage.write(key: 'role', value: user['role']);

            // Store billing_naissance for each user
            for (var data in user['meta_data']) {
              print(user['meta_data']);
              print("marwa");
              print(data['key']);
              print(data['value']);
              if (data['key'] == 'billing_naissance') {
                print("marwa 1");
                print(data['key']);
                print(data['value']);
                await storage.write(key: 'billing_naissance', value: data['value']);

              }
              if (data['key'] == 'billing_sexe') {
                print("marwa 2");
                print(data['key']);
                print(data['value']);
                await storage.write(key: 'billing_sexe', value: data['value']);

              }
            }


            await storage.write(key: basicAuthusers, value: basicAuthusers);


            print('Login successful. User ID: ${user['id']}');
            print('Login successful. billing_sexe: ${user['billing_sexe']}');
            // Navigate to the DashboardPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else {
            showDefaultSnackbar();
            print('Error logging in: ${user['id']}');
          }
        } catch (error) {
          print('Error creating post: $error');
        }
      }
    }
  }
  @override
  void initState() {
    super.initState();
    // Load user ID when the widget is initialized
    loadUserId().then((value) {
      setState(() {
        userId = value['userId'] ?? 'Unknown';
        username = value['username'] ?? 'Unknown';
      });
    });
  }
  /*appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: new Text("Connecter", style: TextStyle(color: Colors.black)),
          backgroundColor: Color(0xFFe8e0d7),
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
              color: Colors.black
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    //CustomerListPage()));
                    HomePage()));
          },
        ),
      ),*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Form(
                    key: _formKey, // Assign the GlobalKey<FormState> to the form's key
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/logo.png',
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 60),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Email'),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (String? val) {
                            if (val != null) {
                              return validateEmail(val);
                            }
                            return null;
                          },
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgetLoginPage(),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20).copyWith(bottom: 40),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  "Réinitialiser le mot de passe",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Color(0xFFA28275),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA28275), // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50), // Border radius
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Proceed with the login process if the form is valid
                              loginUser();
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                            child: Text(
                              'Connectez-vous par e-mail',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerAddPage(),
                              ),
                            );
                          },
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0).copyWith(bottom: 0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22,
                                      color: Colors.white,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Vous n'avez pas de compte? ",
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Color(0xFF000000),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "S'inscrire",
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Color(0xFFA28275),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // "Ignorer cette étape" button outside of the form

              ],
            ),
          ),
          /*Container(
            margin: const EdgeInsets.only(bottom: 40.0), // Add margin bottom
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA28275), // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // Border radius
                ),
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
              ),
              onPressed: () async {
                await widget.clearUserInformation(context);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: Text(
                  'Ignorer cette étape',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          */

          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 36,
              ),
              onPressed: () async {
                await widget.clearUserInformation(context);
              },
            ),
          ),

        ],
      ),
    );
  }

  void showDefaultSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Vous avez saisi un nom email ou un mot de passe non valide"),
      ),
    );
  }
  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
  Future<Map<String, String?>> loadUserId() async {
    final storage = FlutterSecureStorage();
    //return await storage.readAll();
    return {
      'userId': await storage.read(key: 'userId'),
      'username': await storage.read(key: 'username'),
    };
  }

}
