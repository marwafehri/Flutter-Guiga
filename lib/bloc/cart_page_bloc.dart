import "dart:core";

import 'package:flutter/material.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:rxdart/rxdart.dart';
import 'package:woocommerce_app/model/ordered_product.dart';
import 'package:woocommerce_app/screen/customer_add.dart';
import 'package:woocommerce_app/helper/ui_helper.dart';


class CartListBloc {
  //List<OrderProducts> cartProductList = new List<OrderProducts>();
  List<OrderProducts> cartProductList = [];

 // Map<String, dynamic> customer = new Map<String, dynamic>();
  Map<String, dynamic>? customer;

  final _cartProductListFetcher = BehaviorSubject<dynamic>();

  // ignore: close_sinks
  final customerFetcher = BehaviorSubject<dynamic>();

  // ignore: close_sinks
  final totalCreditValueFetcher = BehaviorSubject<dynamic>();

  //Observable<dynamic> get allCartProducts => _cartProductListFetcher.stream;
  Stream<dynamic> get allCartProducts => _cartProductListFetcher.stream;


  CartListBloc(dynamic value, var customer) {
    this.cartProductList = value;
    this.customer = customer;
  }

  fetchCustomer() {
    customerFetcher.sink.add(customer);
  }

  /*
  * This function calculate total credit value from order items
  * Sink the the value 
  */

  fetchTotalCreditValue() {
    double totalCreditValue = 0.0;
    for (int i = 0; i < cartProductList.length; i++) {
      /*if (cartProductList[i].totalCreditValue != null)
        totalCreditValue =
            totalCreditValue + cartProductList[i].totalCreditValue;*/
      totalCreditValue =
          totalCreditValue + cartProductList[i].totalCreditValue;
    }
    totalCreditValueFetcher.sink.add(totalCreditValue);
  }

  fetchOrderedProducts() async {
    _cartProductListFetcher.sink.add(cartProductList);
  }


 /* Future<Map<String, dynamic>?> createSlots(int orderId, BuildContext context) async {
    try {
      List<Map<String, dynamic>> bookingList = [];
      int customerId = customer!['id'];
      print(customerId);
      // Assuming you have the necessary information for creating a booking in the request payload
      var bookingPayload = {
        // Provide the required parameters for creating a booking
        'order_id': orderId,
        /*'start': /* Start timestamp */,
        'end': /* End timestamp */,
        'cost': /* Cost */,
        'product_id': /* Product ID */,*/
        // Add other booking details as needed
      };


      // Make a POST request to create a booking
      var bookingResponse = await Constbooking.wc_apibooking.postAsync("bookings", bookingPayload);

      print("bookingResponse");
      print(bookingResponse);

      if (bookingResponse != null && bookingResponse.containsKey('id')) {
        // Booking created successfully
        showDefaultSnackbarSlot(context, 'Congratulations! Successfully placed your booking');

        bookingList.add(bookingResponse);
        return {'bookings': bookingList};
      } else {
        showDefaultSnackbarSlot(context, 'Failed to create booking. Please try again.');
        // Handle error when booking creation fails
        return null;
      }
    } catch (e) {
      // Handle other exceptions
      print("Error: $e");
      return null;
    }
  }*/

 /* Future<Map<String, dynamic>?> createBooking(int orderId, BuildContext context) async {
    try {
      List<Map<String, dynamic>> bookingList = [];
      int customerId = customer!['id'];
      print(customerId);
      print("customerId");
      print(orderId);

      // Assuming you have the necessary information for creating a booking in the request payload
      var bookingPayload = {
        'order_id': orderId,
        'customer_id': customerId,
        // Add other booking details as needed

      };

      print(bookingPayload['start']);
      var bookingResponse = await Constbooking.wc_apibooking.postAsync("bookings", {
        "cost": "25",
        'order_id': orderId,
        'customer_id': customerId,
        "status": "cancelled",
      });
      // Make a POST request to create a booking
     // var bookingResponse = await Constbooking.wc_apibooking.postAsync("bookings", bookingPayload);
      /*var bookingResponse = await Constbooking.wc_apibooking.postAsync("bookings", {
        'order_id': orderId,
        'customer_id': customerId,
      });*/

      print("bookingResponse");
      print(bookingResponse);

      if (bookingResponse != null && bookingResponse.containsKey('id')) {
        // Booking created successfully
        showDefaultSnackbarSlot(context, 'Congratulations! Successfully placed your booking');

        bookingList.add(bookingResponse);
        return {'bookings': bookingList};
      } else {
        showDefaultSnackbarSlot(context, 'Failed to create booking. Please try again.');
        // Handle error when booking creation fails
        return null;
      }
    } catch (e) {
      // Handle other exceptions
      print("Error: $e");
      return null;
    }
  }*/
  /* Future<Map<String, dynamic>?> createBooking(int orderId, BuildContext context) async {
    try {
      //List<Map<String, dynamic>> bookingList = [];
     // Map<String, dynamic> bookingList = new Map<String, dynamic>();
      Map<String, dynamic> bookingList = {};
      int customerId = customer!['id'];
      print(customerId);
      print("customerId");
      print(orderId);

      // Assuming you have the necessary information for creating a booking in the request payload
      var bookingPayload = {
        'order_id': orderId,
        'customer_id': customerId,
        'all_day': false,
        'cost': "25", // Update with the correct cost
        'date_created': DateTime.now().millisecondsSinceEpoch ~/ 1000, // Current timestamp
        'date_modified': DateTime.now().millisecondsSinceEpoch ~/ 1000, // Current timestamp
        'end': ''/* Replace with the correct end timestamp */,
        'order_item_id':'' /* Replace with the correct order item ID */,
        'parent_id': 0,
        'person_counts': [1],
        'product_id': ''/* Replace with the correct product ID */,
        'resource_id': ''/* Replace with the correct resource ID */,
        'start':'' /* Replace with the correct start timestamp */,
        'status': 'cancelled',
        'local_timezone': 'Europe/Berlin',
      };
      print(bookingPayload);
      print("bookingPayload");

      var bookingResponse = await Constbooking.wc_apibooking.postAsync("bookings", bookingPayload);
      bookingList['booking'] = bookingResponse;
     // bookingList.add(bookingResponse);

      print("bookingResponse");
      print(bookingResponse);

      if (bookingResponse != null && bookingResponse.containsKey('id')) {
        // Booking created successfully
        showDefaultSnackbarSlot(context, 'Congratulations! Successfully placed your booking');


        return {'bookings': bookingList};
      } else {
        showDefaultSnackbarSlot(context, 'Failed to create booking. Please try again.');
        // Handle error when booking creation fails
        return null;
      }
    } catch (e) {
      // Handle other exceptions
      print("Error: $e");
      return null;
    }
  }*/

 /* Future<Map<String, dynamic>?> createBooking(int orderId, BuildContext context) async {
    try {
      Map<String, dynamic> bookingList = {};
      int customerId = customer!['id'];

      print(customerId);
      print("customerId");
      print(orderId);
      Map<String, dynamic> bookingPayload = {
        "booking": {
          "customer_id": customerId,
          "product_id": 3296,
          "booking_start_date": 1704358279,
          "appointment_segments": [
            {
              "duration_minutes": 60,
              "service_variation_id": "GUN7HNQBH7ZRARYZN52E7O4B",
              "service_variation_version": 1604352990016,
              "team_member_id": "2_uNFkqPYqV-AZB-7neN"
            }
          ],
          "customer_note": "Window seat, please",
          "location_id": "SNTR5190QMFGM",
          "location_type": "BUSINESS_LOCATION",
          "seller_note": "Complementary VIP service",
          "start_at": "2021-12-16T17:00:00Z"
        }
      };

      var bookingResponse = await Constbooking.wc_apibooking.postAsync("bookings", {
        "payment_method": bookingPayload['payment_method'],
        "payment_method_title": bookingPayload['payment_method_title'],
        "set_paid": true,
        "line_items": bookingPayload,
        "customer_id": customerId,
      });

      print("bookingResponse");
      print(bookingResponse);

      if (bookingResponse != null && bookingResponse.containsKey('id')) {
        // Booking created successfully
        showDefaultSnackbarSlot(context, 'Congratulations! Successfully placed your booking');

        // Create a map with booking details
        Map<String, dynamic> bookingDetails = {
          'order_id': orderId,
          'customer_id': customerId,
          'all_day': false,
          'cost': 25, // Update with the correct cost
          'date_created': DateTime.now().millisecondsSinceEpoch ~/ 1000,
          'date_modified': DateTime.now().millisecondsSinceEpoch ~/ 1000,
          'end': '', /* Replace with the correct end timestamp */
          'order_item_id': '', /* Replace with the correct order item ID */
          'parent_id': 0,
          'person_counts': [1],
          'product_id': '', /* Replace with the correct product ID */
          'resource_id': '', /* Replace with the correct resource ID */
          'start': '', /* Replace with the correct start timestamp */
          'status': 'cancelled',
          'local_timezone': 'Europe/Berlin',
        };

        // Add the booking details to the response
        bookingResponse.addAll(bookingDetails);

        return {'bookings': bookingResponse};
      } else {
        showDefaultSnackbarSlot(context, 'Failed to create booking. Please try again.');
        // Handle error when booking creation fails
        return null;
      }
    } catch (e) {
      // Handle other exceptions
      print("Error: $e");
      return null;
    }
  }*/
 /* Future<void> createBooking(String consumerKey, String consumerSecret, Map<String, dynamic> bookingData) async {
    try {
      final url = Uri.parse('https://www.drg.deveoo.net/wp-json/wc-bookings/v1/bookings/');
      final headers = {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
        'Content-Type': 'application/json',
      };

      final response = await http.post(url, headers: headers, body: jsonEncode(bookingData));
      print(response);
      print("response booking 11");

      if (response.statusCode == 201) {
        // Booking created successfully
        print('Booking created: ${response.body}');
      } else {
        // Handle error
        print('Failed to create booking: ${response.statusCode} ${response.body}');
        throw Exception('Booking creation failed');
      }
    } catch (error) {
      print('Error during booking creation: $error');
      // Handle network errors or other exceptions
    }
  }

// Example usage:
  String consumerKey = 'ck_050723b6b35bef5283d03ec776bf9fdb2896f2d4';
  String consumerSecret = 'cs_d3670298854d8029b649762a4fa274311041080a';
  Map<String, dynamic> bookingData = {
    "all_day": false,
    "cost": "20",
    "customer_id": 17,
    "date_created": 1700656251,
    "date_modified": 1704354584,
    "end": 1700734500,
    "google_calendar_event_id": "eo5vedpr8uibmjnukq081jfops",
    "order_id": 3392,
    "order_item_id": 11,
    "parent_id": 0,
    "person_counts": [],
    "product_id": 3296,
    "resource_id": 3297,
    "start": 1700732700,
    "status": "complete",
    "local_timezone": "",
    "_links": {
      "self": [
        {
          "href": "https://www.drg.deveoo.net/wp-json/wc-bookings/v1/bookings/3391"
        }
      ],
      "collection": [
        {
          "href": "https://www.drg.deveoo.net/wp-json/wc-bookings/v1/bookings"
        }
      ]
    }
    // ... other booking details ...
  };*/
 /* Future<Map<String, dynamic>?> createBooking(int orderId, BuildContext context) async {
    int customerId = customer!['id'];
    try {
      // Replace {ACCESS_TOKEN} with your actual Square access token
      String accessToken = "ck_050723b6b35bef5283d03ec776bf9fdb2896f2d4";

      // Replace the URL with the correct Square API endpoint
      String apiUrl = "https://www.drg.deveoo.net/wp-json/wc-bookings/v1/bookings";

      // Replace the booking data with your actual booking payload
      Map<String, dynamic> bookingPayload = {
        "booking": {
          "customer_id": customerId,
          "appointment_segments": [
            {
              "duration_minutes": 60,
              "service_variation_id": "GUN7HNQBH7ZRARYZN52E7O4B",
              "service_variation_version": 1604352990016,
              "team_member_id": "2_uNFkqPYqV-AZB-7neN"
            }
          ],
          "customer_note": "Window seat, please",
          "location_id": "SNTR5190QMFGM",
          "location_type": "BUSINESS_LOCATION",
          "seller_note": "Complementary VIP service",
          "start_at": "2021-12-16T17:00:00Z"
        }
      };

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Square-Version': '2023-12-13',
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bookingPayload),
      );

      if (response.statusCode == 200) {
        // Successful booking creation
        print('Booking created successfully');
        print(response.body);
      } else {
        // Failed to create booking
        print('Failed to create booking. Status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error: $e');
    }
  }*/
 /* Future<Map<String, dynamic>?> createBooking(int orderId, BuildContext context, Map bookingpayload) async {
    try {
      if (customer != null && customer!.containsKey('id')) {
        int customerId = customer!['id'];

        var bookingpayload = {
            //"customer_id": customerId,
            "order_id": orderId,
          "all_day": true,
          "cost": 20,
          "customer_id": 17,
          "date_created": 1700656251,
          "date_modified": 1704354584,
          "end": 1700734500,
          "google_calendar_event_id": "eo5vedpr8uibmjnukq081jfops",
          "order_id": orderId,
          "order_item_id": 11,
          "parent_id": 0,
          "person_counts": [],
          "product_id": 3296,
          "resource_id": 3297,
          "start": 1700732700,
          "status": "complete",
          "local_timezone": "",
          "_links": {
            "self": [
              {
                "href": "https://www.drg.deveoo.net/wp-json/wc-bookings/v1/bookings/3391"
              }
            ],
            "collection": [
              {
                "href": "https://www.drg.deveoo.net/wp-json/wc-bookings/v1/bookings"
              }
            ]
          },
            "appointment_segments": [
              {
                "duration_minutes": 60,
                "service_variation_id": "GUN7HNQBH7ZRARYZN52E7O4B",
                "team_member_id": "2_uNFkqPYqV-AZB-7neN",
                "service_variation_version": 1613077495453,
                "any_team_member": false,
                "intermission_minutes": 0,
              }
            ],
            "customer_note": "Window seat, please",
            "location_id": "SNTR5190QMFGM",
            "location_type": "BUSINESS_LOCATION",
            "seller_note": "Complementary VIP service",
            "start_at": "2023-01-01T17:00:00Z", // Ensure this is set correctly
          'startDate':1700732700,
        'endDate':1700734500,
        };

        print("bookingPayload:");
        print(bookingpayload);

        var bookingResponse = await Constbooking.wc_apibooking.postAsync("bookings", bookingpayload);

        print("bookingResponse:");
        print(bookingResponse);

        if (bookingResponse != null &&
            bookingResponse.containsKey('booking') &&
            bookingResponse['booking'].containsKey('id')) {
          // Extract relevant booking details from the response
          showDefaultSnackbarSlot(context, 'Booking created successfully');
        } else {
          showDefaultSnackbarSlot(context, 'Failed to create booking. Please try again.');
          return null;
        }
      } else {
        showDefaultSnackbarSlot(context, 'Customer information is missing');
        return null;
      }
    } catch (e) {
      print("Error: $e");
      showDefaultSnackbarSlot(context, 'An error occurred. Please try again.');
      return null;
    }
  }*/
 /* Future<Map<String, dynamic>?> createBooking(int orderId, BuildContext context) async {
    int customerId = customer!['id'];
    try {
      // Your booking JSON payload
      Map<String, dynamic> bookingPayload = {
        "booking": {
          "customer_id": customerId,
          "order_id": orderId, // Make sure this is a valid order ID
          "appointment_segments": [
            {
              "duration_minutes": 60,
              "service_variation_id": "GUN7HNQBH7ZRARYZN52E7O4B",
              "team_member_id": "2_uNFkqPYqV-AZB-7neN",
              "service_variation_version": 1613077495453,
              "any_team_member": false,
              "intermission_minutes": 0,
            }
          ],
          "customer_note": "Window seat, please",
          "location_id": "SNTR5190QMFGM",
          "location_type": "BUSINESS_LOCATION",
          "seller_note": "Complementary VIP service",
          "start_at": "2023-01-01T17:00:00Z", // Ensure this is set correctly
        }
      };

      // Your web service credentials
      String baseUrl = "https://www.drg.deveoo.net/wp-json/wc-bookings/v1/";
      String consumerKey = "ck_050723b6b35bef5283d03ec776bf9fdb2896f2d4";
      String consumerSecret = "cs_d3670298854d8029b649762a4fa274311041080a";

      // Encode your credentials
      String credentials = base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
      String basicAuth = 'Basic $credentials';

      // Make the API request
      var response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        },
        body: json.encode(bookingPayload),
      );

      print("response booking");
      print(response);

      if (response.statusCode == 201) {
        // Booking created successfully
        Map<String, dynamic>? bookingResponse = json.decode(response.body) as Map<String, dynamic>?;

        if (bookingResponse != null) {
          print("bookingResponse");
          print(bookingResponse);
          return {'booking': bookingResponse};
        } else {
          print('Failed to decode booking response.');
          return null;
        }
      } else {
        // Handle error when booking creation fails
        print('Failed to create booking. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle other exceptions
      print("Error: $e");
      return null;
    }
  }*/
  Future<Map<String, dynamic>?> createBooking(int orderId, BuildContext context, Map bookingData) async {
    try {
      Map<String, dynamic> bookingData = {
        "booking": {
          'order_id': orderId,
          "customer_id": "K48SGF7H116G59WZJRMYJNJKA8", // Replace with your customer ID
          "appointment_segments": [
            {
              "duration_minutes": 60,
              "service_variation_id": "GUN7HNQBH7ZRARYZN52E7O4B",
              "service_variation_version": 1604352990016,
              "team_member_id": "2_uNFkqPYqV-AZB-7neN"
            }
          ],
          "customer_note": "Window seat, please",
          "location_id": "SNTR5190QMFGM",
          "location_type": "BUSINESS_LOCATION",
          "seller_note": "Complementary VIP service",
          "start_at": "2021-12-16T17:00:00Z" // Adjust start time as needed
        }
      };

      var bookingResponse = await Constbooking.wc_apibooking.postAsync("bookings", bookingData);

      if (bookingResponse != null && bookingResponse.containsKey('id')) {
        // Booking created successfully
        showDefaultSnackbarSlot(context, 'Congratulations! Successfully placed your booking');


        print("bookingResponse");
        print(bookingResponse);
        // Add the booking details to the response
        bookingResponse.addAll(bookingResponse);

        return {'bookings': bookingResponse};
      } else {
        showDefaultSnackbarSlot(context, 'Failed to create booking. Please try again.');
        // Handle error when booking creation fails
        return null;
      }

      // return bookingResponse;
    } catch (error) {
      print("Error creating booking: $error");
      // Handle error appropriately, e.g., display user-friendly message
      return null;
    }
  }

  Future createOrder(final _scaffoldKey, BuildContext context, Map paymentInfo) async {
    if (cartProductList.length > 0) {
      if (customer != null) {
        UIHelper.showProcessingDialog(context);

        List<dynamic> orderedProductList = [];
        for (int i = 0; i < cartProductList.length; i++) {
          Map<String, dynamic> addcartProductList = new Map<String, dynamic>();
          addcartProductList.putIfAbsent(
            'product_id',
                () => int.parse(cartProductList[i].id),
          );
          addcartProductList.putIfAbsent(
            'quantity',
                () => cartProductList[i].orderCount,
          );
          orderedProductList.add(addcartProductList);
        }
        print("orderedProductList");
        print(orderedProductList);
        print("orderedProductList");

        try {
          int customerId = customer!['id'];

          var response = await Const.wc_api.postAsync("orders", {
            "payment_method": paymentInfo['payment_method'],
            "payment_method_title": paymentInfo['payment_method_title'],
            "set_paid": true,
            "line_items": orderedProductList,
            "customer_id": customerId,
          });
          print("orderedProductList response");
          print(response);
          print("orderedProductList response");

          Navigator.of(context).pop();

          if (response.containsKey('message')) {
            showDefaultSnackbar(_scaffoldKey, context, response['message']);
          } else if (response.toString().contains('id')) {
            showDefaultSnackbar(_scaffoldKey, context, 'Congratulation! Successfully place your order');

            // Create slots after order creation
            int orderId = response['id'];
            //  var slotsResult = await createSlots(orderId, context);
           /* var bookingpayload = {
              "customer_id": customerId,
              "order_id": orderId,
              'resource_id': "#3299", // Ensure this is a valid resource ID
              "appointment_segments": [
                {
                  "duration_minutes": 60,
                  "service_variation_id": "GUN7HNQBH7ZRARYZN52E7O4B",
                  "team_member_id": "2_uNFkqPYqV-AZB-7neN",
                  "service_variation_version": 1613077495453,
                  "any_team_member": false,
                  "intermission_minutes": 0,
                }
              ],
              "customer_note": "Window seat, please",
              "location_id": "SNTR5190QMFGM",
              "location_type": "BUSINESS_LOCATION",
              "seller_note": "Complementary VIP service",
              "start_at": "2023-01-01T17:00:00Z", // Ensure this is set correctly
              'startDate':1700732700,
              'endDate':1700734500,
              "status": "complete",
              "product_id": 3296,
            };*/
            var slotsResult = await createBooking(orderId, context, paymentInfo);


            if (slotsResult != null && slotsResult.containsKey('slots')) {
              // Slots created successfully
              // You can handle additional logic if needed
            } else {
              // Handle error when slot creation fails
              showDefaultSnackbar(_scaffoldKey, context, 'Failed to create slots');
            }
          } else {
            showDefaultSnackbar(_scaffoldKey, context, response.toString());
          }
        } catch (e) {
          // Handle exception
        }
      } else {
        showDefaultSnackbar(_scaffoldKey, context, 'Please! Add a customer');
      }
    } else {
      showDefaultSnackbar(_scaffoldKey, context, 'Please! At least add one order');
    }
  }


  /*

  Future createOrder(final _scaffoldKey, BuildContext context, Map paymentInfo) async {


    if (cartProductList.length > 0) { // Check the cart list empty or not

      if (customer != null) {  // Before place order check customer is available or not

        UIHelper.showProcessingDialog(context);  // Show a progress dialog during Place order http request

      //  List<dynamic> orderedProductList = new List<dynamic>(); // Prepare a product list which will be added in place order list
        List<dynamic> orderedProductList = [];
        for (int i = 0; i < cartProductList.length; i++) {
          Map<String, dynamic> addcartProductList = new Map<String, dynamic>();
          addcartProductList.putIfAbsent(
              'product_id', () => int.parse(cartProductList[i].id));
          addcartProductList.putIfAbsent(
              'quantity', () => cartProductList[i].orderCount);
          orderedProductList.add(addcartProductList);
        }

        try {
          var response = await Const.wc_api.postAsync("orders", {
            "payment_method": paymentInfo['payment_method'],
            "payment_method_title": paymentInfo['payment_method_title'],
            "set_paid": true,
           // "billing": customer['billing'],
           // "shipping": customer['shipping'],
            "line_items": orderedProductList,
          });

          Navigator.of(context).pop(); // Processing dialog close after getting the response

          if (response.containsKey('message')) //if response contains message key that means customer not created and return the reason in message key
          {
            showDefaultSnackbar(_scaffoldKey, context, response['message']);
          }
          else if (response.toString().contains('id'))  // if response contains id that customer created
          {
            showDefaultSnackbar(_scaffoldKey, context,
                'Congratulation ! Successfully place your order');
            // Create slots after order creation
            int orderId = response['id'];
            var slotsResult = await createSlots(orderId);

            if (slotsResult != null && slotsResult.containsKey('slots')) {
              // Slots created successfully
              // You can handle additional logic if needed
            } else {
              // Handle error when slot creation fails
              showDefaultSnackbar(_scaffoldKey, context, 'Failed to create slots');
            }
          }
          else
            {
              showDefaultSnackbar(_scaffoldKey, context, response.toString());
            }

        } catch (e) {

        }
      }
      else
      {
        showDefaultSnackbar(_scaffoldKey, context, 'Please ! add a customer');
      }
    }
    else
    {
      showDefaultSnackbar(
          _scaffoldKey, context, 'Please ! at least add one order');
    }

  }*/


  /*
  * This function add product count in cart by productId
  * Update the cart product list by sink to cartProductList
  * Also calculate cart product credit value
  */

  orderAdd(String productId) {
    for (int i = 0; i < cartProductList.length; i++) {
      if (productId == cartProductList[i].id) {
        int count = cartProductList[i].orderCount + 1;
        cartProductList[i].orderCount = count;
       /* if (cartProductList[i].mrp != null)
          cartProductList[i].totalCreditValue =
              double.parse(cartProductList[i].mrp) * count;*/
        cartProductList[i].totalCreditValue =
            double.parse(cartProductList[i].mrp) * count;
        break;
      }
    }
    _cartProductListFetcher.sink.add(cartProductList);
    fetchTotalCreditValue();
  }

  /*
  * This function remove product count in cart by productId
  * Update the cart product list by sink to cartProductList
  * Also calculate cart product credit value
  */

  orderRemove(String id) {
    for (int i = 0; i < cartProductList.length; i++) {
      if (id == cartProductList[i].id) {
        if (cartProductList[i].orderCount > 0) {
          int count = cartProductList[i].orderCount - 1;
          cartProductList[i].orderCount = count;
         // if (cartProductList[i].mrp != null)
            cartProductList[i].totalCreditValue =
                double.parse(cartProductList[i].mrp) * count;

          break;
        }
      }
    }

    _cartProductListFetcher.sink.add(cartProductList);
    fetchTotalCreditValue();
  }

  /*
  * Function Remove product by productId from cart
  */

  orderDelete(String productId) {
    for (int i = 0; i < cartProductList.length; i++) {
      cartProductList.removeAt(i);
    }

    _cartProductListFetcher.sink.add(cartProductList);
    fetchTotalCreditValue();
  }

  /*
    Function Route to new customer page if customer not available during place order
  */

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
