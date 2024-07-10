// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:woocommerce_app/bloc/place_devis_bloc.dart';
import 'package:woocommerce_app/screen/liste_interventions_page.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:woocommerce_app/screen/login_page.dart';
import 'package:woocommerce_app/screen/dashboard_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:woocommerce_app/screen/home_page.dart';
import 'package:woocommerce_app/screen/our_bookings_page.dart';
import 'package:woocommerce_app/bloc/menu_bar.dart';
import 'package:woocommerce_app/bloc/bottom_app_bar.dart';
import 'package:woocommerce_app/screen/place_devis_page.dart';

class MonComptePage extends StatefulWidget {

  var customer;  // Order place to this customer

  MonComptePage(this.customer);

  @override
  MonComptePageState createState() => new MonComptePageState(this);
}


class MonComptePageState extends State<MonComptePage> {

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late Widget _mainFormWidget = SizedBox.shrink();
  final _scaffoldKey = GlobalKey< State>();
  late PlaceDevisBloc bloc;
  late MonComptePage parent;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? selectedProductOrResourceId;
  String selectedResourceKey = '0';
  TextEditingController textController = TextEditingController();

  List<Map<String, dynamic>>? typeintervention;

  MonComptePageState(this.parent); // Initialize 'parent' with the provided parameter
  late String userId = '';
  late String username= '';

  final List<IconData> icons = [Icons.email, Icons.phone];
  void onIconTapped(int index) {
    print('Icon $index tapped');
  }

  @override
  void initState() {
    super.initState();
    bloc = PlaceDevisBloc(parent.customer);
    print(bloc);
    _mainFormWidget = mainBody();
    // Load user ID when the widget is initialized
    loadUserId().then((value) {
      setState(() {
        userId = value['userId'] ?? 'Unknown';
        username = value['username'] ?? 'Unknown';
      });
    });
  }

  Widget build(BuildContext context) {
   // _context = context;
    if (_mainFormWidget == null) {
      _mainFormWidget = mainBody();
    }
    return _mainFormWidget; // Show the form in the application

  }

  Widget mainBody() {
    return new Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: new AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: new Text("Mon compte", style: TextStyle(color: Colors.black)),
            backgroundColor: Color(0xFFe8e0d7),
            actions: <Widget>[
            //  routeToCartWidget()
            ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      //CustomerListPage()));
                      HomePage())
              );
            },
          ),
        ),
        floatingActionButton: MenuBarr(),

        bottomNavigationBar: BottomAppBarDemo(
          icons: icons,
          onIconTapped: onIconTapped,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: body()
    );
  }

  Future<bool> isConnected() async {
    // Implement your logic to check if the user is connected
    // For example, you can check if customer is not null
    try {
      var result = await Const.wc_api.getDevisAsync("customers");
      print(result);
      print("result");
      // Update the condition based on your API response
      return result != null;
    } catch (error) {
      print('Error checking connection: $error');
      return false; // Assume not connected in case of an error
    }
    return widget.customer != null;
  }

  // Your existing methods (body, formViewWidget, etc.)

  Widget loginForm() {
    // Implement your login form widget here
    // Return the widget you want to show when not connected
    // For example, you can use FormBuilder for the login form
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          // ... (Your login form fields)
          ElevatedButton(
            onPressed: () {
              // Implement your login logic here
              // Example: Call your login function
              // var result = await Const.wc_api.loginAsync(username, password);
              // If login is successful, you can update the UI accordingly
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
  /*
  * Return the main widget body
  */

  /*Widget body() {
    return new Column(
        children: <Widget>[
         // formViewWidget(context),
          FutureBuilder(
            future: isConnected(), // Your function to check if connected
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data == true) {
                  return formViewWidget(context);
                } else {
                  return loginForm(); // Replace with your login form widget
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ]
    );
  }
*/
  Widget body() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/bg-esthetique.jpg'),
          fit: BoxFit.cover, // Use BoxFit.cover to cover the full height of the container
          repeat: ImageRepeat.repeatY,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: isConnected(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data == true) {
                    print("salimou $userId");
                    print(userId.isEmpty);
                    if (userId != 'Unknown') {
                      print("deconnecter");
                      return buildLoggedInWidget();
                    } else {
                      print("connecter");
                      return formViewWidget(context);
                    }
                  } else {
                    return loginForm();
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildLoggedInWidget() {
    return new Column(children: <Widget>[
      new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 15, top: 30, bottom: 0, right: 15),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DashboardPage()));
                          //   Navigator.pop(context);
                        },
                        child: Card(
                          color: Color(0xFFe8e0d7),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                SizedBox(height: 40,),
                                Icon(
                                  Icons.area_chart_outlined,
                                 // color: UIHelper.themeColor,
                                  color: Color(0xFFD3546E),
                                  size: 40,
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  'Tableau de bord',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(height: 40,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 15, top: 30, bottom: 0, right: 15),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ListeInterventionsPage(null)));
                          //   Navigator.pop(context);
                        },
                        child: Card(
                          color: Color(0xFFe8e0d7),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                SizedBox(height: 40,),
                                Icon(
                                  Icons.list,
                                  color: Color(0xFFD3546E),
                                  size: 40,
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  'Interventions',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(height: 40,),
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
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 15, top: 30, bottom: 30, right: 15),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceDevisPage()));
                          //   Navigator.pop(context);
                        },
                        child: Card(
                          color: Color(0xFFe8e0d7),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                SizedBox(height: 40,),
                                Icon(
                                  Icons.calendar_month,
                                  color: Color(0xFFD3546E),
                                  size: 40,
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  'Demander un devis',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(height: 40,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 15, top: 30, bottom: 30, right: 15),
                      child: InkWell(

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(), // Navigate to LoginPage
                            ),
                          ).then((_) => LoginPage().clearUserInformation(context));
                        },
                        child: Card(
                          color: Color(0xFFe8e0d7),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                SizedBox(height: 40,),
                                Icon(
                                  Icons.wifi_off,
                                  color: Color(0xFFD3546E),
                                  size: 40,
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  // 'Se déconnecter',
                                  'Deconnecter',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(height: 40,),
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
          ],
        ),
      ),
    ]
    );
  }
  @override
  Widget formViewWidget(BuildContext context) {

    return new Column(children: <Widget>[
      new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.transparent,
              child: Row(
                children: <Widget>[

                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 20, top: 30, bottom: 30, right: 15),
                      child: InkWell(

                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginPage()));
                          //   Navigator.pop(context);
                        },
                        child: Card(
                          color: Color(0xFFe8e0d7),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                SizedBox(height: 40,),
                                Icon(
                                  Icons.wifi,
                                  color: Color(0xFFD3546E),
                                  size: 40,
                                ),
                                SizedBox(height: 10,),
                                Text(
                                 // 'Se déconnecter',
                                  'Connecter',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 40,),
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
          ],
        ),
      ),
    ]);
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