import "dart:core";

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:woocommerce_app/model/ordered_product.dart';
import 'package:woocommerce_app/screen/customer_add.dart';


class DevisListBloc {
  //List<OrderProducts> cartProductList = new List<OrderProducts>();
  List<OrderProducts> cartProductList = [];

 // Map<String, dynamic> customer = new Map<String, dynamic>();
  Map<String, dynamic>? customer;

  final _cartProductListFetcher = BehaviorSubject<dynamic>();

  // ignore: close_sinks
  final customerFetcher = BehaviorSubject<dynamic>();

  final totalCreditValueFetcher = BehaviorSubject<dynamic>();

  //Observable<dynamic> get allCartProducts => _cartProductListFetcher.stream;
  Stream<dynamic> get allCartProducts => _cartProductListFetcher.stream;


  DevisListBloc(dynamic value, var customer) {
    this.cartProductList = value;
    this.customer = customer;
  }

  fetchCustomer() {
    customerFetcher.sink.add(customer);
  }


  routeToCustomerAddPage(BuildContext context) {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => CustomerAddPage()))
        .then((onValue) {
      if (onValue != null) {
        this.customer = onValue;
        fetchCustomer();
      }
    });
  }

  dispose() {
    _cartProductListFetcher.close();
  }


  /*
    Function Display proper message to user after requesting to create a order
  */

  void showDefaultSnackbarSlot(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(minutes: 5),
        content: Text(message),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Ok',
          onPressed: () {
            // Your onPressed logic here
            if (!message.contains('customer'))
              Navigator.of(context).pop(customer); // Back to customer list page
          },
        ),
      ),
    );
  }
  void showDefaultSnackbar(
      final _scaffoldKey, BuildContext context, String message) {
   // _scaffoldKey.currentState.showSnackBar(
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(minutes: 5),
        content: Text(message),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Ok',
          onPressed: () {
            if (!message.contains('customer'))
              Navigator.of(context).pop(customer); // Back to customer list page
          },
        ),
      ),
    );
  }


}
