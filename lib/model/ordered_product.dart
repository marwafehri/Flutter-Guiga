import 'package:flutter/src/material/time.dart';

class OrderProducts {

  OrderProducts(
      { required this.id,
        required this.name,
        // ignore: non_constant_identifier_names
        required this.short_description,
        required this.imageUrl,
        required this.mrp,
        required this.stock,
        required this.totalCreditValue,
        required this.orderCount,
        required this.availability,
        required this.buffer_period,
        required this.duration,
        // ignore: non_constant_identifier_names
        required this.resource_ids,
        // ignore: non_constant_identifier_names
        required this.resource_base_costs,
        DateTime? selectedDate,
        TimeOfDay? selectedTime, // Make selectedTime optional
      })   :
        selectedDate = selectedDate ?? DateTime.now(),
        selectedTime = selectedTime ?? TimeOfDay.now();

  String id;
  String name;
  // ignore: non_constant_identifier_names
  String short_description;
  String imageUrl;
  String mrp;
  int stock;
  double totalCreditValue;
  int orderCount = 0;
  List<Map<String, dynamic>> availability;
  int buffer_period;
  int duration;
  List<int> resource_ids;
  DateTime selectedDate;
  TimeOfDay selectedTime;
  //List<Map<String, dynamic>> resource_base_costs;
  Map<String, dynamic> resource_base_costs;
//  Map<String, String> resource_base_costs;
 // List<Map<String, dynamic>> resource_base_costs;

  factory OrderProducts.fromJson(Map<String, dynamic> json, int count) {
    String imageUrl = json['images'] != null && json['images'].isNotEmpty
        ? json['images'][0]['src'] as String
        : ''; // Set a default value if "images" is null or empty

    /*List<Map<String, dynamic>> resourceBaseCosts = [];
    if (json["resource_base_costs"] is List) {
      resourceBaseCosts = (json["resource_base_costs"] as List)
          .map((costItem) => costItem as Map<String, dynamic>)
          .toList();
    } else if (json["resource_base_costs"] is Map) {
      resourceBaseCosts.add(json["resource_base_costs"] as Map<String, dynamic>);
    }*/

    dynamic resourceBaseCosts;
    if (json["resource_base_costs"] is List) {
      resourceBaseCosts = (json["resource_base_costs"] as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } else if (json["resource_base_costs"] is Map) {
      resourceBaseCosts = json["resource_base_costs"];
    }

    /* List<Map<String, dynamic>> resourceBaseCostsList = json['resource_base_costs'] != null
        ? List<Map<String, dynamic>>.from(json['resource_base_costs'])
        : [];

    Map<String, String> resourceBaseCosts = Map<String, String>.fromIterable(
      resourceBaseCostsList,
      key: (item) => item['key'].toString(),
      value: (item) => item['value'].toString(),
    );*/
    return OrderProducts(
      orderCount: count,
      totalCreditValue: 0.0,
      id: json['id'].toString() as String,
      name: json['name'] as String,
      short_description: json['short_description'] as String,
      imageUrl: imageUrl,
      mrp: json['price'].toString() as String,
      stock: json['stock_quantity'] == null ? 0 : json['stock_quantity'] as int,
      availability: List<Map<String, dynamic>>.from(json["availability"]),
      buffer_period: json['buffer_period'] == null ? 0 : json['buffer_period'] as int,
      duration: json['duration'] == null ? 0 : json['duration'] as int,
      //resource_ids: List<int>.from(json['resource_ids']),
    //  resource_base_costs: resourceBaseCosts,
     // resource_base_costs: List<Map<String, dynamic>>.from(json["resource_base_costs"]),
      resource_ids: (json['resource_ids'] as List<dynamic>?)
          ?.map((id) => id as int)
          .toList() ?? [],
      resource_base_costs: resourceBaseCosts,
    //  resource_base_costs: Map<String, String>.from(json['resource_base_costs']),
    );
    /*return OrderProducts(
      orderCount:count,
      totalCreditValue:0.0,
      id: json['id'].toString() as String,
      name: json['name'] as String,
      short_description : json['short_description'] as String,
     // imageUrl: json["images"][0]["src"] as String,
      imageUrl: imageUrl,
      mrp: json['price'].toString() as String,
     // stock: json['stock_quantity']  as int,
      stock: json['stock_quantity'] == null ? 0 : json['stock_quantity'] as int,
      availability: List<Map<String, dynamic>>.from(json["availability"]),
      buffer_period: json['buffer_period'] == null ? 0 : json['buffer_period'] as int,
      duration: json['duration'] == null ? 0 : json['duration'] as int,
      resource_ids: List<int>.from(json['resource_ids']),
      //resource_base_costs: List<Map<String, dynamic>>.from(json["resource_base_costs"]),
      resource_base_costs: Map<String, String>.from(json['resource_base_costs']),
    );*/
  }


}