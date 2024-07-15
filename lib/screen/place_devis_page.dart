import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' as parser;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class PlaceDevisPage extends StatefulWidget {
  @override
  PlaceDevisPageState createState() => PlaceDevisPageState();
}

class PlaceDevisPageState extends State<PlaceDevisPage> {
  late WebViewController controller;
  final String initialUrl = 'https://www.drg.deveoo.net/devis/';
  bool _isLoading = true;
  late String htmlContent = '';
  late String elementHtml;
  bool hideHeaderFooter = true;

  late String userId = '';
  late String username = '';
  late String firstName = '';
  late String lastName = '';
  late String email = '';
  late String phone = '';
  late String billingSexe = '';
  late String formattedNaissanceDate = '';

  List<XFile>? _selectedFiles = [];
  int? idIntervention;

  @override
  void initState() {
    super.initState();
    fetchHtmlContent();
    loadUserId().then((value) {
      setState(() {
        userId = value['userId'] ?? 'Unknown';
        username = value['username'] ?? 'Unknown';
        firstName = value['first_name'] ?? 'Unknown';
        lastName = value['last_name'] ?? 'Unknown';
        email = value['email'] ?? 'Unknown';
        phone = value['phone'] ?? 'Unknown';
        billingSexe = value['billing_sexe'] ?? 'Unknown';
        formattedNaissanceDate = value['billing_naissance'] ?? 'Unknown';
        print('billing_sexe: $billingSexe');
        print('Billing Naissance last: $formattedNaissanceDate');
      });
    });
  }

  Future<void> fetchHtmlContent() async {
    try {
      final response = await http.get(Uri.parse(initialUrl));
      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        document.querySelector('#masthead')?.remove();
        document.querySelector('#colophon')?.remove();
        final modifiedHtmlContent = document.outerHtml;

        setState(() {
          htmlContent = Uri.dataFromString(
            modifiedHtmlContent,
            mimeType: 'text/html',
            encoding: utf8,
          ).toString();
        });
      } else {
        throw Exception('Failed to fetch HTML content');
      }
    } catch (e) {
      print("Error fetching HTML content: $e");
    }
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );
      if (result != null) {
        setState(() {
          _selectedFiles = result.paths.whereNotNull().map((path) => XFile(path)).toList();
        });
      }
    } catch (e) {
      print("Error picking files: $e");
    }
  }

/*  Future<void> _injectJavaScript() async {
    await controller.evaluateJavascript('''
      console.log("1111");
      document.querySelector('input[type="file"]').addEventListener('click', function(event) {
        event.preventDefault();
        window.FileUploadChannel.postMessage("upload-photos");
      });

      document.querySelector('form').addEventListener('submit', function(event) {
        event.preventDefault();
        var postTitle = this.elements.post_title.value;
        window.FormSubmissionChannel.postMessage(postTitle);
        console.log("Form submission intercepted");
      });
    ''');
  }*/

  Future<int?> getIdFromPostTitle(String postTitle) async {
    final String url = 'https://www.drg.deveoo.net/wp-json/wp/v2/intervention-client';
    final String basicAuth = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

    try {
      Dio dio = Dio();
      dio.options.headers['Authorization'] = basicAuth;
      dio.options.headers['Content-Type'] = 'application/json';

      var response = await dio.get(url, queryParameters: {'title': postTitle});
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          int id = data[0]['id'];
          return id;
        }
      }
    } catch (e) {
      print("Error getting post ID: $e");
    }
    return null;
  }

  void handleFormSubmission(String postTitle) async {
    int? idIntervention = await getIdFromPostTitle(postTitle);
    if (idIntervention != null) {
      idIntervention = idIntervention;
      _submitFiles(idIntervention);
    } else {
      print("No valid ID found for post_title: $postTitle");
    }
  }

  Future<void> _fillEmailField() async {
    await controller.evaluateJavascript('''
      var user_email = "$email";
      var first_name = "$firstName";
      var last_name = "$lastName";
      var id = "$userId";
      var phone = "$phone";
      var billing_sexe = "$billingSexe";
      var billing_naissance = "$formattedNaissanceDate";
      console.log("user_email");
      console.log(user_email);
      console.log(billing_naissance);
      var billingNaissanceDate = new Date(billing_naissance);

      var day = billingNaissanceDate.getDate().toString().padStart(2, '0');
      var month = (billingNaissanceDate.getMonth() + 1).toString().padStart(2, '0');
      var year = billingNaissanceDate.getFullYear().toString();
      var formattedNaissanceDate = month + '/' + day + '/' + year;
      console.log(formattedNaissanceDate);

      console.log("verifier email $email");
      var emailInput = document.querySelector('[name="author_email"]');
      var nameInput = document.querySelector('[name="author_name"]');
      var lastNameInput = document.querySelector('[name="_custom_field|author_last_name"]');
      var idInput = document.querySelector('[name="_custom_field|user_id"]');
      var phoneInput = document.querySelector('[name="_custom_field|phone"]');
      var sexeInput = document.querySelector('[name="_custom_field|billing_sexe"]');
      var sexeshowInput = document.querySelector('.fpsm-meta-billing-sexe');
      var sexeeshowInput = document.querySelector('.fpsm-meta-billing-sexee');
      var naissanceInput = document.querySelector('[name="_custom_field|billing_naissance"]');

      if (user_email != "Unknown") {
         emailInput.value = user_email;
         emailInput.readOnly = true;
      } 
      if (first_name != "Unknown") {
         lastNameInput.value = first_name;
         lastNameInput.readOnly = true;
      } 
       if (last_name != "Unknown") {
         nameInput.value = last_name;
         nameInput.readOnly = true;
      } 
      if (id != "Unknown") {
         idInput.value = id;
         idInput.readOnly = true;
      } 
      if (phone != "Unknown") {
         phoneInput.value = phone;
         phoneInput.readOnly = true;
      }
      if (billing_sexe != "Unknown") {
         sexeInput.value = billing_sexe;
         sexeInput.readOnly = true;
        sexeshowInput.style.display = 'block';
        sexeeshowInput.style.display = 'none';
      } else {
       sexeshowInput.style.display = 'none';
        sexeeshowInput.style.display = 'block';
      }
      if (formattedNaissanceDate != "NaN/NaN/NaN") {
         naissanceInput.value = formattedNaissanceDate;
         naissanceInput.readOnly = true;
      } 
    ''');
  }

  Future<void> _submitFiles(int idIntervention) async {
    final String url = 'https://www.drg.deveoo.net/wp-json/wp/v2/intervention-client/$idIntervention';
    final String basicAuth = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';
    String uploadUrl = "https://www.drg.deveoo.net/wp-json/wp/v2/media";
    List<int> mediaIds = [];
    Map<String, dynamic> acfData = {};

    if (_selectedFiles != null) {
      for (var file in _selectedFiles!) {
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
            acfData['upload-photos'] = mediaId;
          } else {
            print("Failed to upload file: ${response.statusCode}");
          }
        } catch (e) {
          print("Error uploading file: $e");
          return;
        }
      }
    }

    if (mediaIds.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': basicAuth,
          },
          body: jsonEncode({"acf": acfData}),
        );

        if (response.statusCode == 200) {
          print('ACF fields updated successfully');
        } else {
          print('Failed to update ACF fields: ${response.statusCode}');
        }
      } catch (e) {
        print("Error updating ACF fields: $e");
      }
    }
  }

  Future<Map<String, String>> loadUserId() async {
    final storage = FlutterSecureStorage();
    var userId = await storage.read(key: 'userId');
    var username = await storage.read(key: 'username');
    var firstName = await storage.read(key: 'first_name');
    var lastName = await storage.read(key: 'last_name');
    var email = await storage.read(key: 'email');
    var phone = await storage.read(key: 'phone');
    var billingSexe = await storage.read(key: 'billing_sexe');
    var formattedNaissanceDate = await storage.read(key: 'billing_naissance');

    return {
      'userId': userId ?? 'Unknown',
      'username': username ?? 'Unknown',
      'first_name': firstName ?? 'Unknown',
      'last_name': lastName ?? 'Unknown',
      'email': email ?? 'Unknown',
      'phone': phone ?? 'Unknown',
      'billing_sexe': billingSexe ?? 'Unknown',
      'billing_naissance': formattedNaissanceDate ?? 'Unknown'
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("Demander un devis", style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFe8e0d7),
      ),
      body: Container(
        color: Color(0xFFf5f5f5),
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          children: [
            Expanded(
              child: WebView(
                initialUrl: initialUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  controller = webViewController;
                  controller.clearCache();
                  CookieManager().clearCookies();
                },
                onPageStarted: (String url) {
                  print('Page started loading: $url');
                },
                onPageFinished: (String url) async {
              print('Page finished loading: $url');
              await _fillEmailField(); // Call the method to fill email field
              await controller.evaluateJavascript('''
    console.log("1111");
    document.querySelector('input[type="file"]').addEventListener('click', function(event) {
      event.preventDefault();
      window.FileUploadChannel.postMessage("upload-photos");
    });

    document.querySelector('form').addEventListener('submit', function(event) {
      event.preventDefault();
      var postTitle = this.elements.post_title.value;
      window.FormSubmissionChannel.postMessage(postTitle);
      console.log("Form submission intercepted");
    });
  '''); // Inject JavaScript

              setState(() {
                _isLoading = false;
              });

              controller
                  .evaluateJavascript("javascript:(function() { " +
                  "var head = document.getElementsByTagName('header')[0];" +
                  "head.parentNode.removeChild(head);" +
                  "var footer = document.getElementsByTagName('footer')[0];" +
                  "footer.parentNode.removeChild(footer);" +
                  "})()")
                  .then((value) => debugPrint('Page finished loading Javascript'))
                  .catchError((onError) => debugPrint('$onError'));
            },
               /* onPageFinished: (String url) async {
                  print('Page finished loading: $url');
                  await _fillEmailField();
                  await _injectJavaScript();
                  setState(() {
                    _isLoading = false;
                  });
                  controller
                      .evaluateJavascript("javascript:(function() { " +
                      "var head = document.getElementsByTagName('header')[0];" +
                      "head.parentNode.removeChild(head);" +
                      "var footer = document.getElementsByTagName('footer')[0];" +
                      "footer.parentNode.removeChild(footer);" +
                      "})()")
                      .then((value) =>
                      debugPrint('Page finished loading Javascript'))
                      .catchError((onError) => debugPrint('$onError'));
                },*/
                javascriptChannels: <JavascriptChannel>{
                  JavascriptChannel(
                    name: 'FileUploadChannel',
                    onMessageReceived: (JavascriptMessage message) {
                      if (message.message == 'upload-photos') {
                        _pickFiles();
                      }
                    },
                  ),
                  JavascriptChannel(
                    name: 'FormSubmissionChannel',
                    onMessageReceived: (JavascriptMessage message) {
                      handleFormSubmission(message.message);
                    },
                  ),
                },
              ),
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
