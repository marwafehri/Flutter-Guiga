import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:woocommerce_app/model/ordered_product.dart';
import 'package:woocommerce_app/screen/cart_page.dart';

import 'package:rxdart/rxdart.dart';

class PlaceDevisBloc {

 // List<OrderProducts> productList = new List<OrderProducts>();
  List<OrderProducts> productList = [];


  Map<String, OrderProducts> orderCount = new Map<String, OrderProducts>();

  Map<String, String> categories = new Map<String, String>();

  var customer;

  final _productListFetcher = BehaviorSubject<dynamic>();

  //Observable<dynamic> get allProducts => _productListFetcher.stream;
  Stream<dynamic> get allProducts => _productListFetcher.stream;


  // ignore: close_sinks
  final totalCountProductItemInCartFetcher = BehaviorSubject<dynamic>();
  // ignore: close_sinks
  final totalCreditValueFetcher = BehaviorSubject<dynamic>();
  // ignore: close_sinks
  final categoriesFetcher = BehaviorSubject<dynamic>();

  //List<String> categoriesKeys = new List<String>();
  List<String> categoriesKeys = [];

  List<Map<String, dynamic>>? typeintervention;


  PlaceDevisBloc(var customer) {
    this.customer = customer;
  }
  Future<dynamic> submitForm() async {
    try {
      // Add your logic to submit the form data
      // For example, you can call an API or perform other operations
      var result = await Const.wc_api.getDevisAsync("customers");// Replace with your API call

      // You might want to use the result data in your widget
      print("Form Submission Result: $result");

      return result; // Return the result data
    } catch (error) {
      print('Error submitting form: $error');
      // Handle the error appropriately
      throw error; // Rethrow the error
    }
  }

  /*
  * Fetch the customer list filtering by search text
  */
  onSearchTextChanged(String text) async {
    fetchProducts(text, '');
  }

  /*
  * This function calculate total credit value from order items
  * Sink the the value
  */

  fetchTotalProductsCreditValue() {
    double totalCreditValue = 0.0;
    for (int i = 0; i < productList.length; i++) {
      totalCreditValue = totalCreditValue + productList[i].totalCreditValue;
    }
    totalCreditValueFetcher.sink.add(totalCreditValue);
  }


  fetchDevisData() async {
    try {
      // Call the function to get booking products data
      var typeintervention =
      await Constwordpress.wc_apiwordpress.getDevisAsync("intervention-client");


      // Now you can use the 'bookingProducts' data in your widget
      // For example, you can print the data
      print("Type intervention Data: $typeintervention");

      // You might want to use the data to update your UI or perform other operations
      return typeintervention; // Corrected return statement
    } catch (error) {
      print('Error fetching Type intervention: $error');
      // Handle the error appropriately
    }
  }
  fetchBookingProductData() async {
    try {
      var bookingProducts = await Constbooking.wc_apibooking.getBookingProductsAsync("products");

      productList = [];

      for (int i = 0; i < bookingProducts.length; i++) {
        bool isTrue = true;

        orderCount.forEach((key, value) {
          if (key == bookingProducts[i]['id'].toString()) {
            productList.add(OrderProducts.fromJson(bookingProducts[i] as Map<String, dynamic>, value.orderCount));
            isTrue = false;
            return;
          }
        });

        if (isTrue) {
          productList.add(OrderProducts.fromJson(bookingProducts[i] as Map<String, dynamic>, 0));
        }
      }

      _productListFetcher.sink.add(productList);

      print("Booking Products Data: $bookingProducts");

    } catch (error) {
      print('Error fetching booking products: $error');
    }
  }

  fetchCategories() async {

    var response = await Const.wc_api.getAsync("products/categories");

    categories = new Map<String, String>();

    categories['Select a category'] = '';

    for (int i = 0; i < response.length; i++) {
      print(response[i]['id']);
      categories.putIfAbsent(response[i]['name'], () => response[i]['id'].toString());
    }

   // categoriesKeys = new List<String>();
    categoriesKeys = [];

    for (String value in categories.keys) {
      categoriesKeys.add(value);
    }

    if (categoriesKeys.length > 0) {
      Map<String, List<String>> category = new Map<String, List<String>>();

      category[categoriesKeys[0]] = categoriesKeys;

      categoriesFetcher.sink.add(category);
    }
  }

  /*
  * Function return products list
  * Search and Filtering by product name and product category
  */

  fetchProducts(String search, String categoryId) async {
    var response = await Const.wc_api
        .getAsync("products?search=" + search + "&category=" + categoryId);

   // productList = new List<OrderProducts>();
    productList = [];

    // This loops keep track add to cart item after refresh the product list

    for (int i = 0; i < response.length; i++) {
      productList.add(new OrderProducts.fromJson(response[i], 0));

    /* bool isTrue = true;

      orderCount.forEach((key, value) {
        if (key == response[i]['id'].toString()) {
          productList.add(new OrderProducts.fromJson(response[i], value.orderCount));
          isTrue = false;
          return;
        }
      });

      if (isTrue) {
        productList.add(new OrderProducts.fromJson(response[i], 0));
      }*/
    }

    _productListFetcher.sink.add(productList);
  }

  /*
  * This function add product count in cart by productId
  * Update the cart product list by sink to cartProductList
  * Also calculate cart product credit value
  */

  orderAdd(String id) {
    for (int i = 0; i < productList.length; i++) {
      if (id == productList[i].id) {
        int count = productList[i].orderCount + 1;
        productList[i].orderCount = count;
        productList[i].totalCreditValue =
            double.parse(productList[i].mrp) * count;
        orderCount[id] = productList[i];
        break;
      }
    }

    _productListFetcher.sink.add(productList);
    fetchTotalProductsCreditValue();
    totalCountProductItemInCart();
  }

  /*
  * This function remove product count in cart by productId
  * Update the cart product list by sink to cartProductList
  * Also calculate cart product credit value
  */

  orderRemove(String id) {
    for (int i = 0; i < productList.length; i++) {
      if (id == productList[i].id) {
        if (productList[i].orderCount > 0) {
          int count = productList[i].orderCount - 1;
          productList[i].orderCount = count;
          if (productList[i].mrp != null)
            productList[i].totalCreditValue =
                double.parse(productList[i].mrp) * count;
          orderCount[id] = productList[i];

          break;
        }
      }
    }

    _productListFetcher.sink.add(productList);
    fetchTotalProductsCreditValue();
    totalCountProductItemInCart();
  }

  searchByCategories(String value) {

    if (categoriesKeys.length > 0) {
      Map<String, List<String>> category = new Map<String, List<String>>();

      category[value] = categoriesKeys;

      categoriesFetcher.sink.add(category);
    }

    fetchProducts('', categories[value].toString());
  }
 /* routeToCartPage(BuildContext context, final _scaffoldKey) {
    List<OrderProducts> productsList = [];

    orderCount.forEach((k, v) {
      if (v.orderCount > 0) {
        productsList.add(v);
      }
    });

    if (productsList.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartListPage(productsList, this.customer),
        ),
      ).then((onValue) {
        // Check if onValue is not null and is of the expected type
       // if (onValue != null && onValue is Map<String, dynamic>) {
          this.customer = onValue;
         // orderCount = new Map<String, OrderProducts>();
          fetchProducts('', '');
          totalCountProductItemInCartFetcher.sink.add(0);
          totalCreditValueFetcher.sink.add(0.00);
       // }
      });
    } else {
      showDefaultSnackbar(_scaffoldKey);
    }
  }*/
  routeToCartPage(BuildContext context, final _scaffoldKey) {

   // List<OrderProducts> productsList = new List<OrderProducts>();
    List<OrderProducts> productsList = [];
    productList.forEach((product) {
     // if (product.orderCount > 0) {
        productsList.add(product);
     // }
    });

   /* orderCount.forEach((k, v) {
      if (v.orderCount > 0) {
        productsList.add(v);
      }
    });*/

   // if (productsList.length > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CartListPage(productsList, this.customer))).then((onValue) {

       /* if (onValue != null) {
          this.customer = onValue;
          orderCount = new Map<String, OrderProducts>();
          fetchProducts('', '');
          totalCountProductItemInCartFetcher.sink.add(0);
          totalCreditValueFetcher.sink.add(0.00);
        }*/
        if (onValue != null && onValue is Map<String, dynamic>) {
          this.customer = onValue;
          orderCount = new Map<String, OrderProducts>();
          fetchProducts('', '');
          totalCountProductItemInCartFetcher.sink.add(0);
          totalCreditValueFetcher.sink.add(0.00);
        }




      });
   // } else {
    //  showDefaultSnackbar(_scaffoldKey);
    //}
  }

  dispose() {
    _productListFetcher.close();
  }

  totalCountProductItemInCart() {
 //   List<OrderProducts> productsList = new List<OrderProducts>();
    List<OrderProducts> productsList = [];

    orderCount.forEach((k, v) {
     // if (v.orderCount > 0) {
        productsList.add(v);
    //  }
    });

    totalCountProductItemInCartFetcher.sink.add(productsList.length);
  }

  /*
    Function Display proper message to user
  */
  /*void showDefaultSnackbar(final _scaffoldKey) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text('Please ! At least add one order'),
      ),
    );
  }*/
  void showDefaultSnackbar(final _scaffoldKey) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text('Please! At least add one order'),
      ),
    );
  }


}
