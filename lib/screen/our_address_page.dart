import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class ourAddressPage extends StatefulWidget {

  @override
  ourAddressPageState createState() => new ourAddressPageState();
}


class ourAddressPageState extends State<ourAddressPage> {

  late WebViewController controller;

  late String userId = '';
  late String username= '';
  late String first_name= '';
  late String last_name= '';
  late String email= '';
  late String phone= '';
  late String billing_sexe= '';
  late String formattedNaissanceDate= '';

  @override
  void initState() {
    super.initState();

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
        print('billing_naissance: $billing_sexe');
        print('Billing Naissance: $formattedNaissanceDate');
        _fillEmailField();
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adresse"),
        backgroundColor: Colors.red,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display user data in the dashboard
            // if (userData != null)
            Column(
              children: [
                Text('Adresse'),
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
  }
  Future<void> _extractContent() async {
    final content = await controller.evaluateJavascript(
        "document.getElementById('main').innerText;");
    print("Content: $content");
  }
  Future<void> _fillEmailField() async {
    await controller.evaluateJavascript('''
      var user_email = "$email";
      var first_name = "$first_name";
      var last_name = "$last_name";
      var id = "$userId";
      var phone = "$phone";
      var billing_sexe = "$billing_sexe";
      var billing_naissance = "$formattedNaissanceDate";
       console.log("user_email");
      console.log(user_email);
      console.log(billing_naissance);
      var billingNaissanceDate = new Date(billing_naissance);
     
      var day = billingNaissanceDate.getDate().toString().padStart(2, '0');
      var month = (billingNaissanceDate.getMonth() + 1).toString().padStart(2, '0');
      var year = billingNaissanceDate.getFullYear().toString();
      // Construct the formatted date string
      var formattedNaissanceDate = month + '/' + day + '/' + year;
      console.log(formattedNaissanceDate);
      
      console.log("verifier email $email");
      var emailInput = document.querySelector('[name="author_email"]');
      
      var nameInput = document.querySelector('[name="author_name"]');
      var lastNameInput = document.querySelector('[name="_custom_field|author_last_name"]');
      
      var idInput = document.querySelector('[name="_custom_field|user_id"]');

      var phoneInput = document.querySelector('[name="_custom_field|phone"]');
      var sexeInput = document.querySelector('[name="_custom_field|billing_sexe"]');
      var sexeeInput = document.querySelector('.fpsm-meta-billing-sexee');
       var sexeshowInput = document.querySelector('.fpsm-meta-billing-sexe');
      var naissanceInput = document.querySelector('[name="_custom_field|billing_naissance"]');
      sexeshowInput.hidden = false;
      
      console.log(first_name);
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
      } 
      if (formattedNaissanceDate != "NaN/NaN/NaN") {
         naissanceInput.value = formattedNaissanceDate;
         naissanceInput.readOnly = true;
         sexeeInput.hidden = true;
      } 
    
  ''');
  }
  void _setUpFormSubmissionListener() async {
    // Inject JavaScript code to listen for form submission events
    await controller.evaluateJavascript('''
      document.addEventListener('submit', function(event) {
        // Prevent the default form submission behavior
        event.preventDefault();
        // Perform any necessary form validation
        // For example, check if the form data is valid
        // If the form data is valid, navigate to the desired page
        window.location.href = 'https://example.com/redirect-page';
      });
    ''');
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
    };

  }
 /* Future<Map<String, String?>> loadUserId() async {
    final storage = FlutterSecureStorage();
    //return await storage.readAll();
    return {
      'userId': await storage.read(key: 'userId'),
      'username': await storage.read(key: 'username'),
      'first_name': await storage.read(key: 'first_name'),
      'last_name': await storage.read(key: 'last_name'),
      'email': await storage.read(key: 'email'),
      'phone': await storage.read(key: 'phone'),
      'billing_sexe': await storage.read(key: 'billing_sexe'),
      'billing_naissance': await storage.read(key: 'meta_data'),
      // Add other pieces of user information as needed
    };
  }*/
  /*void _extractContent() async {
    // Inject JavaScript code to extract the HTML content of the element with id "primary"
    await controller.evaluateJavascript('''
      var primaryElement = document.getElementById('primary');
      if (primaryElement != null) {
        var primaryHtml = primaryElement.outerHTML;
        window.flutter_inappwebview.callHandler('onExtractContent', primaryHtml);
      }
    ''');
  }*/




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



