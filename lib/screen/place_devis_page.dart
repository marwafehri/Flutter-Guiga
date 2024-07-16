import 'dart:convert';
import 'dart:io';  // Add this import
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
  PlaceDevisPageState createState() => new PlaceDevisPageState();
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
  late String first_name = '';
  late String last_name = '';
  late String email = '';
  late String phone = '';
  late String billing_sexe = '';
  late String formattedNaissanceDate = '';

  List<XFile>? _selectedFiles = [];
  int? idintervention;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      // Set WebView platform based on platform detection
      if (html.window.navigator.platform.contains('iPad') ||
          html.window.navigator.platform.contains('iPhone') ||
          html.window.navigator.platform.contains('iPod') ||
          html.window.navigator.userAgent.contains('iPad') ||
          html.window.navigator.userAgent.contains('iPhone') ||
          html.window.navigator.userAgent.contains('iPod')) {
        WebView.platform = SurfaceIOSWebView();
      } else {
        WebView.platform = SurfaceAndroidWebView();
      }
    }
    /*if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    } else if (Platform.isIOS) {
      WebView.platform = SurfaceIOSWebView();
    }*/
    fetchHtmlContent();
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
      });
    });
  }

  Future<void> fetchHtmlContent() async {
    final url = 'https://www.drg.deveoo.net/devis/';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final modifiedHtmlContent = response.body;
      final document = parser.parse(modifiedHtmlContent);
      document.querySelector('#masthead')?.remove();
      document.querySelector('#colophon')?.remove();
      final HtmlContent = document.outerHtml;
      var dataHtmlContent = Uri.dataFromString(
        HtmlContent,
        mimeType: 'text/html',
        encoding: utf8,
      ).toString();
      setState(() {
        this.htmlContent = dataHtmlContent;
      });
    } else {
      throw Exception('Failed to fetch HTML content');
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _selectedFiles = result.paths.whereNotNull().map((path) => XFile(path)).toList();
      });
    }
  }

  Future<void> _injectJavaScript() async {
    await controller.runJavascript('''
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
  }

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
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void handleFormSubmission(String postTitle) async {
    int? idIntervention = await getIdFromPostTitle(postTitle);
    if (idIntervention != null) {
      idintervention = idIntervention;
      _submitFiles(idintervention!);
    }
  }

  Future<void> _fillEmailField() async {
    await controller.runJavascript('''
      var user_email = "$email";
      var first_name = "$first_name";
      var last_name = "$last_name";
      var id = "$userId";
      var phone = "$phone";
      var billing_sexe = "$billing_sexe";
      var billing_naissance = "$formattedNaissanceDate";

      var billingNaissanceDate = new Date(billing_naissance);
      var day = billingNaissanceDate.getDate().toString().padStart(2, '0');
      var month = (billingNaissanceDate.getMonth() + 1).toString().padStart(2, '0');
      var year = billingNaissanceDate.getFullYear().toString();
      var formattedNaissanceDate = month + '/' + day + '/' + year;

      var emailInput = document.querySelector('[name="author_email"]');
      var nameInput = document.querySelector('[name="author_name"]');
      var lastNameInput = document.querySelector('[name="_custom_field|author_last_name"]');
      var idInput = document.querySelector('[name="_custom_field|user_id"]');
      var phoneInput = document.querySelector('[name="_custom_field|phone"]');
      var sexeInput = document.querySelector('[name="_custom_field|billing_sexe"]');
      var sexeshowInput = document.querySelector('.fpsm-meta-billing-sexe');
      var sexeeshowInput = document.querySelector('.fpsm-meta-billing-sexee');
      var naissanceInput = document.querySelector('[name="_custom_field|billing_naissance"]');

      if (user_email != "Unknown") emailInput.value = user_email;
      if (first_name != "Unknown") lastNameInput.value = first_name;
      if (last_name != "Unknown") nameInput.value = last_name;
      if (id != "Unknown") idInput.value = id;
      if (phone != "Unknown") phoneInput.value = phone;
      if (billing_sexe != "Unknown") sexeInput.value = billing_sexe;

      if (formattedNaissanceDate != "NaN/NaN/NaN") naissanceInput.value = formattedNaissanceDate;
  ''');
  }

  Future<void> _submitFiles(int idintervention) async {
    final String url = 'https://www.drg.deveoo.net/wp-json/wp/v2/intervention-client/$idintervention';
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
          }
        } catch (e) {
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
        } else {
        }
      } catch (e) {
      }
    }
  }

  Future<Map<String, String>> loadUserId() async {
    final storage = FlutterSecureStorage();
    var userId = await storage.read(key: 'userId');
    var username = await storage.read(key: 'username');
    var first_name = await storage.read(key: 'first_name');
    var last_name = await storage.read(key: 'last_name');
    var email = await storage.read(key: 'email');
    var phone = await storage.read(key: 'phone');
    var billing_sexe = await storage.read(key: 'billing_sexe');
    var formattedNaissanceDate = await storage.read(key: 'billing_naissance');

    Map<String, String> userData = {
      'userId': userId ?? 'Unknown',
      'username': username ?? 'Unknown',
      'first_name': first_name ?? 'Unknown',
      'last_name': last_name ?? 'Unknown',
      'email': email ?? 'Unknown',
      'phone': phone ?? 'Unknown',
      'billing_sexe': billing_sexe ?? 'Unknown',
      'billing_naissance': formattedNaissanceDate ?? 'Unknown'
    };

    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Demander un devis", style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFe8e0d7),
        actions: [],
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
                  setState(() {
                    _isLoading = true;
                  });
                },
                onPageFinished: (String url) async {
                  await _fillEmailField();
                  await _injectJavaScript();
                  setState(() {
                    _isLoading = false;
                  });
                },
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
