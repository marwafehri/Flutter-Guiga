import 'dart:async';
import 'package:flutter/material.dart';
import 'package:woocommerce_app/helper/ui_helper.dart';

import 'package:rxdart/rxdart.dart';

class CustomerLoginBloc {
  // ignore: close_sinks
  final _customerListFetcher = BehaviorSubject<dynamic>();

//  Observable<dynamic> get allCustomers => _customerListFetcher.stream;
  Stream<dynamic> get allCustomers => _customerListFetcher.stream;


  Future login(String email, String password, final _scaffoldKey, BuildContext context) async {
    UIHelper.showProcessingDialog(context);


   /* try {
      var response = await Const.wc_api.loginGetAsync("customers", {
        "email": email,
        "password": password,
      });
      print(response);
      print("response email password");
      /*var response = await Const.wc_api.postAsync(
        "customers/login",
        {
          "username": email,
          "password": password,
        },
      );*/
      if (response is List && response.isNotEmpty) {
        var customerMap = response[0];

        if (customerMap is Map<String, dynamic>) {
          _customerListFetcher.sink.add(customerMap);
          print(customerMap);
          print('response email password');

          Navigator.of(context).pop();

          if (customerMap.containsKey('message')) {
            showSnackbarWithProperMessage(
                _scaffoldKey, context, customerMap['message']);
          } else if (customerMap.toString().contains('id')) {
            showSnackbarWithProperMessage(_scaffoldKey, context,
                'Login successful!'); // Adjust the message accordingly

            // You might want to navigate to another page or handle the successful login here
          } else {
            showSnackbarWithProperMessage(_scaffoldKey, context,
                customerMap.toString());
          }
        } else {
          print('Unexpected customer map format: $customerMap');
        }
      } else {
        print('Unexpected response format: $response');
      }

      } catch (e) { // Handle the case where the response is not a Map

      print('Error during login: $e');
    }*/
  }

  /*
    Function Display proper message to user after requesting to create a customer
  */

  void showSnackbarWithProperMessage(final _scaffoldKey, BuildContext context, String disPlayMessage) {

          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              duration: Duration(minutes: 5),
              content: Text(disPlayMessage),
            ),
          );

    }
}
