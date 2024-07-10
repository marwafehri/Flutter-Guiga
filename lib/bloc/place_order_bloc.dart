import 'package:flutter/material.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:woocommerce_app/model/ordered_product.dart';
import 'package:woocommerce_app/screen/cart_page.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import "dart:core";

class PlaceOrderBloc {

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

  List<Map<String, dynamic>>? bookingResources;
  List<Map<String, dynamic>>? bookingResourcesData;
  final _bookingResourcesController = StreamController<List<Map<String, dynamic>>>();

  Stream<List<Map<String, dynamic>>> get bookingResourcesStream => _bookingResourcesController.stream;




  PlaceOrderBloc(var customer) {
    this.customer = customer;
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

  fetchBookingResourceData() async {
    try {
      // Call the function to get booking products data
      var bookingResources =
      await Constbooking.wc_apibooking.getBookingProductsresourceAsync("resources");

      // Store the fetched data in the bookingResourcesData property
      bookingResourcesData = List<Map<String, dynamic>>.from(bookingResources);

      // Now you can use the 'bookingProducts' data in your widget
      // For example, you can print the data
      print("Booking Products resource Data: $bookingResources");

      // Notify listeners about the updated data
      _bookingResourcesController.add(bookingResourcesData!);

      // You might want to use the data to update your UI or perform other operations
      return bookingResourcesData; // Corrected return statement
    } catch (error) {
      print('Error fetching booking resource: $error');
      // Handle the error appropriately
      return null;
    }
  }

 /* fetchBookingResourceData() async {
    try {
      // Call the function to get booking products data
      var bookingResources =
      await Constbooking.wc_apibooking.getBookingProductsresourceAsync("resources");

      // Now you can use the 'bookingProducts' data in your widget
      // For example, you can print the data
      print("Booking Products resource Data: $bookingResources");
      _productListFetcher.sink.add(productList);
      // You might want to use the data to update your UI or perform other operations
      return bookingResources; // Corrected return statement
    } catch (error) {
      print('Error fetching booking resource: $error');
      // Handle the error appropriately
      return null;
    }
  }*/

  fetchBookingProductData() async {
    var bookingProducts = await Constbooking.wc_apibooking.getBookingProductsAsync("products");
    print(bookingProducts);
    print("bookingProducts bookingProducts");

    // productList = new List<OrderProducts>();
    productList = [];

    // This loops keep track add to cart item after refresh the product list

    for (int i = 0; i < bookingProducts.length; i++) {
      productList.add(new OrderProducts.fromJson(bookingProducts[i] , 0));


    }

    _productListFetcher.sink.add(productList);

  /*  try {
      // Call the function to get booking products data
      // var bookingProducts = await Constbooking.wc_apibooking.getBookingProductsresourceAsync();
      var bookingProducts = await Constbooking.wc_apibooking.getBookingProductsAsync("products");
      print("bookingProducts");
print(bookingProducts);
print("bookingProducts");

      // productList = new List<OrderProducts>();
      productList = [];

      // This loops keep track add to cart item after refresh the product list

      for (int i = 0; i < bookingProducts.length; i++) {
        bool isTrue = true;

        orderCount.forEach((key, value) {
          if (key == bookingProducts[i]['id'].toString()) {
           // productLists.add(OrderProducts.fromJson(bookingProducts[i] as Map<String, dynamic>, value.orderCount));
            productList.forEach((product) {
              // if (product.orderCount > 0) {
              productList.add(OrderProducts.fromJson(bookingProducts[i], value.orderCount));
              // }
            });
            isTrue = false;
            return;
          }
        });

        if (isTrue) {
          productList.add(OrderProducts.fromJson(bookingProducts[i] as Map<String, dynamic>, 0));
          print("yeeees");
        } else {
          print("noooon");
        }
      }

      _productListFetcher.sink.add(productList);

      // Now you can use the 'bookingProducts' data in your widget
      // For example, you can print the data
      print("Booking Products Data: $bookingProducts");

      // You might want to use the data to update your UI or perform other operations

    } catch (error) {
      print('Error fetching booking products: $error');
      // Handle the error appropriately
    }*/
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
