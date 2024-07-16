// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:woocommerce_app/bloc/interventions_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:woocommerce_app/screen/fiche_client_page.dart';
import 'package:woocommerce_app/bloc/menu_bar.dart';
import 'package:woocommerce_app/bloc/bottom_app_bar.dart';

class ListeInterventionsPage extends StatefulWidget {

  var customer;  // Order place to this customer

  ListeInterventionsPage(this.customer);

  @override
  ListeInterventionsPageState createState() => new ListeInterventionsPageState(this);
}


class ListeInterventionsPageState extends State<ListeInterventionsPage> {

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late Widget _mainFormWidget = SizedBox.shrink();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late InterventionsBloc bloc;
  late ListeInterventionsPage parent;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? selectedProductOrResourceId;
  String selectedResourceKey = '0';
  TextEditingController textController = TextEditingController();

  late String userId = '';
  late String username= '';
  late String email= '';
  late String role = '';

  List<Map<String, dynamic>>? typeintervention;

  ListeInterventionsPageState(this.parent); // Initialize 'parent' with the provided parameter
  final List<IconData> icons = [Icons.email, Icons.phone];
  void onIconTapped(int index) {
    print('Icon $index tapped');
  }

  Future<String?> getEtatInterventionName(int id) async {
    final etatInterventions = await bloc.fetchEtatInterventionsData();
    print(etatInterventions);
    print("intervention etat");
    final intervention = etatInterventions.firstWhere((element) => element['id'] == id, orElse: () => null);

    print(intervention['name']);
    print("intervention name");
   // intervention != null ? intervention['name'] as String? : null;
   // print("intervention name");
   // print(intervention);

    return intervention != null ? intervention['name'] as String? : null;
  }

  @override
  void initState() {
    super.initState();
    bloc = InterventionsBloc();
    print("liste interventions");
    print(typeintervention);
    _mainFormWidget = mainBody();
    loadUserId().then((value) {
      setState(() {
        userId = value['userId'] ?? 'Unknown';
        username = value['username'] ?? 'Unknown';
        email = value['email'] ?? 'Unknown';
        role = value['role'] ?? 'Unknown';
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
            title: new Text("Interventions", style: TextStyle(color: Colors.black)),
            backgroundColor: Color(0xFFe8e0d7),
            actions: <Widget>[
            //  routeToCartWidget()
            ]),
        floatingActionButton: MenuBarr(),
        bottomNavigationBar: BottomAppBarDemo(
          icons: icons,
          onIconTapped: onIconTapped,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: body()
    );
  }
  /*
  * Return the main widget body
  */

  Widget body() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            formViewWidget(context),
          ],
        ),
      ),
    );
  }


  @override
   Widget formViewWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/bg-esthetique.jpg'),
          fit: BoxFit.cover, // Utilisez BoxFit.cover pour couvrir toute la hauteur du conteneur
          repeat: ImageRepeat.repeatY,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 520), // Définissez une hauteur maximale
          child: FutureBuilder(
            future: bloc.fetchInterventionsData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || (snapshot.data as List<dynamic>).isEmpty) {
                return Center(
                  child: Text('No data available.'),
                );
              } else {
                final interventions = (snapshot.data as List<dynamic>).where((intervention) => intervention['acf']['id_user'] == userId).toList();
                return ListView.builder(
                  itemCount: interventions.length,
                  itemBuilder: (context, index) {
                    final intervention = interventions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: InkWell(
                        onTap: () async {
                          final etat = await getEtatInterventionName(intervention['etat-d-intervention'][0]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FicheClientPage(
                                intervention['slug'],
                                etat: etat ?? 'Unknown',
                                idintervention: intervention['id'],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Color(0xFFe8e0d7),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  intervention['title']['rendered'] as String,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 10),
                                if(intervention['acf']['date_arrivage'] != null)
                                Text(
                                  "Date d'arrivée : ${intervention['acf']['date_arrivage'] as String}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 10),
                                FutureBuilder<String?>(
                                  future: getEtatInterventionName(intervention['etat-d-intervention'][0]),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      final etatInterventionName = snapshot.data ?? 'Unknown';
                                      if (etatInterventionName == 'Effectué') {
                                        return ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => FicheClientPage(
                                                intervention['slug'],
                                                etat: etatInterventionName,
                                                idintervention: intervention['id'],
                                                //   isCustomer: current_user_roles.contains('customer'), // Assuming current_user_roles contains the roles of the current user
                                              )),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFFA28275),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Upload photo",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        // Afficher le texte pour toutes les autres valeurs de etatInterventionName
                                        return Text(etatInterventionName);
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

 /* Widget formViewWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 500,
        child: Material(
          child: FutureBuilder(
            future: bloc.fetchInterventionsData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || (snapshot.data as List<dynamic>).isEmpty) {
                return Center(
                  child: Text('No data available.'),
                );
              } else {
               // final interventions = snapshot.data as List<dynamic>;
                final interventions = (snapshot.data as List<dynamic>).where((intervention) => intervention['acf']['id_user'] == userId).toList();
                print("list interventions");
                print(interventions);
                // Check if there are interventions with 'Effectué' in etat-d-intervention
                bool hasEffectueInterventions = interventions.any((intervention) => getEtatInterventionName(intervention['etat-d-intervention'][0]) == 'Effectué');
                print("hasEffectueInterventions");
                print(hasEffectueInterventions);
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Interventionsfff')),
                      DataColumn(label: Text('Date d\'arrivée')),
                      // ignore: unrelated_type_equality_checks
                     // if (interventions.any((intervention) => getEtatInterventionName(intervention['etat-d-intervention'][0]) == 'Effectué'))
                     // if (hasEffectueInterventions)
                      DataColumn(label: Text('Photos post opératoire')),
                      DataColumn(label: Text('Etat d\'intervention')),
                    ],
                    rows: interventions.map((intervention) {
                      return DataRow(
                        cells: [
                          DataCell(Text(intervention['title']['rendered'] as String)),
                          DataCell(Text(intervention['date'] as String)),
                          // ignore: unrelated_type_equality_checks


                          //if (getEtatInterventionName(intervention['etat-d-intervention'][0]) == 'Effectué')
                          DataCell(
                            FutureBuilder<String?>(
                              future: getEtatInterventionName(intervention['etat-d-intervention'][0]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final etatInterventionName = snapshot.data ?? 'Unknown';
                                  if (etatInterventionName == 'Effectué') {
                                    return SizedBox(
                                      width: 100,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => FicheClientPage(
                                              intervention['slug'],
                                              etat: etatInterventionName,
                                              idintervention: intervention['id'],
                                              //   isCustomer: current_user_roles.contains('customer'), // Assuming current_user_roles contains the roles of the current user
                                            )),
                                          );
                                        },
                                        child: Text('Upload photo'),
                                      ),// Adjust the width as needed
                                      /*child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => FicheClientPage(intervention['slug'])),
                                          );
                                        },
                                        child: Text('Upload photo'),
                                      ),*/
                                    );
                                  } else {
                                    return Text(' ');
                                  }
                                }
                              },
                            ),
                          ),
                          /*if (intervention['etat-d-intervention'] == 33)
                            DataCell(
                              SizedBox(
                                width: 100, // Adjust the width as needed
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => FicheClientPage(intervention['slug'])),
                                    );
                                  },
                                  child: Text('Upload photo'),
                                ),
                              ),
                            ),*/

                          // DataCell(Text(intervention['etat-d-intervention'].join(', '))),// Placeholder if `etat_d_intervention` is absent
                          DataCell(
                            FutureBuilder<String?>(
                              future: getEtatInterventionName(intervention['etat-d-intervention'][0]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final etatInterventionName = snapshot.data ?? 'Unknown';
                                  return Text(etatInterventionName);
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),

                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  } */
  Future<Map<String, String?>> loadUserId() async {
    final storage = FlutterSecureStorage();
    //return await storage.readAll();
    return {
      'userId': await storage.read(key: 'userId'),
      'username': await storage.read(key: 'username'),
      'email': await storage.read(key: 'email'),
      'role': await storage.read(key: 'role'),
      // Add other pieces of user information as needed
    };
  }

}
 /* Widget formViewWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity, // Or a specific width
        height: 200, // Or a specific height
          child: Material( // Add Material ancestor
            child: FutureBuilder(
              future: bloc.fetchInterventionsData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final interventions = snapshot.data as List<dynamic>; // Cast data to a list
                  print(interventions);
                  print("liste interventions");

                  return ListView.builder(
                    itemCount: interventions.length,
                    itemBuilder: (context, index) {
                      final intervention = interventions[index];
                      return Card(
                        child: ListTile(
                          title: Text(intervention['title']['rendered'] as String), // Access title
                          subtitle: Text(intervention['date'] as String), // Access date
                          // Add more widgets for other data fields as needed
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator(); // Loading indicator
                }
              },
            ),
          ),
        ),
    );
  }*/
