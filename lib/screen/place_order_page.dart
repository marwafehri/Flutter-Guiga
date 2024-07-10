// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce_app/bloc/place_order_bloc.dart';
import 'package:woocommerce_app/helper/ui_helper.dart';
import 'package:woocommerce_app/model/ordered_product.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:woocommerce_app/helper/woocommerce_api.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:collection/collection.dart';


class BookingProduct {
  String name;
  String short_description;
  double totalCreditValue;

  BookingProduct({
    required this.name,
    // ignore: non_constant_identifier_names
    required this.short_description,
    required this.totalCreditValue,
    // Add other fields as needed
  });

  // Example factory method for converting OrderProducts to BookingProduct
  factory BookingProduct.fromOrderProducts(OrderProducts orderProduct) {
    return BookingProduct(
      name: orderProduct.name,
      short_description: orderProduct.short_description,
      totalCreditValue: orderProduct.totalCreditValue.toDouble(),
      // Initialize other fields based on OrderProducts
    );
  }
}
class DropdownList {
  const DropdownList(this.id,this.name);
  final String name;
  final int id;
}

class PlaceOrderPage extends StatefulWidget {

  var customer;  // Order place to this customer

  PlaceOrderPage(this.customer);

  @override
  PlaceOrderPageState createState() => new PlaceOrderPageState(this);
}


class PlaceOrderPageState extends State<PlaceOrderPage> {

 // late Widget _mainFormWidget;

 // var bloc;

 // late BuildContext _context;



  late Widget _mainFormWidget = SizedBox.shrink(); // Initialize with an empty widget

  late PlaceOrderBloc bloc; // Associate bloc

  late BuildContext _context;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late PlaceOrderPage parent;


  PlaceOrderPageState(this.parent);

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? selectedProductOrResourceId;
  String selectedResourceKey = '0';
  TextEditingController textController = TextEditingController();
  late DropdownList selectedUser;
  List dropdownlists = [const DropdownList(1,'Foo'), const DropdownList(2,'Bar')];
  List<Map<String, dynamic>>? bookingResources;


  @override
  void initState() {
    super.initState();
    textController.text = selectedResourceKey;
    selectedUser = dropdownlists[0];
    bloc = PlaceOrderBloc(parent.customer);
    _mainFormWidget = mainBody();
    bloc.fetchBookingResourceData();
  }




  /*fetchBookingProductsData() async {
    try {
      // Call the function to get booking products data
      var bookingProducts = await Constbooking.wc_apibooking.getBookingProductsresourceAsync();

      // Now you can use the 'bookingProducts' data in your widget
      // For example, you can print the data
      print("Booking Products Data: $bookingProducts");

      // You might want to use the data to update your UI or perform other operations

    } catch (error) {
      print('Error fetching booking products: $error');
      // Handle the error appropriately
    }
  }*/


  @override
  Widget build(BuildContext context) {
    _context = context;
    if (_mainFormWidget == null) {
      _mainFormWidget = mainBody();
    }
    return _mainFormWidget;
    // Show the form in the application
  }

  Widget mainBody() {
    return new Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: new Container(
          height: 45,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 5,
                  child: InkWell(
                      onTap: () {
                        bloc.routeToCartPage(_context, _scaffoldKey);
                      },
                      child: Container(
                          color: UIHelper.themeColor,
                          child: Center(
                            child: Text('Envoyer',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white)),
                          )))),
             /* Expanded(
                flex: 5,
                child: Center(
                  child: totalCreditWidget(),
                ),
              )*/
            ],
          ),
        ),
        resizeToAvoidBottomInset: true,
        appBar: new AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            title: new Text("Demander un devis", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
            actions: <Widget>[
              routeToCartWidget()
            ]),
        body: body());
  }

  /*
  * Function request to the bloc for total ordered product credit and return a widget with total credit value
  */

  /*Widget totalCreditWidget() {
    bloc.fetchTotalProductsCreditValue();
    return StreamBuilder(
      stream: bloc.totalCreditValueFetcher.stream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? Text(
                '\$ ' + snapshot.data.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: UIHelper.themeColor),
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }*/

  /*
  * Return the main widget body
  */
 /* Future<List<Map<String, dynamic>>?> fetchBookingResourceData() async {
    try {
      var bookingResources =
      await Constbooking.wc_apibooking.getBookingProductsresourceAsync("resources");
      this.bookingResources = bookingResources; // Store data in bloc
      return bookingResources;
    } catch (error) {
      // Handle error
      return null;
    }
  }*/

  Widget body() {
    return new Column(children: <Widget>[

      // Product list search widget
      Container(
        height: 50,
        child: new Card(
            child: new Row(
          children: <Widget>[
          /*  new Expanded(
                flex: 6,
                child: new TextField(
                  decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.abc),
                      hintText: '  Search',
                      border: InputBorder.none),
                  onChanged: bloc.onSearchTextChanged,
                )),
            new Container(
              width: 1,
              height: 50,
              color: Colors.grey,
            ),*/
           // categoriesWidget()
          ],
        )),
      ),

      // Product List Build
    //  productListBuild()
      productListBooking()
    ]);
  }

  Widget routeToCartWidget() {
    bloc.totalCountProductItemInCart();
    return StreamBuilder(
      stream: bloc.totalCountProductItemInCartFetcher.stream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? cartdButton(snapshot)
            : Center(child: Container());
      },
    );
  }

  Widget cartdButton(AsyncSnapshot<dynamic> s) {
    return new Container(
      child: new Stack(
        children: <Widget>[
          new IconButton(
              padding: EdgeInsets.all(0),
              icon:
                  new Icon(Icons.shopping_cart, color: Colors.white, size: 32),
              onPressed: () {
                bloc.routeToCartPage(_context, _scaffoldKey);
              }),
          new Positioned(
            left: 30.0,
            top: 5,
            child: Container(
                height: 24,
                width: 24,
                decoration: new BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: Text(
                  s.data.toString(),
                  style: TextStyle(color: Colors.white),
                ))),
          ),
        ],
      ),
    );
  }

  /*
  * Function request categories list by bloc
  * Return a dropdown widget by getting value
  */

  Widget categoriesWidget() {
    bloc.fetchCategories();

    return StreamBuilder(
      stream: bloc.categoriesFetcher.stream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? categoryDropDownWidget(snapshot)
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget productListBooking() {
    // bloc.fetchProducts('', '');
    bloc.fetchBookingProductData();
    return StreamBuilder(
      stream: bloc.allProducts,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          // Pass bookingResources to the widget
          return productListViewWidget(snapshot, bloc.bookingResources);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
 /* Widget productListBooking() {
    // bloc.fetchProducts('', '');
    bloc.fetchBookingResourceData();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: bloc.fetchBookingProductData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          // Pass bookingResources to the widget
          return productListViewWidget(snapshot, bloc.bookingResources);
        }
      },
    );
  }*/

  /*
  * Function takes AsyncSnapshot data for build a dropdown widget
  * Function return a Dropdown widget
  */

 /* Widget categoryDropDownWidget(AsyncSnapshot<dynamic> snapshot) {
    String selectedValue;
    List<String> categoriesList;
    snapshot.data.forEach((key, value) {
      selectedValue = key;
      categoriesList = value;
    });

    return new Expanded(
        flex: 4,
        child: Center(
          child: DropdownButtonHideUnderline(
              child: ButtonTheme(
            alignedDropdown: true,
            child: new DropdownButton(
              style: new TextStyle(
                  inherit: false,
                  color: Colors.black,
                  decorationColor: Colors.white),
              isExpanded: true, // Not necessary for Option 1
              value: selectedValue,
              onChanged: (newValue) {
                bloc.searchByCategories(newValue);
              },
              items: categoriesList.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            ),
          )),
        ));
  }*/
  Widget categoryDropDownWidget(AsyncSnapshot<dynamic> snapshot) {
    String? selectedValue; // Make selectedValue nullable
    List<String>? categoriesList; // Make categoriesList nullable

    if (snapshot.hasData) {
      Map<dynamic, dynamic> data = snapshot.data;
      if (data.isNotEmpty) {
        selectedValue = data.keys.first.toString();
        categoriesList = List<String>.from(data[selectedValue]);
      }
    }

    return Expanded(
      flex: 4,
      child: Center(
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              style: TextStyle(
                inherit: false,
                color: Colors.black,
                decorationColor: Colors.white,
              ),
              isExpanded: true,
              value: selectedValue,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  bloc.searchByCategories(newValue);
                }
              },
              items: categoriesList?.map((location) {
                return DropdownMenuItem(
                  child: Text(location),
                  value: location,
                );
              }).toList() ?? [],
            ),
          ),
        ),
      ),
    );
  }


  /*
  * Function request product list using BLoc
  * Return a list widget using Stream builder
  */

 /* Widget productListBuild() {
    bloc.fetchProducts('', '');
    return StreamBuilder(
      stream: bloc.allProducts,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? productListViewWidget(snapshot)
            : Center(child: CircularProgressIndicator());
      },
    );
  }*/

  /*
  * Function takes AsyncSnapshot data for build a ListView
  * Function return a ListView widget
  */



  //Widget productListViewWidget(AsyncSnapshot<dynamic> s) {
  Widget productListViewWidget(AsyncSnapshot<dynamic> s, List<Map<String, dynamic>>? bookingResources) {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    String? selectedResourceKey;
    String? selectedResourceName;
    String? selectedResourceValue;
    print(bookingResources);

    return Expanded(
      child: ListView.builder(
        itemCount: s.data.length,
        itemBuilder: (_, index) {
          print(s.data[index]);
          print("test");

          OrderProducts bookingProductData = s.data[index];

          String? productImageUrl = bookingProductData.imageUrl;
          String? sho_description = bookingProductData.short_description;
          RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
          String sh_description = sho_description.replaceAll(exp, '');

          if (productImageUrl != null && !productImageUrl.contains('woocommerce-placeholder')) {
            productImageUrl = bookingProductData.imageUrl;
          } else {
            productImageUrl = null;
          }
          //String? selectedResourceKey =
          //bookingProductData.resource_base_costs.isNotEmpty
          //    ? bookingProductData.resource_base_costs.keys.first
           //   : null;
          // Extract availability data
          List<Map<String, dynamic>> availability =
          List<Map<String, dynamic>>.from(bookingProductData.availability);
          print(bookingResources);
          // Example: Printing the availability data
          availability.forEach((item) {
            print("Availability Type: ${item['type']}");
            print("Bookable: ${item['bookable']}");
            print("From: ${item['from']}");
            print("To: ${item['to']}");
          });
          print(availability);

         /* List<MapEntry<String, String>> resourceArray = bookingProductData.resource_base_costs
              .map((map) => MapEntry(map.keys.first.toString(), map.values.first.toString()))
              .toList();*/
          List<MapEntry<String, String>> resourceArray = bookingProductData.resource_base_costs.entries
              .map((entry) => MapEntry(entry.key.toString(), entry.value.toString()))
              .toList();
         /* List<MapEntry<String, String>> resourceArray = (bookingProductData.resource_base_costs?.entries ?? [])
              .map((entry) => MapEntry(entry.key.toString(), entry.value.toString()))
              .toList();*/

          print("resourceArray");
          print(resourceArray);

          print("resourceArray");
          List<Map<String, dynamic>>? bookingResourcesData = bloc.bookingResourcesData;

          // Use the data in your widget
          if (bookingResourcesData != null) {
            print("Booking Resources Data in productListViewWidget: $bookingResourcesData");
            // Continue with your widget logic using the fetched data
          } else {
            print("Booking Resources Data not available yet");
            // Handle the case when data is not available yet (e.g., show a loading indicator)
          }



          return Container(
            margin: EdgeInsets.all(6),
            child: Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      child: productImageUrl != null
                          ? Image.network(productImageUrl) // Use the actual image URL
                          : Center(
                        child: Text(
                          bookingProductData.name.substring(0, 1),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      width: 40.0,
                      height: 40.0,
                      decoration: productImageUrl != null
                          ? BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(productImageUrl),
                        ),
                      )
                          : BoxDecoration(
                        shape: BoxShape.circle,
                        color: UIHelper.themeColor,
                      ),
                    ),
                    title: Text(bookingProductData.name ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       // Text("Prix: ${bookingProductData.mrp} | Stock: ${bookingProductData.stock}"),
                        Text(sh_description),


                        /*DropdownButton<DropdownList>(
                          value: selectedUser,
                          onChanged: (DropdownList? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedUser = newValue;
                              });
                            }
                          },
                          items: dropdownlists.map((user) {
                            return DropdownMenuItem<DropdownList>(
                              value: user,
                              child: Text(
                                user.name,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                        ),
                        Text("selected user name is ${selectedUser.name} : and Id is : ${selectedUser.id}"),
                        SizedBox(height: 8),*/
                       /* Text(
                          'Select Resource Key:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),*/

                        /*DropdownButton<String>(
                          value: selectedResourceKey,
                          icon: const Icon(Icons.wb_sunny),
                          iconSize: 20,
                          style: const TextStyle(color: Colors.black87, fontSize: 20.0),
                          onChanged: (String? newValue) {
                            print("Selected Value: $newValue");
                            if (newValue != null) {
                              setState(() {
                                selectedResourceKey = newValue;
                                // Update the selected resource value based on the key
                                selectedResourceValue = bookingProductData.resource_base_costs[selectedResourceKey];
                                print("Selected selectedResourceKey: $selectedResourceKey");
                                print("Selected selectedResourceValue: $selectedResourceValue");
                              });
                            }
                          },
                          isExpanded: true,

                          items: bookingProductData.resource_base_costs.entries
                              .map<DropdownMenuItem<String>>((entry) {
                            // Check if the selectedResourceKey matches a resource URL and get the corresponding name
                            String resourceName = bookingResources
                                ?.firstWhereOrNull(
                                    (resource) => resource['id'] == int.parse(entry.key))
                            ?['name'] ?? entry.key.toString();

                            print("Resource Key: ${entry.key}, Resource Name: $resourceName");


                            print(bookingProductData.resource_base_costs.entries);

                            return DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(resourceName),
                            );
                          }).toList(),
                        ),
                        Text(
                          selectedResourceKey != null
                              ? 'Resource Name: ${bookingResources?.firstWhereOrNull((resource) => resource['id'] == int.parse(selectedResourceKey!))?['name'] ?? selectedResourceKey}'
                              : 'Select a resource key',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: textController,
                          selectedResourceKey != null
                              ? 'Prix: $selectedResourceKey'
                              : '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),*/

                       /* DropdownButton<String>(
                          value: selectedResourceKey,
                          icon: const Icon(Icons.wb_sunny),
                          iconSize: 20,
                          style: const TextStyle(color: Colors.black87, fontSize: 20.0),
                          onChanged: (String? newValue) {
                            print("Selected Value: $newValue");
                            if (newValue != null) {
                              setState(() {
                                selectedResourceKey = newValue;
                                // Update the selected resource value based on the key
                                selectedResourceValue = bookingProductData.resource_base_costs[selectedResourceKey];
                                print("Selected selectedResourceKey: $selectedResourceKey");
                                print("Selected selectedResourceValue: $selectedResourceValue");
                              });
                            }
                          },
                          isExpanded: true,

                          items: resourceArray
                              .map<DropdownMenuItem<String>>((entry) {
                            return DropdownMenuItem<String>(
                              value: entry.split(':').first.trim(),
                              child: Text(entry),
                            );
                          }).toList(),
                        ),*/

                        DropdownButton<String>(
                          hint: Text("Type"),
                          value: selectedResourceKey,
                          onChanged: (newValue) {
                            setState(() {
                              selectedResourceKey = newValue!;
                              // Additional logic if needed
                              textController.text = newValue;
                              print(newValue);
                              print("newValue");
                              bloc.fetchBookingProductData();
                              bloc.fetchBookingResourceData();
                              //selectedResourceValue = bookingProductData.resource_base_costs[selectedResourceKey];
                              Map<String, dynamic>? selectedResource =
                              bookingResources?.firstWhereOrNull(
                                      (resource) => resource['id'].toString() == newValue);

                              if (selectedResource != null) {
                                print(selectedResource['id']);
                                // Set the selectedResourceValue to the name if found, otherwise use the key
                                selectedResourceValue = selectedResource['name'] ?? newValue;
                                print(selectedResourceValue);
                                print("selectedResourceValue");
                              }
                              // Set the selectedResourceValue to the name if found, otherwise use the key
                              //selectedResourceValue = selectedResource?['name'] ?? newValue;
                           //   selectedResourceValue = bookingProductData.resource_base_costs[selectedResourceKey];
                            //  print(selectedResourceValue);
                             // print("selectedResourceValue");
                            });
                          },
                          items: resourceArray
                              .map<DropdownMenuItem<String>>((entry) {
                            // Find the corresponding resource in bookingResourcesData
                            Map<String, dynamic>? selectedResource = bookingResourcesData?.firstWhereOrNull(
                                  (resource) => resource['id'].toString() == entry.key,
                            );

                            String resourceName = selectedResource?['name'] ?? entry.key.toString();

                            return DropdownMenuItem<String>(
                              value: '\€ ' + entry.value,
                              child: Text(resourceName),
                            );
                          })
                              .toList(),
                         /* items: resourceArray
                              .map<DropdownMenuItem<String>>((entry) {
                            String resourceName = bookingResources
                                ?.firstWhereOrNull((resource) =>
                            resource['id'].toString() == entry.key)
                            ?['name'] ?? entry.key.toString();

                            if (int.tryParse(resourceName) != null) {
                              resourceName = entry.key.toString();
                            }

                            print("Resource Key: ${entry.key}, Resource Name: $resourceName");

                            return DropdownMenuItem<String>(
                              value: '\€ ' + entry.value,
                              child: Text(resourceName),
                            );
                          })
                              .toList(),*/

                         /* items: resourceArray
                              .map<DropdownMenuItem<String>>((entry) {
                            // Check if the selectedResourceKey matches a resource URL and get the corresponding name
                            /*String resourceName = bookingResources
                                ?.firstWhereOrNull((resource) =>
                            resource['id'].toString() == entry.key)
                            ?['name'] ?? entry.key.toString();
                            print("Resource Key: ${entry.key}, Resource Name: $resourceName");*/

                            String resourceName = bookingResources
                                ?.firstWhereOrNull((resource) =>
                            resource['id'].toString() == entry.key)
                            ?['name'] ?? entry.key.toString();

print("bookingResources");
                            print(bookingResources);
// Check if the resourceName is a numeric value, meaning it's actually an ID
                            if (int.tryParse(resourceName) != null) {
                              // If it's a numeric value, use the entry.key as the name
                              resourceName = entry.key.toString();
                            }

                            print("Resource Key: ${entry.key}, Resource Name: $resourceName");



                            print(bookingProductData.resource_base_costs.entries);
                            return DropdownMenuItem<String>(
                              value: '\€ ' + entry.value,
                              child: Text( resourceName),
                            );
                          })
                              .toList(),*/
                         /* items: <String>['Option 1', 'Option 2', 'Option 3']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),*/

                        ),
                        Row(
                          children: [
                            Text(
                              'Prix : ',  // Your label text
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8), // Add some spacing between label and text field
                            Expanded(
                              child: TextField(
                                controller: textController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: textController.text.isNotEmpty ? '' : '0',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  /**** verifier ****/
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: 70,
                      ),
                    /*  new Flexible(
                          child: Container(
                            width: 80,
                            child: new Text(
                              selectedResourceValue != null
                                  ? 'Prix: $selectedResourceValue'
                                  : 'Select a resource key',
                              style: TextStyle(fontWeight: FontWeight.bold),

                             //   '\$ ' + bookingProductData.totalCreditValue.toString()
                             ),
                          )),
                      Spacer(),*/
                     /* Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: UIHelper.themeColor, width: 2)),
                        width: 122,
                        height: 40,
                        child: new Row(
                          children: <Widget>[
                            Container(
                              width: 39,
                              child: Center(
                                  child: IconButton(
                                      icon: Icon(Icons.remove,
                                          color: UIHelper.themeColor),
                                      onPressed: () {
                                        bloc.orderRemove(bookingProductData.id);
                                      })),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              child: Center(
                                  child: Text(
                                    bookingProductData.orderCount.toString(),
                                    style:
                                    TextStyle(color: UIHelper.themeColor),
                                  )),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: UIHelper.themeColor),
                                  left: BorderSide(
                                      width: 1.0,
                                      color: UIHelper.themeColor),
                                ),
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: 39,
                              child: Center(
                                  child: IconButton(
                                      icon: Icon(Icons.add,
                                          color: UIHelper.themeColor),
                                      onPressed: () {
                                        bloc.orderAdd(bookingProductData.id);
                                      })),
                            ),
                          ],
                        ),
                      ),*/
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  /**** verifier ****/
                  ElevatedButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          //selectedDate = pickedDate;
                          bookingProductData.selectedDate = pickedDate;
                        });

                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          setState(() {
                          //  selectedTime = pickedTime;
                            bookingProductData.selectedTime = pickedTime;
                          });

                          // TODO: Check availability for the selected date and time
                          bool isAvailable = checkAvailability(
                            bookingProductData.selectedDate!,
                            bookingProductData.selectedTime!,
                            availability,
                            bookingProductData.duration,
                            bookingProductData.buffer_period,
                          );

                          if (isAvailable) {
                            // TODO: Handle item selection for the selected date and time
                            print('Item is available for $selectedDate $selectedTime');
                          } else {
                            // TODO: Handle when the item is not available
                            print('Item is not available for $selectedDate $selectedTime');
                          }
                        }
                      }
                    },
                    child: Text('Select Date and Time'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }



  bool checkAvailability(
      DateTime selectedDate,
      TimeOfDay selectedTime,
      List<Map<String, dynamic>> availability,
      int duration,
      int bufferPeriod,
      ) {
    DateTime startTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    DateTime endTime = startTime.add(Duration(minutes: duration));

    // Check if the selected time falls within any available time slots
    for (var slot in availability) {
      String from = slot['from'];
      String to = slot['to'];

      DateTime slotStartTime = DateTime.parse('2020-01-01 $from');
      DateTime slotEndTime = DateTime.parse('2020-01-01 $to');

      // Check if the selected time is within the current slot
      if (startTime.isAfter(slotStartTime) &&
          endTime.isBefore(slotEndTime.add(Duration(minutes: bufferPeriod)))) {
        return true; // Item is available for the selected date and time
      }
    }

    return false; // Item is not available for the selected date and time
  }

  /*Widget productListViewWidget(AsyncSnapshot<dynamic> s) {
    return Expanded(
      child: ListView.builder(
        itemCount: s.data.length,
        itemBuilder: (_, index) {
          print(s.data[index]);
          print("test");
          OrderProducts bookingProductData = s.data[index];

          String? productImageUrl = bookingProductData.imageUrl;
          String? sho_description = bookingProductData.short_description;
          RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);
          String sh_description = sho_description.replaceAll(exp, '');

          if (productImageUrl != null && !productImageUrl.contains('woocommerce-placeholder')) {
            productImageUrl = bookingProductData.imageUrl;
          } else {
            productImageUrl = null;
          }

          // Extract availability data
          List<Map<String, dynamic>> availability =
          List<Map<String, dynamic>>.from(bookingProductData.availability);

          // Example: Printing the availability data
          availability.forEach((item) {
            print("Availability Type: ${item['type']}");
            print("Bookable: ${item['bookable']}");
            print("From: ${item['from']}");
            print("To: ${item['to']}");
          });

          return Container(
            margin: EdgeInsets.all(6),
            child: Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      child: productImageUrl != null
                          ? Image.network(productImageUrl) // Use the actual image URL
                          : Center(
                        child: Text(
                          bookingProductData.name.substring(0, 1),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      width: 40.0,
                      height: 40.0,
                      decoration: productImageUrl != null
                          ? BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(productImageUrl),
                        ),
                      )
                          : BoxDecoration(
                        shape: BoxShape.circle,
                        color: UIHelper.themeColor,
                      ),
                    ),
                    title: Text(bookingProductData.name ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Prix: ${bookingProductData.mrp} | Stock: ${bookingProductData.stock}"),
                        Text(sh_description),
                        // Add more details if needed
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  // Add more widgets as needed
                ],
              ),
            ),
          );
        },
      ),
    );
  }*/
 /* Widget productListViewWidget(AsyncSnapshot<dynamic> s) {
    return Expanded(
      child: ListView.builder(
        itemCount: s.data.length,
        itemBuilder: (_, index) {
          OrderProducts product = s.data[index];
          //BookingProduct bookingProduct = s.data[index]; // Assuming BookingProduct is the correct type
          BookingProduct bookingProduct = BookingProduct.fromOrderProducts(product);

          // Modify the code to access booking product information
          String? productImageUrl = product.imageUrl;
          String? sho_description = bookingProduct.short_description;
          RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);
          String sh_description = sho_description.replaceAll(exp, '');

          if (productImageUrl != null && !productImageUrl.contains('woocommerce-placeholder')) {
            productImageUrl = product.imageUrl;
          } else {
            productImageUrl = null;
          }

          return Container(
            margin: EdgeInsets.all(6),
            child: Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      child: productImageUrl != null
                          ? Container()
                          : Center(
                        child: Text(
                          bookingProduct.name.substring(0, 1),

                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      width: 40.0,
                      height: 40.0,
                      decoration: productImageUrl != null
                          ? BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(product.imageUrl),
                        ),
                      )
                          : BoxDecoration(
                        shape: BoxShape.circle,
                        color: UIHelper.themeColor,
                      ),
                    ),
                    title: Text(bookingProduct.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("MRP: ${product.mrp} | Stock: ${product.stock}"),
                        Text(sh_description),
                      ],
                    ),
                    /*subtitle: Text("MRP : " +
                        product.mrp.toString() +
                        "  |  " +
                        "Stock : " +
                        product.stock.toString()),*/// Modify this line accordingly
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(width: 70),
                      Flexible(
                        child: Container(
                          width: 80,
                          child: Text('\$ ' + bookingProduct.totalCreditValue.toString()),
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: UIHelper.themeColor, width: 2)),
                        width: 122,
                        height: 40,
                        child: new Row(
                          children: <Widget>[
                            Container(
                              width: 39,
                              child: Center(
                                  child: IconButton(
                                      icon: Icon(Icons.remove,
                                          color: UIHelper.themeColor),
                                      onPressed: () {
                                        bloc.orderRemove(product.id);
                                      })),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              child: Center(
                                  child: Text(
                                    product.orderCount.toString(),

                                    style:
                                    TextStyle(color: UIHelper.themeColor),
                                  )),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: UIHelper.themeColor),
                                  left: BorderSide(
                                      width: 1.0,
                                      color: UIHelper.themeColor),
                                ),
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: 39,
                              child: Center(
                                  child: IconButton(
                                      icon: Icon(Icons.add,
                                          color: UIHelper.themeColor),
                                      onPressed: () {
                                        bloc.orderAdd(product.id);
                                      })),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }*/
  /*Widget productListViewWidget(AsyncSnapshot<dynamic> s) {
    return new Expanded(
        child: ListView.builder(
            itemCount: s.data.length,
            itemBuilder: (_, index) {
              OrderProducts product = s.data[index];
              //BookingProduct bookingProduct = BookingProduct.fromJson(s.data[index]);

              BookingProduct bookingProduct = BookingProduct.fromOrderProducts(product);


              String? productImageUrl = product.imageUrl;
              print("bookingProducts");
              print(bookingProduct);
              print(bookingProduct.name);
              print("bookingProducts");
              if (productImageUrl != null &&
                  !productImageUrl.contains('woocommerce-placeholder')) {
                productImageUrl = product.imageUrl;
              } else {
                productImageUrl = null;
              }

              return Container(
                  margin: EdgeInsets.all(6),
                  child: Card(
                      child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: new Container(
                            child: productImageUrl != null
                                ? new Container()
                                : new Center(
                                    child: Text(
                                      bookingProduct.name.substring(0, 1),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                            width: 40.0,
                            height: 40.0,
                            decoration: productImageUrl != null
                                ? new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            new NetworkImage(product.imageUrl)))
                                : new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: UIHelper.themeColor)),
                        title: Text(bookingProduct.name),
                        subtitle: Text("MRP : " +
                            product.mrp.toString() +
                            "  |  " +
                            "Stock : " +
                            product.stock.toString()),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            width: 70,
                          ),
                          new Flexible(
                              child: Container(
                            width: 80,
                            child: new Text(
                                '\$ ' + product.totalCreditValue.toString()),
                          )),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                    color: UIHelper.themeColor, width: 2)),
                            width: 122,
                            height: 40,
                            child: new Row(
                              children: <Widget>[
                                Container(
                                  width: 39,
                                  child: Center(
                                      child: IconButton(
                                          icon: Icon(Icons.remove,
                                              color: UIHelper.themeColor),
                                          onPressed: () {
                                            bloc.orderRemove(product.id);
                                          })),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                      child: Text(
                                    product.orderCount.toString(),
                                    style:
                                        TextStyle(color: UIHelper.themeColor),
                                  )),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                          width: 1.0,
                                          color: UIHelper.themeColor),
                                      left: BorderSide(
                                          width: 1.0,
                                          color: UIHelper.themeColor),
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  width: 39,
                                  child: Center(
                                      child: IconButton(
                                          icon: Icon(Icons.add,
                                              color: UIHelper.themeColor),
                                          onPressed: () {
                                            bloc.orderAdd(product.id);
                                          })),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Add a button to create a booking for the current product


                    ],

                  )));
            }));
  }*/
}


