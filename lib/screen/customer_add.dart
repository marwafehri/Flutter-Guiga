import 'package:flutter/material.dart';
import 'package:woocommerce_app/bloc/customer_add_bloc.dart';
import 'package:woocommerce_app/helper/hex_color.dart';
import 'package:woocommerce_app/screen/dashboard_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomerAddPage extends StatefulWidget {
  @override
  _CustomerAddPageState createState() => _CustomerAddPageState();
}

class _CustomerAddPageState extends State<CustomerAddPage> {
  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autoValidate = false;

  Map customerBasicInformation = new Map();

  Map customerAddressInformation = new Map();

  var bloc;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    bloc = CustomerAddBloc();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('S’enregistrer'),
        backgroundColor: Color(0xFFe8e0d7),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.black,
              size: 36,
            ),
            onPressed: () {
              _validateInputs();
            },
          )
        ],
      ),
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(0.0),
          child: body(),
        ),
      ),
    );
  }

  Widget body() {
    return new Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: <Widget>[
          headerDivWidget('Informations de base'),
          new Container(
              padding: EdgeInsets.all(20.0),
              child: customerBasicInformationUI()),
          //  headerDivWidget("Informations sur l'adresse"),
          /* Container(
              padding: EdgeInsets.all(20.0),
              child: customerAddressInformationUI()),*/
        ]));
  }

  Widget headerDivWidget(String heaterText) {
    return Container(
      width: MediaQuery.of(context).size.width * 1.0,
      //height: 40,
      padding: EdgeInsets.all(15),
      child: Text(
        heaterText,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.grey),
        ),
        color: HexColor("#f9f3f0"),
      ),
    );
  }

// Here is our Form UI
  Widget customerBasicInformationUI() {
    return new Column(
      children: <Widget>[
        new TextFormField(
          decoration: const InputDecoration(labelText: 'Prénom'),
          keyboardType: TextInputType.text,
          // validator: validateName,
          validator: (String? val) {
            if (val != null) {
              return validateName(val);
            }
            return null; // Return null if the value is null
          },
          onSaved: (String? val) {
            if (val != null)
              customerBasicInformation['firstName'] = val;
            else
              customerBasicInformation['firstName'] = '';
          },
        ),
        new TextFormField(
          decoration: const InputDecoration(labelText: 'Nom'),
          keyboardType: TextInputType.text,
          onSaved: (String? val) {
            if (val != null) {
              customerBasicInformation['lastName'] = val;
              customerBasicInformation['userName'] = val;
            } else {
              customerBasicInformation['lastName'] = '';
              customerBasicInformation['userName'] = '';
            };
          },
        ),
        /*new TextFormField(
          decoration: const InputDecoration(labelText: 'Nom'),
          keyboardType: TextInputType.text,
          onSaved: (String? val) {
            if (val != null)
              customerBasicInformation['userName'] = val;
            else
              customerBasicInformation['userName'] = '';
          },
        ),*/
        new TextFormField(
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          // validator: validateEmail,
          validator: (String? val) {
            if (val != null) {
              return validateName(val);
            }
            return null; // Return null if the value is null
          },
          onSaved: (String? val) {
            if (val != null) {
              customerBasicInformation['email'] = val;
              customerAddressInformation['email'] = val;
            }
          },
        ),
        new TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;  // Toggle the password visibility
                });
              },
            ),
          ),
          obscureText: !_isPasswordVisible,  // Toggle visibility based on the state variable
          keyboardType: TextInputType.visiblePassword,
          validator: (String? val) {
            if (val == null || val.isEmpty) {
              return 'Password cannot be empty';
            } else if (val.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;  // Return null if the validation passes
          },
          onSaved: (String? val) {
            if (val != null) {
              customerBasicInformation['password'] = val;
            }
          },
        ),
      /*  new TextFormField(
          decoration: const InputDecoration(labelText: 'Téléphone'),
          keyboardType: TextInputType.phone,
          onSaved: (String? val) {
            if (val != null)
              customerBasicInformation['phone'] = val;
            else
              customerBasicInformation['phone'] = '';
          },
        ),*/
        new SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Widget customerAddressInformationUI() {
    return new Column(
      children: <Widget>[
        /* new TextFormField(
          decoration: const InputDecoration(labelText: 'Prénom'),
          keyboardType: TextInputType.text,
          //validator: validateName,
          validator: (String? val) {
            if (val != null) {
              return validateName(val);
            }
            return null; // Return null if the value is null
          },
          onSaved: (String? val) {
            if (val != null)
              customerAddressInformation['first_name'] = val;
            else
              customerAddressInformation['first_name'] = '';
          },
        ),*/
        /* new TextFormField(
          decoration: const InputDecoration(labelText: 'Nom'),
          keyboardType: TextInputType.text,
          onSaved: (String? val) {
            if (val != null)
              customerAddressInformation['last_name'] = val;
            else
              customerAddressInformation['last_name'] = '';
          },
        ),*/
        /*new TextFormField(
          decoration: const InputDecoration(labelText: 'Téléphone'),
          keyboardType: TextInputType.phone,
          onSaved: (String? val) {
            if (val != null)
              customerBasicInformation['phone'] = val;
            else
              customerBasicInformation['phone'] = '';
          },
        ),*/
        /* new TextFormField(
          decoration: const InputDecoration(labelText: 'Nom de l’entreprise (facultatif)'),
          keyboardType: TextInputType.text,
          onSaved: (String? val) {
            if (val != null)
              customerAddressInformation['Company'] = val;
            else
              customerAddressInformation['Company'] = '';
          },
        ),*/
        /*  new TextFormField(
          decoration: const InputDecoration(labelText: 'Adresse'),
          keyboardType: TextInputType.text,
         // validator: validateName,
          validator: (String? val) {
            if (val != null) {
              return validateName(val);
            }
            return null; // Return null if the value is null
          },
          onSaved: (String? val) {
            if (val != null)
              customerAddressInformation['address_1'] = val;
            else
              customerAddressInformation['address_1'] = '';
          },
        ),*/
        /* new TextFormField(
          decoration: const InputDecoration(labelText: 'Ville'),
          keyboardType: TextInputType.text,
          onSaved: (String? val) {
            if (val != null)
              customerAddressInformation['city'] = val;
            else
              customerAddressInformation['city'] = '';
          },
        ),*/
        /* new TextFormField(
          decoration: const InputDecoration(labelText: 'Région / Département'),
          keyboardType: TextInputType.text,
          onSaved: (String? val) {
            if (val != null)
              customerAddressInformation['state'] = val;
            else
              customerAddressInformation['state'] = '';
          },
        ),*/
        /* new TextFormField(
          decoration: const InputDecoration(labelText: 'Code postal'),
          keyboardType: TextInputType.text,
          onSaved: (String? val) {
            if (val != null)
              customerAddressInformation['postcode'] = val;
            else
              customerAddressInformation['postcode'] = '';
          },
        ),*/
        /*  new TextFormField(
          decoration: const InputDecoration(labelText: 'Pays'),
          keyboardType: TextInputType.text,
          onSaved: (String? val) {
            if (val != null)
              customerAddressInformation['country'] = val;
            else
              customerAddressInformation['country'] = '';
          },
        ),*/
        new SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  String? validateName(String value) {
    if (value.length < 1)
      return 'Field can not be empty';
    else if (value.length < 3)
      return 'Enter a valid value';
    else
      return null;
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

  /*void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      // If all data are correct then save data and create customer
      _formKey.currentState?.save();
      bloc.createCustomer(
          customerBasicInformation, customerAddressInformation, _scaffoldKey, context)
          .then((response) {
        if (response.statusCode == 200){
       // if (response != null && response.containsKey('id')) {
          // Customer created successfully, navigate to DashboardPage
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DashboardPage()));
          showSnackbarWithProperMessage(
              _scaffoldKey, context, 'Successfully registered!1');

        }  else if (response.toString().contains('id')) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DashboardPage()));
          showSnackbarWithProperMessage(
              _scaffoldKey, context, 'Successfully registered!2');

        } else {
          // Handle other response scenarios (e.g., error message)
          // _handleCreateCustomerResponse(response);
          _handleCreateCustomerResponse("Un compte est déjà enregistré avec votre adresse e-mail.1");
          showSnackbarWithProperMessage(_scaffoldKey, context, "Un compte est déjà enregistré avec votre adresse e-mail.1");

        }
      }).catchError((error) {
        // Handle errors (e.g., network errors)
        print(error);
        showSnackbarWithProperMessage(_scaffoldKey, context, "Un compte est déjà enregistré avec votre adresse e-mail. Veuillez vous connecter.2");
      });
    } else {
      showSnackbarWithProperMessage(_scaffoldKey, context, "Un compte est déjà enregistré avec votre adresse e-mail. Veuillez vous connecter.2");
      // If data is not valid, trigger auto-validation
      setState(() {
        _autoValidate = true;
      });
    }
  }*/
 /* void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      // If all data are correct then save data and create customer
      _formKey.currentState?.save();
      bloc.createCustomer(
          customerBasicInformation, customerAddressInformation, _scaffoldKey, context)
          .then((response) {
            print(response);
        if (response != null && response.containsKey('id')) {
          // Customer created successfully, navigate to DashboardPage
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DashboardPage()));
          showSnackbarWithProperMessage(
              _scaffoldKey, context, 'Inscription réussie !');
        } else {
          // Handle other response scenarios (e.g., error message)
          _handleCreateCustomerResponse(response);
          showSnackbarWithProperMessage(
              _scaffoldKey, context, 'Un compte est déjà enregistré avec votre adresse e-mail. Veuillez vous connecter.');
        }
      });
    } else {
      // If data is not valid, trigger auto-validation
      setState(() {
        _autoValidate = true;
      });
    }
  }*/



  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      // If all data are correct then save data and create customer
      _formKey.currentState?.save();
      bloc.createCustomer(
          customerBasicInformation, customerAddressInformation, _scaffoldKey, context)
          .then((response) {
        print("_validateInputs");
        print(response);
        if (response != null && response.containsKey('id')) {
          // Store user data securely
          secureStorage.write(key: 'user_id', value: response['id'].toString());
          secureStorage.write(key: 'user_email', value: response['email']);
          secureStorage.write(key: 'password', value: response['password']);

          // Customer created successfully, navigate to DashboardPage
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DashboardPage()));
          saveCustomerData(response);
          showSnackbarWithProperMessage(
              _scaffoldKey, context, 'Inscription réussie !');
        } else {
          // Handle other response scenarios (e.g., error message)
          _handleCreateCustomerResponse(response);
          showSnackbarWithProperMessage(
              _scaffoldKey, context, 'Un compte est déjà enregistré avec votre adresse e-mail. Veuillez vous connecter.');
        }
      });
    } else {
      // If data is not valid, trigger auto-validation
      setState(() {
        _autoValidate = true;
      });
    }
  }
  void _handleCreateCustomerResponse(dynamic response) {
    print("response customer add ");
    print(response);
    if (response != null && response.containsKey('message')) {
      showSnackbarWithProperMessage(_scaffoldKey, context, response['message']);
    } else {
      // Save customer data to secure storage
      saveCustomerData(response);
      showSnackbarWithProperMessage(_scaffoldKey, context, response.toString());
    }
  }

  Future<void> saveCustomerData(Map<String, dynamic> userData) async {
    final storage = FlutterSecureStorage();

    await storage.write(key: 'userId', value: userData['id'].toString());
    await storage.write(key: 'username', value: userData['username']);
    await storage.write(key: 'first_name', value: userData['billing']['first_name']);
    await storage.write(key: 'last_name', value: userData['billing']['last_name']);
    await storage.write(key: 'email', value: userData['email']);
    await storage.write(key: 'password', value: userData['password']);
    await storage.write(key: 'phone', value: userData['billing']['phone']);
    await storage.write(key: 'role', value: userData['role']);

    for (var data in userData['meta_data']) {
      if (data['key'] == 'billing_naissance') {
        await storage.write(key: 'billing_naissance', value: data['value']);
      }
      if (data['key'] == 'billing_sexe') {
        await storage.write(key: 'billing_sexe', value: data['value']);
      }
    }
  }

  void showSnackbarWithProperMessage(final _scaffoldKey, BuildContext context, String disPlayMessage) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text(disPlayMessage),
      ),
    );

  }
 /* void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState?.save();

      // After save data to variable a http request to create a new customer
      bloc.createCustomer(customerBasicInformation, customerAddressInformation,
          _scaffoldKey, context);
    } else {
      //If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }*/
}
