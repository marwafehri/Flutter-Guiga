import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:woocommerce_app/screen/dashboard_page.dart';
import 'package:provider/provider.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:woocommerce_app/screen/login_page.dart';

class ForgetLoginPage extends StatefulWidget {
  ForgetLoginPage();

  @override
  _ForgetLoginPageState createState() => _ForgetLoginPageState();

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

    // Add more keys if needed

    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ForgetLoginPage()),
    );
  }
}

class _ForgetLoginPageState extends State<ForgetLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Define _scaffoldKey
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future<void> sendResetPasswordEmail(String email, String resetKey, int userId) async {
    // Configure SMTP server settings with your SMTP server configuration
    final smtpServer = SmtpServer(
      'node79-eu.n0c.com',
      username: 'mobile@deveoo-ads.com',
      password: 'HI7AEE6Hw_cHAH*2AH',
      port: 587, // Use the appropriate port for your SMTP server
      // Enable encryption if required by your SMTP server
      // ssl: true,
      // tls: true,
    );

    // Create the email message with HTML body
    final message = Message()
      ..from = Address('drg@gmail.com', '[Dr.Bilel Guiga]')
      ..recipients.add(email)
      ..subject = 'Réinitialiser le mot de passe'
      ..html = '''
      <p>Bonjour,</p>
      <p>Quelqu’un a demandé une réinitialisation de mot de passe pour le compte suivant sur Dr.Bilel Guiga :</p>
      <p>Identifiant : $email</p>
      <p>Si vous n’êtes pas à l’origine de cette demande, ignorez simplement cet e-mail. Sinon :</p>
      <p><a href="https://www.drg.deveoo.net/mon-compte/lost-password?key=$resetKey&id=$userId">Cliquez ici pour réinitialiser votre mot de passe</a></p>
      <p>Merci de votre attention.</p>
    ''';

    try {
      // Send the email
      await send(message, smtpServer);
      print('Message sent successfully.');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('L’e-mail de réinitialisation du mot de passe a été envoyé.'),
            content: Text(
              "Un e-mail de réinitialisation de mot de passe a été envoyé à l’adresse e-mail de votre compte, mais cela peut prendre plusieurs minutes avant qu’il ne s’affiche dans votre boîte de réception. Veuillez patienter au moins 10 minutes avant de tenter une autre réinitialisation.",
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
           /* actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  LoginPage();
                },
              ),
            ],*/
          );
        },
      );
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  Future<void> getResetKeyAndSendEmail(String email) async {
    final String apiUrl = 'https://www.drg.deveoo.net/wp-json/custom/v1/get-reset-key';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String resetKey = data['reset_key'];
        final int userId = data['user_id'];

        // Send the email with the reset key
        await sendResetPasswordEmail(email, resetKey, userId);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> forgetLoginUser() async {
    final String email = emailController.text;
    var responseCustomers = await Const.wc_api.getLoginAsync("customers", email: email);
    var existeemail = responseCustomers.any((user) => user['email'] == email);

    if (!existeemail) {
      showDefaultSnackbar();
    } else {
      await getResetKeyAndSendEmail(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign the GlobalKey<FormState> to the form's key
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: kToolbarHeight, // Set the height to match the app bar height
                  width: 350, // Adjust the width as needed
                  child: Text(
                    "Réinitialiser le mot de passe",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: Color(0xFFA28275),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.key,
                    size: 100,
                    color: Color(0xFFA28275),
                  ),
                ],
              ),
              SizedBox(height: 30),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Votre e-mail'),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (String? val) {
                  if (val != null) {
                    return validateEmail(val);
                  }
                  return null;
                },
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFA28275)), // Background color
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // Border radius
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Proceed with the login process if the form is valid
                    forgetLoginUser();
                  }
                },
                child: Text(
                  'Obtenir un mot de passe',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDefaultSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Vérifier votre email pour le lien de configuration"),
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
}