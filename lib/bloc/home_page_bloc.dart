import 'package:rxdart/rxdart.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePageBloc {


  final customerCountFetcher = BehaviorSubject<dynamic>();

  final productCountFetcher = BehaviorSubject<dynamic>();

  final orderCountFetcher = BehaviorSubject<dynamic>();

  final averageSalesValueFetcher = BehaviorSubject<dynamic>();

  final netSalesValueFetcher = BehaviorSubject<dynamic>();

  final totalSalesValueFetcher = BehaviorSubject<dynamic>();


  fetchSalesReports() async {
    var response= await Const.wc_api.getAsync('reports/sales?date_min=2016-05-03&date_max=2050-05-04');
    print("fetchSalesReports");
    print(response);

    var totalSales = response[0];
    print(totalSales);
    print("totalSales");
    //averageSalesValueFetcher.sink.add(totalSales['average_sales']);
    //netSalesValueFetcher.sink.add(totalSales['net_sales']);
    //totalSalesValueFetcher.sink.add(totalSales['total_sales']);
  }

 /* fetchPerModuleCount(String value) async {

    var p = await Const.wc_api.getCountAsync(value);
    if (value == 'customers') {
      customerCountFetcher.sink.add(p['count']);
    } else if (value == 'products') {
      productCountFetcher.sink.add(p['count']);
    } else if (value == 'orders') {
      orderCountFetcher.sink.add(p['count']);
    }
  }*/
  fetchPerModuleCount(String value) async {
    var p = await Const.wc_api.getCountAsync(value);
    print("url p");
    print(p);
    if (p.isNotEmpty) {
      // Assuming 'count' is at index 0 in the list, modify accordingly
      var countValue = p.length;
      // Check if 'count' is present and is not null
      if (countValue != null) {
        // Convert the 'count' value to an int
        int count = int.parse(countValue.toString());

        if (value == 'customers') {
          customerCountFetcher.sink.add(count);
        } else if (value == 'products') {
          productCountFetcher.sink.add(count);
        } else if (value == 'orders') {
          orderCountFetcher.sink.add(count);
        }
      } else {
        // Handle the case where 'count' is null
        print('Invalid count value: $countValue');
      }
    } else {
      // Handle the case where the response list is empty
      print('Empty response list');
    }
  }
}
