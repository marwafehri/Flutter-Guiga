import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:woocommerce_app/screen/mon_compte_page.dart';
import 'package:woocommerce_app/screen/login_page.dart';
import 'package:woocommerce_app/bloc/menu_bar.dart';
import 'package:woocommerce_app/bloc/bottom_app_bar.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage();

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  late String userId = '';
  late String username = '';
  late String email = '';
  late String firstName = '';
  late String lastName = '';
  late String phone = '';
  late String role = '';
  late String billingNaissance = '';
  late String billingSexe = '';
  final List<IconData> icons = [Icons.email, Icons.phone];
  void onIconTapped(int index) {
    print('Icon $index tapped');
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    userId = await secureStorage.read(key: 'userId') ?? 'Unknown';
    print("loadUserData");
    print(userId);
    username = await secureStorage.read(key: 'username') ?? 'Unknown';
    email = await secureStorage.read(key: 'email') ?? 'Unknown';
    firstName = await secureStorage.read(key: 'first_name') ?? 'Unknown';
    lastName = await secureStorage.read(key: 'last_name') ?? 'Unknown';
    phone = await secureStorage.read(key: 'phone') ?? 'Unknown';
    role = await secureStorage.read(key: 'role') ?? 'Unknown';
    billingNaissance = await secureStorage.read(key: 'billing_naissance') ?? 'Unknown';
    billingSexe = await secureStorage.read(key: 'billing_sexe') ?? 'Unknown';

    setState(() {});
  }
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
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
              color: Colors.black
          ),
        ),
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
                    MonComptePage(null)));
          },
        ),
      ),
      floatingActionButton: MenuBarr(),

      bottomNavigationBar: BottomAppBarDemo(
        icons: icons,
        onIconTapped: onIconTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg-esthetique.jpg'),
            fit: BoxFit.cover, // Use BoxFit.cover to cover the full height of the container
            repeat: ImageRepeat.repeatY,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display user data in the dashboard
           // if (userData != null)
              Column(
                children: [
                 /* Text(
                    'Welcome to the Dashboard, User ID: $userId',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87
                    ),
                  ),*/
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Bonjour $username (vous n’êtes pas $username ? ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87
                          ),
                        ),
                        TextSpan(
                          text: 'Déconnexion',
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xFFA28275),
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              ).then((_) => LoginPage().clearUserInformation(context));
                            },
                        ),
                        TextSpan(
                          text: " )",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "À partir du tableau de bord de votre compte, vous pouvez visualiser vos commandes récentes, gérer vos adresses de facturation ainsi que changer votre mot de passe et les détails de votre compte.)",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87
                    ),
                  ),
                ],
              )
           // else
             // Text('Loading user data...'),
          ],
        ),
      ),
    );
  }
  Future<Map<String, String?>> loadUserId() async {
    final storage = FlutterSecureStorage();
    //return await storage.readAll();
    return {
      'userId': await storage.read(key: 'userId'),
      'username': await storage.read(key: 'username'),
      'email': await storage.read(key: 'email'),
      // Add other pieces of user information as needed
    };
  }
}