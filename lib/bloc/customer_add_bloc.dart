import 'dart:async';
import 'package:flutter/material.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:woocommerce_app/helper/ui_helper.dart';
import 'package:woocommerce_app/screen/dashboard_page.dart';

class CustomerAddBloc {

  Future<dynamic> createCustomer(
      Map customerBasicInfo, Map customerAddressInfo, final _scaffoldKey, BuildContext context) async {
    UIHelper.showProcessingDialog(context); // Show progress dialog

    try {
      var response = await Const.wc_api.postAsync("customers", {
        "email": customerBasicInfo['email'],
        "password": customerBasicInfo['password'],
        "first_name": customerBasicInfo['firstName'],
        "username": customerBasicInfo['userName'],
        "billing": customerAddressInfo,
        "shipping": customerAddressInfo
      });
      print("CustomerAddBloc");
      print(response);
      Navigator.of(context).pop(); // Close progress dialog

      return response;
    } catch (e) {
      // Handle errors
      print(e);
      return null;
    }
  }
/*
  Future createCustomer(Map customerBasicInfo, Map customerAddressInfo, final _scaffoldKey, BuildContext context) async {

    UIHelper.showProcessingDialog(context);   // Show a progress dialog during network request

    try {
      var response = await Const.wc_api.postAsync("customers", {
        "email": customerBasicInfo['email'],
        "first_name": customerBasicInfo['firstName'],
        "username": customerBasicInfo['userName'],
        "billing": customerAddressInfo,
        "shipping": customerAddressInfo
      });

      print(response);
      print("addInterventions");
      Navigator.of(context).pop(); // Processing dialog close after getting the response

      if (response.containsKey('message')) // if response contains message key that means customer not created and return the reason in message key
      {
print("dqdd 1 ");
print(response['message']);
       // showSnackbarWithProperMessage(_scaffoldKey, context, response['message']);
        showSnackbarWithProperMessage(_scaffoldKey, context, "Un compte est déjà enregistré avec votre adresse e-mail.5");

      } else if (response.toString().contains('id'))  // if response contains id that customer created
      {
        print("dqdd 2 ");

        showSnackbarWithProperMessage(_scaffoldKey, context,
            'Congratulation ! Successfully place your order');


       /* Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );*/
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));

      } else
        {
          print("dqdd 3 ");
         // showSnackbarWithProperMessage(_scaffoldKey, context, response.toString()); // JSON Object with response
          showSnackbarWithProperMessage(_scaffoldKey, context, "Un compte est déjà enregistré avec votre adresse e-mail.6");
        }

    } catch (e) {
    }
  }*/

  /*
    Function Display proper message to user after requesting to create a customer
  */

 /* void showSnackbarWithProperMessage(final _scaffoldKey, BuildContext context, String disPlayMessage) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(minutes: 5),
        content: Text(disPlayMessage),
      ),
    );

  }*/
 /* void showDefaultSnackbar(final _scaffoldKey) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text('Please! At least add one blog'),
      ),
    );
  }*/
  void showSnackbarWithProperMessage(final _scaffoldKey, BuildContext context, String disPlayMessage) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(minutes: 5),
        content: Text(disPlayMessage),
      ),
    );
  }
}
