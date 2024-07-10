import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:woocommerce_app/helper/ui_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ContactFormBloc {


  Future sendContactForm(Map contactformBasicInfo, final _scaffoldKey, BuildContext context) async {

    UIHelper.showProcessingDialog(context);   // Show a progress dialog during network request

    try {
      var response = await ConstwordForm.wc_apiwordform.postAsync("contact-forms/4016/feedback", {
        "your-name": contactformBasicInfo['your-name'],
        "phone": contactformBasicInfo['phone'],
        "your-email": contactformBasicInfo['your-email'],
        "your-message": contactformBasicInfo['your-message'],
      });
      print(response);
      print("addForm");

      Navigator.of(context).pop(); // Processing dialog close after getting the response

      if (response.containsKey('message')) // if response contains message key that means intervention not created and return the reason in message key
          {

        showSnackbarWithProperMessage(
            _scaffoldKey, context, response['message']);

      } else if (response.toString().contains('id'))  // if response contains id that intervention created
          {

        showSnackbarWithProperMessage(_scaffoldKey, context,
            'Congratulation ! Successfully place your form');


        Navigator.of(context).pop(response); // Back to intervention list page

      } else
      {
        showSnackbarWithProperMessage(_scaffoldKey, context,
            response.toString()); // JSON Object with response

      }

    } catch (e) {
    }
  }

  void showDefaultSnackbar(final _scaffoldKey) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text('Please! At least add one form'),
      ),
    );
  }
  void showSnackbarWithProperMessage(final _scaffoldKey, BuildContext context, String disPlayMessage) {

    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(minutes: 5),
        content: Text(disPlayMessage),
      ),
    );

  }

}
