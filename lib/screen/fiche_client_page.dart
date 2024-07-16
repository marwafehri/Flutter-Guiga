import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:file_picker/file_picker.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:file_picker/file_picker.dart'; // For picking files
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:woocommerce_app/bloc/menu_bar.dart';
import 'package:woocommerce_app/bloc/bottom_app_bar.dart';



class FicheClientPage extends StatefulWidget {
  final String slug;
  final String etat;
  final int idintervention;

  FicheClientPage(this.slug, {required this.etat, required this.idintervention});

  @override
  FicheClientPageState createState() => new FicheClientPageState();
}


class FicheClientPageState extends State<FicheClientPage> {
  late Widget _mainFormWidget = SizedBox.shrink();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late WebViewController controller;

  late String userId = '';
  late String username= '';
  late String first_name= '';
  late String last_name= '';
  late String email= '';
  late String phone= '';
  late String billing_sexe= '';
  late String formattedNaissanceDate= '';
  late String role = '';

  List<XFile>? _selectedFiles = [];
  //List<XFile>? _selectedFilesMedecin = [];
  Map<int, List<XFile>> _selectedFilesMedecin = {};
  Map<int, List<XFile>> _selectedFilesMedecinCertif = {};

  Map<String, bool> fileInputVisibility = {};
  Map<String, bool> fileInputVisibilityMedecin = {};
  Map<String, bool> fileInputVisibilityMedecincertif = {};

  TextEditingController dateArrivage = TextEditingController();
  TextEditingController dateDepart = TextEditingController();
  DateTime? dateInputendMinDate;
  TextEditingController prix = TextEditingController();
  TextEditingController medicaments = TextEditingController();

  final List<IconData> icons = [Icons.email, Icons.phone];
  void onIconTapped(int index) {
    print('Icon $index tapped');
  }

  @override
  void initState() {
    super.initState();
    dateArrivage.text = "";
    dateDepart.text = "";
    prix.text = "";
    medicaments.text = "";
    _fetchAndSetVisibility();
    _mainFormWidget = mainBody();
    // Load user ID when the widget is initialized
    loadUserId().then((value) {
      setState(() {
        userId = value['userId'] ?? 'Unknown';
        username = value['username'] ?? 'Unknown';
        first_name = value['first_name'] ?? 'Unknown';
        last_name = value['last_name'] ?? 'Unknown';
        email = value['email'] ?? 'Unknown';
        phone = value['phone'] ?? 'Unknown';
        billing_sexe = value['billing_sexe'] ?? 'Unknown';
        formattedNaissanceDate = value['billing_naissance'] ?? 'Unknown';
        role = value['role'] ?? 'Unknown';
        print('role: $role');
        print('Billing Naissance: $formattedNaissanceDate');
      });
    });
  }

  Future<List<dynamic>> getDataClient() async {
    final String listdatasClients = 'https://www.drg.deveoo.net/wp-json/wp/v2/intervention-client/${widget.idintervention}';
    final String acfUrl = '$listdatasClients?_fields=acf&acf_format=standard';
    final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

    try {
      final http.Response response = await http.get(
        Uri.parse(listdatasClients),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuthusers,
        },
      );
      final http.Response acfResponse = await http.get(
        Uri.parse(acfUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuthusers,
        },
      );

      if (response.statusCode == 200 && acfResponse.statusCode == 200) {
        final dynamic decodedInterventionResponse = json.decode(response.body);
        final dynamic decodedAcfResponse = json.decode(acfResponse.body);

        if (decodedInterventionResponse is Map<String, dynamic> && decodedAcfResponse is Map<String, dynamic>) {
          // Combine intervention data and ACF details into a single map
          Map<String, dynamic> decodedResponse = {...decodedInterventionResponse, 'acf': decodedAcfResponse['acf']};
          return [decodedResponse];
        } else {
          throw Exception('Invalid response format: Map expected');
        }
      } else {
        throw Exception('Failed to load data, HTTP status code ${response.statusCode}');
      }

     /* if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);
        // Assuming the data you want is a list
        if (decodedResponse is !List) {
          return [decodedResponse];
        } else {
          throw Exception('Expected list structure not found');
        }
      } else {
        throw Exception('Failed to load data, HTTP status code ${response.statusCode}');
      }*/
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error fetching data: $e');
      rethrow; // Rethrow the exception to propagate it to the caller
    }
  }

  Future<void> _pickFiles(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    print("result reserver client");
    print(result);
    if (result != null) {
      setState(() {
        _selectedFiles ??= List<XFile>.empty(growable: true);
        _selectedFiles!.addAll(result.paths.whereNotNull().map((path) => XFile(path)));
      });
    }
  }
  Future<void> _pickFilesMedecin(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _selectedFilesMedecin[index] = result.paths
            .whereNotNull()
            .map((path) => XFile(path))
            .toList();
      });
    }
  }
  Future<void> _pickFilesMedecinCertif(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _selectedFilesMedecinCertif[index] = result.paths
            .whereNotNull()
            .map((path) => XFile(path))
            .toList(); // Store files for this index

      });
    }
  }
 /* Future<void> _pickFilesMedecin(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    print("result reserver client");
    print(result);
    if (result != null) {
      setState(() {
        _selectedFilesMedecin ??= List<XFile>.empty(growable: true);
        _selectedFilesMedecin!.addAll(result.paths.whereNotNull().map((path) => XFile(path)));
      });
    }
  }*/
  Future<void> _fetchAndSetVisibility() async {
    final String url = 'https://www.drg.deveoo.net/wp-json/wp/v2/intervention-client/${widget.idintervention}';
    final String basicAuth = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';
    final http.Response responseexitfile = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': basicAuth,
      },
    );
    // For brevity, assuming 'responseexitfile' is your fetched HTTP response
    if (responseexitfile.statusCode == 200) {
      final dynamic decodedResponse = json.decode(responseexitfile.body);
      print("_fetchAndSetVisibility");
      print(decodedResponse);

      Map<String, bool> tempVisibility = {};
      Map<String, bool> tempVisibilityMedecin = {};
      Map<String, bool> tempVisibilityMedecincertif = {};
      decodedResponse['acf'].forEach((key, value) {
        if (key.startsWith('opest_oper_customer')) {
          if (value == null || value.toString().isEmpty) { // Check if value is null or empty string
            bool isVisible = value = false; // Assuming non-false means visible
            tempVisibility[key] = isVisible;
          }

        }
        if (key.startsWith('opest_operatoire')) {
         // print(key.startsWith('opest_operatoire'));
         //print(key);
         // print(value);
          if (value == null || value.toString().isEmpty) { // Check if value is null or empty string
            bool isVisible = value = false; // Assuming non-false means visible
            tempVisibilityMedecin[key] = isVisible;
          }

        }
        if (key.startsWith('certificat')) {
         // print(key.startsWith('certificat'));
          if (value == null || value.toString().isEmpty) { // Check if value is null or empty string
            bool isVisible = value = false; // Assuming non-false means visible
            tempVisibilityMedecincertif[key] = isVisible;
          }
        }
      });

      setState(() {
        fileInputVisibility = tempVisibility; // Properly update the state
        fileInputVisibilityMedecin = tempVisibilityMedecin;
        fileInputVisibilityMedecincertif = tempVisibilityMedecincertif;
      });
    }
  }
  Future<void> _submitForm() async {
    final String url = 'https://www.drg.deveoo.net/wp-json/wp/v2/intervention-client/${widget.idintervention}';
    final String basicAuth = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';
    String uploadUrl = "https://www.drg.deveoo.net/wp-json/wp/v2/media";
    List<int> mediaIds = []; // To store uploaded media IDs
    Map<String, dynamic> acfData = {}; // ACF data initialization moved here

    // Check if there are files selected
    if (_selectedFiles != null) {
      for (var i = 0; i < _selectedFiles!.length; i++) {
        var file = _selectedFiles![i];
        var fileName = file.path.split('/').last;
        String formattedDateString = DateFormat('yyyy-MM-dd hh:mm:ssa').format(DateTime.now());

        try {
          Dio dio = Dio();
          dio.options.headers.addAll({
            'Authorization': basicAuth,
            'Content-Disposition': 'attachment; filename=$fileName',
            'Content-Type': 'image/jpeg',
          });

          FormData formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(file.path, filename: fileName),
          });

          var response = await dio.post(uploadUrl, data: formData);
          if (response.statusCode == 201) {
            print("File uploaded: ${response.data}");
            int mediaId = response.data['id'];
            mediaIds.add(mediaId); // Collecting media ID

            // Update ACF data for each file
            //acfData['opest_oper_customer$i'] = mediaId;
            //acfData['date_oper_customer$i'] = formattedDateString;
            fileInputVisibility.entries.forEach((entry) {
              // Check if the entry value is true (visible)

             //  if (entry.value) {
                // Extract the numeric part from the entry key
                final indexString = entry.key.replaceAll(RegExp(r'[^0-9]'), '');
                // Parse the extracted numeric part into an integer
                final index = int.tryParse(indexString);
                if (index != null) {
                  // Update ACF data for each file
                  acfData['opest_oper_customer$index'] = mediaId;
                  acfData['date_oper_customer$index'] = formattedDateString;
                } else {
                  print('Invalid index format for key ${entry.key}');
                }
             //  }
            });

          } else {
            print("Failed to upload file: ${response.statusCode}");
          }
        } catch (e) {
          print("Error uploading file: $e");
          return; // Early exit on failure
        }
      }
    }
    // Step 2: Update ACF fields
    if (mediaIds.isNotEmpty) {
        try {
          final response = await http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': basicAuth,
            },
            body: jsonEncode({
              "acf": acfData,
            }),
          );

          print("ACF Update Response: ${response.body}");
          if (response.statusCode == 200) {
            showDefaultSnackbar();
            print('ACF fields updated successfully');
          } else {
            print('Failed to update ACF fields: ${response.statusCode}');
          }
        } catch (e) {
          print("Error updating ACF fields: $e");
        }

    }
  }
  Future<void> _submitFormMedecin() async {
    final String url = 'https://www.drg.deveoo.net/wp-json/wp/v2/intervention-client/${widget.idintervention}';
    final String basicAuth = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';
    String uploadUrl = "https://www.drg.deveoo.net/wp-json/wp/v2/media";
    List<int> mediaIds = [];
    List<int> certifIds = [];
    Map<String, dynamic> acfData = {};

    try {
      // Convert keys from int to String for _selectedFilesMedecin
      Map<String, List<XFile>> selectedFilesMedecinAsString = {};
      _selectedFilesMedecin.forEach((key, value) {
        selectedFilesMedecinAsString[key.toString()] = value;
      });
      // Convert keys from int to String for _selectedFilesMedecinCertif
      Map<String, List<XFile>> selectedFilesMedecinCertifAsString = {};
      _selectedFilesMedecinCertif.forEach((key, value) {
        selectedFilesMedecinCertifAsString[key.toString()] = value;
      });

      // Upload files for _selectedFilesMedecin
      await _uploadFiles(selectedFilesMedecinAsString, uploadUrl, basicAuth, mediaIds, certifIds, acfData, 'opest_operatoire');

      // Upload files for _selectedFilesMedecinCertif
      await _uploadFiles(selectedFilesMedecinCertifAsString, uploadUrl, basicAuth, mediaIds, certifIds, acfData, 'certificat');

      // Set other ACF fields
      if (dateArrivage.text.isNotEmpty) {
        acfData['date_arrivage'] = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(dateArrivage.text));
      }
      if (dateDepart.text.isNotEmpty) {
        acfData['date_depart'] = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(dateDepart.text));
      }
      if (prix.text.isNotEmpty) {
        acfData['prix'] = prix.text;
      }
      if (medicaments.text.isNotEmpty) {
        acfData['medicaments'] = medicaments.text;
      }

      // Update ACF fields
      if (mediaIds.isNotEmpty || certifIds.isNotEmpty) {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': basicAuth,
          },
          body: jsonEncode({"acf": acfData}),
        );

        if (response.statusCode == 200) {
          showDefaultSnackbar();
          print('ACF fields updated successfully');
        } else {
          print('Failed to update ACF fields: ${response.statusCode}');
        }
      }

    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _uploadFiles(Map<String, List<XFile>> filesMap, String uploadUrl, String basicAuth, List<int> mediaIds, List<int> certifIds, Map<String, dynamic> acfData, String fieldPrefix) async {
    for (var entry in filesMap.entries) {
      var index = entry.key;
      var files = entry.value;

      for (var file in files) {
        var fileName = file.path.split('/').last;

        try {
          Dio dio = Dio();
          dio.options.headers.addAll({
            'Authorization': basicAuth,
            'Content-Disposition': 'attachment; filename=$fileName',
            'Content-Type': 'image/jpeg',
          });

          FormData formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(file.path, filename: fileName),
          });

          var response = await dio.post(uploadUrl, data: formData);
          if (response.statusCode == 201) {
            int mediaId = response.data['id'];
            if (fieldPrefix == 'opest_operatoire') {
              mediaIds.add(mediaId);
              acfData['$fieldPrefix$index'] = mediaId;
            } else if (fieldPrefix == 'certificat') {
              certifIds.add(mediaId);
              acfData['$fieldPrefix$index'] = mediaId;
            }
          } else {
            print("Failed to upload file: ${response.statusCode}");
          }
        } catch (e) {
          print("Error uploading file: $e");
          throw e; // Propagate the error to the caller
        }
      }
    }
  }
 /* Future<void> _submitFormMedecin() async {
    final String url = 'https://www.drg.deveoo.net/wp-json/wp/v2/intervention-client/${widget.idintervention}';
    final String basicAuth = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';
    String uploadUrl = "https://www.drg.deveoo.net/wp-json/wp/v2/media";
    List<int> mediaIds = [];
    Map<String, dynamic> acfData = {};

    if (_selectedFilesMedecin.isNotEmpty) {
      for (var entry in _selectedFilesMedecin.entries) {
        var index = entry.key;
        var files = entry.value;

        for (var file in files) {
          var fileName = file.path.split('/').last;

          try {
            Dio dio = Dio();
            dio.options.headers.addAll({
              'Authorization': basicAuth,
              'Content-Disposition': 'attachment; filename=$fileName',
              'Content-Type': 'image/jpeg',
            });

            FormData formData = FormData.fromMap({
              'file': await MultipartFile.fromFile(file.path, filename: fileName),
            });

            var response = await dio.post(uploadUrl, data: formData);
            if (response.statusCode == 201) {
              int mediaId = response.data['id'];
              mediaIds.add(mediaId);
              // Assuming you only want to attach each mediaId to its respective field index
              acfData['opest_operatoire$index'] = mediaId;
            } else {
              print("Failed to upload file: ${response.statusCode}");
            }
          } catch (e) {
            print("Error uploading file: $e");
            return; // Early exit on failure
          }
        }
      }
      for (var entry in _selectedFilesMedecinCertif.entries) {
        var index = entry.key;
        var files = entry.value;

        for (var file in files) {
          var fileName = file.path.split('/').last;

          try {
            Dio dio = Dio();
            dio.options.headers.addAll({
              'Authorization': basicAuth,
              'Content-Disposition': 'attachment; filename=$fileName',
              'Content-Type': 'image/jpeg',
            });

            FormData formData = FormData.fromMap({
              'file': await MultipartFile.fromFile(file.path, filename: fileName),
            });

            var response = await dio.post(uploadUrl, data: formData);
            if (response.statusCode == 201) {
              int mediaId = response.data['id'];
              mediaIds.add(mediaId);
              // Assuming you only want to attach each mediaId to its respective field index
              acfData['certificat$index'] = mediaId;
            } else {
              print("Failed to upload file: ${response.statusCode}");
            }
          } catch (e) {
            print("Error uploading file: $e");
            return; // Early exit on failure
          }
        }
      }

      acfData['date_arrivage'] = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(dateArrivage.text));
      acfData['date_depart'] = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(dateDepart.text));
      acfData['prix'] = prix.text;
      acfData['medicaments'] = medicaments.text;

      if (mediaIds.isNotEmpty) {
        try {
          final response = await http.post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': basicAuth,
            },
            body: jsonEncode({"acf": acfData}),
          );

          if (response.statusCode == 200) {
            showDefaultSnackbar();
            print('ACF fields updated successfully');
          } else {
            print('Failed to update ACF fields: ${response.statusCode}');
          }
        } catch (e) {
          print("Error updating ACF fields: $e");
        }
      }
    }
  }*/
 /* Future<void> _submitFormMedecin() async {
    final String url = 'https://www.drg.deveoo.net/wp-json/wp/v2/intervention-client/${widget.idintervention}';
    final String basicAuth = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';
    String uploadUrl = "https://www.drg.deveoo.net/wp-json/wp/v2/media";
    List<int> mediaIds = []; // To store uploaded media IDs
    Map<String, dynamic> acfData = {}; // ACF data initialization moved here
    print("marwa");
    // Check if there are files selected
    if (_selectedFilesMedecin != null) {
      for (var i = 0; i < _selectedFilesMedecin!.length; i++) {
        var file = _selectedFilesMedecin![i];

        var fileName = file.path.split('/').last;

        try {
          Dio dio = Dio();
          dio.options.headers.addAll({
            'Authorization': basicAuth,
            'Content-Disposition': 'attachment; filename=$fileName',
            'Content-Type': 'image/jpeg',
          });

          FormData formDatamedecin = FormData.fromMap({
            'file': await MultipartFile.fromFile(file.path, filename: fileName),
          });

          var response = await dio.post(uploadUrl, data: formDatamedecin);
          if (response.statusCode == 201) {
            print("File uploaded: ${response.data}");
            int mediaId = response.data['id'];
            mediaIds.add(mediaId); // Collecting media ID
            fileInputVisibilityMedecin.entries.forEach((entry) {
              // Check if the entry value is true (visible)
              if (entry.value) {
                print("marwa1");
                // Extract the numeric part from the entry key
                final indexString = entry.key.replaceAll(RegExp(r'[^0-9]'), '');
                // Parse the extracted numeric part into an integer
                final index = int.tryParse(indexString);
                if (index != null) {
                  // Update ACF data for each file
                  acfData['opest_operatoire$index'] = mediaId;

                } else {
                  print('Invalid index format for medecin key ${entry.key}');
                }
              }
            });
            print("marwa2");
            //acfData['date_arrivage'] = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(dateArrivage.text));
           // acfData['date_depart'] = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(dateDepart.text));


          } else {
            print("Failed to upload file: ${response.statusCode}");
          }
        } catch (e) {
          print("Error uploading file: $e");
          return; // Early exit on failure
        }
      }
    }
    acfData['prix'] = prix.text; // Assign text field value for prix
    acfData['medicaments'] = medicaments.text; // Assign text field value for medicaments

    // Step 2: Update ACF fields
    if (mediaIds.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': basicAuth,
          },
          body: jsonEncode({
            "acf": acfData,
          }),
        );

        print("ACF Update Response: ${response.body}");
        if (response.statusCode == 200) {
          showDefaultSnackbar();
          print('ACF fields updated successfully');
        } else {
          print('Failed to update ACF fields: ${response.statusCode}');
        }
      } catch (e) {
        print("Error updating ACF fields: $e");
      }

    }
  }*/
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
            title: new Text("Fiche Client", style: TextStyle(color: Colors.black)),
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
      child: Column(
        children: <Widget>[
          formViewWidget(context),
          // Display uploaded files
          if (_selectedFiles != null && _selectedFiles!.isNotEmpty)
            Column(
              children: [
                Text("Uploaded Files:"),
                for (var file in _selectedFiles!)
                  Text(file.name),
              ],
            ),
        ],
      ),
    );
  }


  @override
  Widget formViewWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        // Remove the height property to allow the content to occupy full height
        child: Material(
          child: FutureBuilder(
            future: getDataClient(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error 1: ${snapshot.error}');
              } else if (!snapshot.hasData || (snapshot.data as List<dynamic>).isEmpty) {
                return Center(
                  child: Text('No data available.'),
                );
              } else {
                final dataclients = (snapshot.data as List<dynamic>).toList();
                print("dataclients dataclients");
                print(dataclients);
               // try {
                //  final dataclients = (snapshot.data as List<dynamic>).toList();
                  // Evaluate whether the condition to show the button is met
                  /* bool shouldShowButton = dataclients.isNotEmpty && dataclients[0]['acf'].entries.any(
                        (entry) => entry.key.startsWith('opest_oper_customer') && entry.value != false,
                  );*/
                /* bool shouldShowButton = dataclients.isNotEmpty && dataclients[0]['acf'].entries
                      .where((MapEntry<String, dynamic> entry) => entry.key.startsWith('opest_oper_customer'))
                      .every((MapEntry<String, dynamic> entry) => entry.value != false);*/
                bool shouldShowButton = dataclients.isNotEmpty &&
                    dataclients[0]['acf'].entries
                        .where((MapEntry<String, dynamic> entry) => entry.key.startsWith('opest_oper_customer'))
                        .every((MapEntry<String, dynamic> entry) {
                      var value = entry.value;
                      return value == null || (value is String && value.isEmpty);
                    });
                 print("shouldShowButton");
                print(shouldShowButton);
                  bool shouldShowButtonMedecin = dataclients.isNotEmpty && dataclients[0]['acf'].entries
                      .where((MapEntry<String, dynamic> entry) => entry.key.startsWith('opest_operatoire'))
                      .every((MapEntry<String, dynamic> entry) => entry.value != false);

                  return Column(
                   // crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure content occupies full width
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: Colors.black), // Add a border at the top
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(left: 2.0),
                                child: Text(
                                  dataclients.isNotEmpty ? (dataclients[0]['title']['rendered'] as String?) ?? "Fiche Client" : "Fiche Client",
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(left: 2.0),
                                child: Text(
                                  widget.etat,
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 2.0),
                                child: Text(
                                  "Fiche Client",
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            "Informations de contact",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                            margin: EdgeInsets.all(5),
                                child: DataTable(
                                  border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                  headingRowColor:
                                  MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                  columns: const <DataColumn>[
                                    DataColumn(
                                        label: Text(
                                          'Civilité :',
                                          style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                          ),
                                          softWrap: true,
                                        )
                                    ),
                                  ],
                                  rows: dataclients.map((dataclient) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(billing_sexe)),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Nom & Prénom :',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(first_name + ' ' +last_name)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Email :',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(email)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Téléphone :',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(phone)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            "Informations personnelles",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Date de naissance :',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(formattedNaissanceDate)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Taille :',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final taille = dataclients.isNotEmpty ? (dataclients[0]['acf']['taille'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(taille)),

                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Poids :',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final poids = dataclients.isNotEmpty ? (dataclients[0]['acf']['poids'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(poids)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Date souhaitée :',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final date_souhaitee = dataclients.isNotEmpty ? (dataclients[0]['acf']['date-souhaitee'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(date_souhaitee)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Etes-vous enceinte ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final enceinte = dataclients.isNotEmpty ? (dataclients[0]['acf']['enceinte'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(enceinte)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Désirez-vous une grossesse ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final grossesse = dataclients.isNotEmpty ? (dataclients[0]['acf']['grossesse'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(grossesse)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Désirez-vous une grossesse ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final temps_grossesse = dataclients.isNotEmpty ? (dataclients[0]['acf']['temps-grossesse'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(temps_grossesse)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Photos :',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final title = dataclient['title']['rendered'] as String?;
                                  final date = dataclient['date'] as String?;
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(first_name + ' ' +last_name)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            "Habitudes de consommation",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Consommation d’alcool ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final alcool = dataclients.isNotEmpty ? (dataclients[0]['acf']['alcool'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(alcool)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Si oui, combien par jour ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final alcool_oui = dataclients.isNotEmpty ? (dataclients[0]['acf']['alcool-oui'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(alcool_oui)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Consommation de tabac ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final tabac = dataclients.isNotEmpty ? (dataclients[0]['acf']['tabac'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(tabac)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Si oui, combien par jour ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final combien_tabac = dataclients.isNotEmpty ? (dataclients[0]['acf']['combien-tabac'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(combien_tabac)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            "Antécédents médicaux",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Etes-vous malade ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final malade = dataclients.isNotEmpty ? (dataclients[0]['acf']['malade'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(malade)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Si oui, quel maladie ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final maladie_oui = dataclients.isNotEmpty ? (dataclients[0]['acf']['maladie-oui'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(maladie_oui)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Prenez-vous des médicaments ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final medicaments = dataclients.isNotEmpty ? (dataclients[0]['acf']['medicaments'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(medicaments)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Si oui, lesquels ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final oui_medicaments = dataclients.isNotEmpty ? (dataclients[0]['acf']['oui-medicaments'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(oui_medicaments)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Suivez-vous un traitement médical ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final traitement_medical = dataclients.isNotEmpty ? (dataclients[0]['acf']['traitement-medical'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(traitement_medical)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Si oui, lequel et pour combien de temps ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true, // Ensures the text wraps
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final oui_traitement_medical = dataclients.isNotEmpty ? (dataclients[0]['acf']['oui-traitement-medical'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(oui_traitement_medical)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Avez-vous eu des maladies ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final maladies = dataclients.isNotEmpty ? (dataclients[0]['acf']['maladies'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(maladies)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),


                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Si oui, lesquelles ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final oui_maladies = dataclients.isNotEmpty ? (dataclients[0]['acf']['oui-maladies'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(oui_maladies)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Faites-vous des allergies aux médicaments ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true, // Ensures the text wraps
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final allergies = dataclients.isNotEmpty ? (dataclients[0]['acf']['allergies'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(allergies)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Si oui, lesquelles ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final oui_allergies = dataclients.isNotEmpty ? (dataclients[0]['acf']['oui-allergies'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(oui_allergies)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Avez-vous du diabète, du cholestérol, de l’hypertension, de l’anémie ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final diabete = dataclients.isNotEmpty ? (dataclients[0]['acf']['diabete'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(diabete)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Si oui, précisez ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final oui_diabete = dataclients.isNotEmpty ? (dataclients[0]['acf']['oui-diabete'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(oui_diabete)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            "Antécédents chirurgicaux",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Avez-vous eu des opérations chirurgicales ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final operations_chirurgicales = dataclients.isNotEmpty ? (dataclients[0]['acf']['operations-chirurgicales'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(operations_chirurgicales)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Si oui, lesquelles ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final oui_operations_chirurgicales = dataclients.isNotEmpty ? (dataclients[0]['acf']['oui-operations-chirurgicales'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(oui_operations_chirurgicales)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Avez-vous eu des opérations chirurgicales esthétiques ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final operations_chirurgicales_esthetiques = dataclients.isNotEmpty ? (dataclients[0]['acf']['operations-chirurgicales-esthetiques'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(operations_chirurgicales_esthetiques)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Si oui, lesquelles ?',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final oui_operations_chirurgicales_esthetiques = dataclients.isNotEmpty ? (dataclients[0]['acf']['oui-operations-chirurgicales-esthetiques'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(oui_operations_chirurgicales_esthetiques)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Wrap(
                          spacing: 8.0, // Gap between adjacent chips.
                          runSpacing: 4.0, // Gap between lines.
                          children: List.generate(5, (index) {
                            var acfData = dataclients[0]['acf'];
                            if (acfData != null && acfData is Map) {
                              var key = 'opest_oper_customer${index + 1}';
                              if (acfData.containsKey(key)) {
                                var imageData = acfData[key];
                                if (imageData is Map && imageData.containsKey('url')) {
                                  var imageUrl = imageData['url'];
                                  if (imageUrl is String) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width / 3 - 10,
                                      child: Column(
                                        children: [
                                          Image.network(imageUrl, fit: BoxFit.cover),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              }
                            }
                            return SizedBox(); // Placeholder widget when image URL is not available
                          }),
                        ),
                      ),
                      /* Container(
                        margin: EdgeInsets.all(5),
                        child: Wrap(
                          spacing: 8.0, // Gap between adjacent chips.
                          runSpacing: 4.0, // Gap between lines.
                          children: dataclients.isNotEmpty
                              ? dataclients[0]['acf'].entries
                              .where((entry) =>
                          entry.key.startsWith('opest_oper_customer') &&
                              entry.value != false)
                              .map<Widget>((entry) {
                            // Assuming entry.value is a Map with a 'url' key
                            Map valueMap = entry.value;
                            String imageUrl = valueMap['url'] ?? '';

                            return Container(
                              width: MediaQuery.of(context).size.width / 3 - 10, // Adjust the size according to your needs
                              child: Image.network(imageUrl, fit: BoxFit.cover),
                            );
                          }).toList()
                              : [],
                        ),
                      ),*/
                     /* Container(
                        margin: EdgeInsets.all(5),
                        child: Wrap(
                          spacing: 8.0, // Gap between adjacent chips.
                          runSpacing: 4.0, // Gap between lines.
                          children: dataclients.isNotEmpty
                              ? dataclients[0]['acf'].entries.where((entry) {
                            // Check if the entry value is a Map<dynamic, dynamic>
                            return entry.value is Map<dynamic, dynamic> &&
                                entry.key.startsWith('opest_oper_customer') &&
                                entry.value != false;
                          }).map<Widget>((entry) {
                            // Now it's safe to access entry.value as a Map<dynamic, dynamic>
                            Map<String, dynamic> valueMap = entry.value;
                            String imageUrl = valueMap['url'] ?? '';

                            return Container(
                              width: MediaQuery.of(context).size.width / 3 - 10, // Adjust the size according to your needs
                              child: Image.network(imageUrl, fit: BoxFit.cover),
                            );
                          }).toList()
                              : [],
                        ),
                      ),*/
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: Colors.black), // Add a border at the top
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 2.0),
                                child: Text(
                                  "Suivi",
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Date d\'arrivée :',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final oui_operations_chirurgicales_esthetiques = dataclients.isNotEmpty ? (dataclients[0]['acf']['date_arrivage'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(oui_operations_chirurgicales_esthetiques)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Date de depart :',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final oui_operations_chirurgicales_esthetiques = dataclients.isNotEmpty ? (dataclients[0]['acf']['date_depart'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(oui_operations_chirurgicales_esthetiques)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        color: Color(0xFFe8e0d7), // Background color
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.0),
                            child: Expanded(
                              child: Container(
                                padding: EdgeInsets.all(15), // Internal padding
                                child: Text(
                                  "Suivi post opératoire :",
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Wrap(
                          spacing: 8.0, // Gap between adjacent chips.
                          runSpacing: 4.0, // Gap between lines.
                          children: List.generate(5, (index) {
                            var acfData = dataclients[0]['acf'];
                            if (acfData != null && acfData is Map) {
                              var key = 'opest_operatoire${index + 1}';
                              if (acfData.containsKey(key)) {
                                var imageData = acfData[key];
                                if (imageData is Map && imageData.containsKey('url')) {
                                  var imageUrl = imageData['url'];
                                  if (imageUrl is String) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width / 3 - 10,
                                      child: Column(
                                        children: [
                                          Image.network(imageUrl, fit: BoxFit.cover),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              }
                            }
                            return SizedBox(); // Placeholder widget when image URL is not available
                          }),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Prix :',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final oui_operations_chirurgicales_esthetiques = dataclients.isNotEmpty ? (dataclients[0]['acf']['prix'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(oui_operations_chirurgicales_esthetiques)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.all(5),
                              child: DataTable(
                                border: TableBorder.all(color: Color(0xFFe8e0d7),width: 2.0),
                                headingRowColor:
                                MaterialStateColor.resolveWith((states) => Color(0xFFe8e0d7)),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Médicaments :',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: dataclients.map((dataclient) {
                                  final oui_operations_chirurgicales_esthetiques = dataclients.isNotEmpty ? (dataclients[0]['acf']['medicaments'] as String?) ?? "" : "";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(oui_operations_chirurgicales_esthetiques)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                     /* ...fileInputVisibility.entries.map((entry) {
                        // Attempt to extract the integer index from the key
                        final match = RegExp(r'\d+$').firstMatch(entry.key);
                        if (match != null) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.0),
                              child: Text(
                                "Réservé au Client",
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink(); // For non-visible or unparseable entries
                      }).toList(),*/
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            "Réservé au Client",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            "Suivi post opératoire",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                     /* ...fileInputVisibility.entries.map((entry) {
                        // Attempt to extract the integer index from the key
                        final match = RegExp(r'\d+$').firstMatch(entry.key);
                        if (match != null) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.0),
                              child: Text(
                                "Suivi post opératoire",
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          );

                        }
                        return SizedBox.shrink(); // For non-visible or unparseable entries
                      }).toList(),*/


                      SizedBox(height: 20),
                      ...fileInputVisibility.entries.map((entry) {
                        // Check if the widget should be visible
                       // if (entry.value) {
                          // Attempt to extract the integer index from the key
                          final match = RegExp(r'\d+$').firstMatch(entry.key);
                          if (match != null) {
                            final index = int.parse(match.group(0)!); // Safely parse the integer
                            return ElevatedButton(
                              onPressed: () => _pickFiles(index), // Pass the extracted index
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFe8e0d7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Choisir un fichier",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }
                        // }
                        return SizedBox.shrink(); // For non-visible or unparseable entries
                      }).toList(),
                      SizedBox(height: 16),
                     /* ...fileInputVisibility.entries.map((entry) {
                        // Attempt to extract the integer index from the key
                        final match = RegExp(r'\d+$').firstMatch(entry.key);
                        if (match != null) {
                          return ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFA28275),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Envoyer".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink(); // For non-visible or unparseable entries
                      }).toList(),*/
                      if (!shouldShowButton)
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFA28275),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Envoyer".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                     /* if (!shouldShowButton)
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Envoyer'),
                        ),*/
                      SizedBox(height: 16),

                     /* Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            "Réservé au Medecin",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5), // Add horizontal padding
                        child: TextField(
                          controller: dateArrivage,
                          // Editing controller of this TextField
                          decoration: InputDecoration(
                            icon: Icon(Icons.calendar_today), // Icon of text field
                            labelText: "Date d'arrivée", // Label text of field
                          ),
                          readOnly: true,
                          // Set it true, so that the user will not be able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              // DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              setState(() {
                                dateArrivage.text = formattedDate; // Set output date to TextField value.
                                dateInputendMinDate = pickedDate; // Update the minimum date for dateInputend
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10), // Add some space between the rows
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5), // Add horizontal padding
                        child: TextField(
                          controller: dateDepart,
                          // Editing controller of this TextField
                          decoration: InputDecoration(
                            icon: Icon(Icons.calendar_today), // Icon of text field
                            labelText: "Date de départ", // Label text of field
                          ),
                          readOnly: true,
                          // Set it true, so that the user will not be able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: dateInputendMinDate ?? DateTime.now(), // Use dateInputendMinDate if available
                              firstDate: dateInputendMinDate ?? DateTime.now(), // Use dateInputendMinDate if available
                              // DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              setState(() {
                                dateDepart.text = formattedDate; // Set output date to TextField value.
                              });
                            }
                          },
                        ),

                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            "Suivi post opératoire",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      // Add the first date picker

                      SizedBox(height: 10),
                      ...fileInputVisibilityMedecin.entries.map((entry) {
                        // Check if the widget should be visible
                      // if (entry.value == true ) {
                          // Attempt to extract the integer index from the key
                          final match = RegExp(r'\d+$').firstMatch(entry.key);
                          if (match != null) {
                            final index = int.tryParse(match.group(0) ?? ''); // Safely parse the integer
                            if (index != null) {
                              return ElevatedButton(
                                onPressed: () => _pickFilesMedecin(index),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFe8e0d7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Choisir un fichier",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        //}
                        return SizedBox.shrink(); // For non-visible or unparseable entries
                      }).toList(),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            "Certificats médicaux",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      // Add the first date picker

                      SizedBox(height: 10),
                      ...fileInputVisibilityMedecincertif.entries.map((entry) {
                        // Check if the widget should be visible
                        //if (entry.value) {
                          // Attempt to extract the integer index from the key
                          final match = RegExp(r'\d+$').firstMatch(entry.key);
                          if (match != null) {
                            final index = int.parse(match.group(0)!); // Safely parse the integer
                            return ElevatedButton(
                              onPressed: () => _pickFilesMedecinCertif(index), // Pass the extracted index
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFe8e0d7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Choisir un fichier",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }
                       // }
                        return SizedBox.shrink(); // For non-visible or unparseable entries
                      }).toList(),
                      SizedBox(height: 16),
                      TextField(
                        controller: prix,
                        decoration: InputDecoration(
                          labelText: "Prix", // Label text of field
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true), // Set keyboard type to accept numbers
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: medicaments,
                        decoration: InputDecoration(
                          labelText: "Médicaments", // Label text of field
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true), // Set keyboard type to accept numbers
                      ),
                      SizedBox(height: 16),
                     // if (!shouldShowButtonMedecin)
                        ElevatedButton(
                          onPressed: _submitFormMedecin,
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFA28275),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Envoyer".toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 16),*/

                    ],
                  );

                /*} catch (error) {
                  print('Error 2: $error');
                  return Text('An error occurred while parsing data.');
                }*/
              }
            },
          ),
        ),
      ),
    );
  }
  void showDefaultSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Merci pour votre message. Il a été envoyé."),
      ),
    );
  }
  //@override
 /* Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fiche client"),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<bool>(
        future: getDataClient(), // Call the getDataClient function
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var jsonData = jsonDecode(snapshot.data as String);
            print(jsonData);
            return Column(
              children: [
               // Text(dataClient['title']['rendered'] as String), // Access title from dataClient
              //  Text(dataClient['date'] as String), // Access date from dataClient
                Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Cell 1'),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Cell 3'),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildFilePicker(0),
                          buildFilePicker(1),
                          buildFilePicker(2),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildFilePicker(3),
                          buildFilePicker(4),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Handle form submission here
                        },
                        child: Text('Envoyer'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
      },
      ),
    );

  }*/
 /* Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fiche client"),
        backgroundColor: Colors.red,
      ),
        body: Column(
          children: [
              Expanded(
              child: htmlContent.isNotEmpty
                ? WebView(
                  initialUrl: 'https://www.drg.deveoo.net/intervention-client/${widget.slug}',
                  /*initialUrl: Uri.dataFromString(
                    htmlContent,
                    mimeType: 'text/html',
                    encoding: utf8, // Use utf8 constant directly
                  ).toString(),*/
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    controller = webViewController;

                  },
                  onPageFinished: (String url) {
                    _extractContent();
                  },
                ): Center(
                  child: CircularProgressIndicator(),
                ),
            ),

            Padding(
             // child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(""),
                    Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Cell 1'),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Cell 3'),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildFilePicker(0),
                        buildFilePicker(1),
                        buildFilePicker(2),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildFilePicker(3),
                        buildFilePicker(4),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Handle form submission here
                      },
                      child: Text('Envoyer'),
                    ),
                  ],
                ),
                ),
             // ),
            ],
        ),
    );
  }*/

    /*  body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display user data in the dashboard
            // if (userData != null)
            Column(
              children: [
                Text('https://www.drg.deveoo.net/intervention-client/${widget.slug}'),
                // Text('Username: $username'),
                //  Text('Email: $email'),

              ],
            )
            // else
            // Text('Loading user data...'),
          ],
        ),
      ),
    );
  }*/
  Future<void> _extractContent() async {
    final content = await controller.evaluateJavascript(
        "document.getElementById('main').innerText;");
    print("Content: $content");
  }

  Future<Map<String, String?>> loadUserId() async {
    final storage = FlutterSecureStorage();
    return {
      'userId': await storage.read(key: 'userId'),
      'username': await storage.read(key: 'username'),
      'first_name': await storage.read(key: 'first_name'),
      'last_name': await storage.read(key: 'last_name'),
      'email': await storage.read(key: 'email'),
      'phone': await storage.read(key: 'phone'),
      'billing_sexe': await storage.read(key: 'billing_sexe'), // Assuming 'billing_sexe' is always at index 3
      'billing_naissance': await storage.read(key: 'billing_naissance'),
      'role': await storage.read(key: 'role'),
    };
  }





  /*final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late Widget _mainFormWidget = SizedBox.shrink();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textController = TextEditingController();

  List<Map<String, dynamic>>? typeintervention;

  // PlaceDevisPageState(); // Initialize 'parent' with the provided parameter

  @override
  /*void initState() {
    super.initState();
    _mainFormWidget = mainBody();
  }*/

    Widget build(BuildContext context) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Demander un devis"),
          backgroundColor: Colors.red,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'titre',
                      decoration: InputDecoration(labelText: 'Nom de l’intervention'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(3),
                      ]),
                    ),
                    SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'author_name',
                      decoration: InputDecoration(labelText: 'Nom'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(3),
                      ]),
                    ),
                    SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'author_last_name',
                      decoration: InputDecoration(labelText: 'Prénom'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(3),
                      ]),
                    ),
                    SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'author_email',
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(), // Email validator
                      ]),
                    ),
                    SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'phone',
                      decoration: InputDecoration(labelText: 'Téléphone'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(), // Email validator
                      ]),
                    ),
                    SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'taille',
                      decoration: InputDecoration(labelText: 'Taille'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.numeric(), // Email validator
                      ]),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          // Call the createPost function here
                          createPost(_formKey.currentState?.value);
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    // Function to create a post
  void createPost(Map<String, dynamic>? formData) async {
    final String apiUrl = 'https://www.drg.deveoo.net/wp-json/wp/v2/intervention-client';
    // final String username = 'drg_deveoo';
    // final String password = '&9BkjT#JaB';
    final String basicAuth = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        },
        body: jsonEncode(<String, dynamic>{
          'title': formData?['titre'],
          'content': 'Your post content here',
          'status': 'publish',
          'author_name': formData?['author_name'],
        }),
      );
      if (response.statusCode == 201) {
        print('Post created successfully');
      } else {
        print('Failed to create post. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error creating post: $error');
    }
  }

  void showSnackbar(final _scaffoldKey,  String disPlayMessage) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(minutes: 5),
        content: Text(disPlayMessage),
      ),
    );
  }*/
}



