import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:woocommerce_app/helper/ui_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

class CacheManager {
  static const String boxName = "interventionsCache";

  Future<Box> openBox() async {
    var box = await Hive.openBox<Map>(boxName);
    return box;
  }

  Future<void> cacheInterventions(List<Map<String, dynamic>> data) async {
    var box = await openBox();
    await box.put('interventions', data);
  }

  Future<List<Map<String, dynamic>>?> getCachedInterventions() async {
    var box = await openBox();
    var cachedData = box.get('interventions');
    await box.close();
    return cachedData?.cast<Map<String, dynamic>>();
  }
}

class InterventionsBloc {

  List<Map<String, dynamic>>? typeintervention;
  List<Map<String, dynamic>>? listsinterventions;

  final CacheManager _cacheManager = CacheManager();

  /*fetchInterventionsData() async {
    print("Type intervention Data: fetchInterventionsData");
    try {
      // Call the function to get booking products data
     // var typeintervention =
    //  await Constwordpress.wc_apiwordpress.getDevisAsync("intervention-client");

      final String listintervention = 'https://www.drg.deveoo.net/wp-json/wp/v2/intervention-client/';
      print(listintervention);
      //${user['id']}
       final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      final http.Response typesintervention = await http.get(
        Uri.parse(listintervention),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuthusers,
        },
      );
      print("typeintervention.body");
      print(typesintervention.body);

      // Now you can use the 'bookingProducts' data in your widget
      // For example, you can print the data
      print("Type intervention Data: $typesintervention");

      if (typesintervention.statusCode == 200) {
        final List<dynamic> typeintervention = json.decode(typesintervention.body);
        return typeintervention;
      } else {
        throw Exception('Failed to load etat d intervention');
      }
      // You might want to use the data to update your UI or perform other operations
      // return typeintervention; // Corrected return statement
    } catch (error) {
      print('Error fetching Type intervention: $error');
      // Handle the error appropriately
    }
  }*/
  Future<List<Map<String, dynamic>>?> fetchInterventionsData({int perPage = 10}) async {
    try {
      final String urllistintervention = 'https://www.drg.deveoo.net/wp-json/wp/v2/intervention-client/';
      final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      List<Map<String, dynamic>> typeintervention = [];
      int currentPage = 1;

      while (true) {
        /* final http.Response response = await http.get(
          Uri.parse('$urllistintervention?per_page=$perPage&page=$currentPage'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': basicAuthusers,
          },
        );*/
        var response= await http.get(
          Uri.parse('$urllistintervention?per_page=$perPage&page=$currentPage'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': basicAuthusers,
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);
          // print('Type of responseData: ${responseData.runtimeType}');
          // print("responseData $responseData");

          print(responseData[0]);
          var jsonReponsData = responseData[0];

          // var responseData = response[0];

          if (responseData.isEmpty) {
            // No more interventions to fetch, exit the loop
            break;
          }

          typeintervention.addAll(responseData.cast<Map<String, dynamic>>());
          currentPage++;
        } else {
          // If the server returns a 400 error, it might indicate data not found, so handle it gracefully
          if (response.statusCode == 400) {
            //   print('No more interventions found.');
            break;
          } else {
            // For other error responses, throw an exception
            throw Exception('Failed to load liste interventions: ${response.statusCode}');
          }
        }
      }

      print("All interventions: $typeintervention");
      return typeintervention.isEmpty ? null : typeintervention;
    } catch (error) {
      print('Error fetching liste interventions: $error');
      throw error;
    }
  }
  fetchEtatInterventionsData() async {
    final String apiUrlEtatInterventions = 'https://www.drg.deveoo.net/wp-json/wp/v2/etat-d-intervention';
    final String basicAuthUsers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

    try {
      final http.Response responseUsers = await http.get(
        Uri.parse(apiUrlEtatInterventions),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuthUsers,
        },
      );
      if (responseUsers.statusCode == 200) {
        final List<dynamic> etatInterventions = json.decode(responseUsers.body);
        return etatInterventions;
      } else {
        throw Exception('Failed to load etat d intervention');
      }
    } catch (error) {
      throw Exception('Failed to fetch etat d intervention: $error');
    }
  }

  Future addInterventions(Map interventionsBasicInfo, final _scaffoldKey, BuildContext context) async {

    UIHelper.showProcessingDialog(context);   // Show a progress dialog during network request

    try {
      var response = await Constwordpress.wc_apiwordpress.postAsync("intervention-client", {
        "title": interventionsBasicInfo['title'],
      });
    print(response);
      print("addInterventions");

      Navigator.of(context).pop(); // Processing dialog close after getting the response

      if (response.containsKey('message')) // if response contains message key that means intervention not created and return the reason in message key
          {

        showSnackbarWithProperMessage(
            _scaffoldKey, context, response['message']);

      } else if (response.toString().contains('id'))  // if response contains id that intervention created
          {

        showSnackbarWithProperMessage(_scaffoldKey, context,
            'Congratulation ! Successfully place your intervention');


        Navigator.of(context).pop(response); // Back to intervention list page

      } else
      {
        showSnackbarWithProperMessage(_scaffoldKey, context,
            response.toString()); // JSON Object with response

      }

    } catch (e) {
    }
  }
/*
  Future<List<Map<String, dynamic>>?> fetchListeInterventions({int perPage = 10}) async {
    try {
      final String urllistintervention = 'https://www.drg.deveoo.net/wp-json/wp/v2/liste-d-intervention/';
      final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      List<Map<String, dynamic>> allInterventions = [];
      int currentPage = 1;

      while (true) {
       /* final http.Response response = await http.get(
          Uri.parse('$urllistintervention?per_page=$perPage&page=$currentPage'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': basicAuthusers,
          },
        );*/
        var response= await http.get(
          Uri.parse('$urllistintervention?per_page=$perPage&page=$currentPage'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': basicAuthusers,
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);
         // print('Type of responseData: ${responseData.runtimeType}');
         // print("responseData $responseData");

          print(responseData[0]);
          var jsonReponsData = responseData[0];

         // var responseData = response[0];

          if (responseData.isEmpty) {
            // No more interventions to fetch, exit the loop
            break;
          }

          allInterventions.addAll(responseData.cast<Map<String, dynamic>>());
          currentPage++;
        } else {
          // If the server returns a 400 error, it might indicate data not found, so handle it gracefully
          if (response.statusCode == 400) {
         //   print('No more interventions found.');
            break;
          } else {
            // For other error responses, throw an exception
            throw Exception('Failed to load liste interventions: ${response.statusCode}');
          }
        }
      }

      print("All interventions: $allInterventions");
      return allInterventions.isEmpty ? null : allInterventions;
    } catch (error) {
      print('Error fetching liste interventions: $error');
      throw error;
    }
  }
*/
  Future<List<Map<String, dynamic>>?> fetchListeInterventions({int perPage = 10}) async {
    try {
      final String urllistintervention = 'https://www.drg.deveoo.net/wp-json/wp/v2/liste-d-intervention/';
      final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      List<Map<String, dynamic>> allInterventions = [];
      int currentPage = 1;

      while (true) {
        var response = await http.get(
          Uri.parse('$urllistintervention?per_page=$perPage&page=$currentPage'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': basicAuthusers,
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);

          if (responseData.isEmpty) {
            // No more interventions to fetch, exit the loop
            break;
          }

          // Extract only the title and id of each intervention and add them to the list
          for (var intervention in responseData) {
            if (intervention is Map<String, dynamic>) {
              allInterventions.add({
                'id': intervention['id'],
                'title': intervention['title']['rendered'],
                'type-d-intervention': intervention['type-d-intervention'],
              });
            }
          }
          currentPage++;
        } else {
          // If the server returns a 400 error, it might indicate data not found, so handle it gracefully
          if (response.statusCode == 400) {
            break;
          } else {
            // For other error responses, throw an exception
            throw Exception('Failed to load liste interventions: ${response.statusCode}');
          }
        }
      }

      print("All interventions: $allInterventions");
      return allInterventions.isEmpty ? null : allInterventions;
    } catch (error) {
      print('Error fetching liste interventions: $error');
      throw error;
    }
  }
  Future<Map<String, dynamic>?> fetchSingleIntervention(int postId) async {
    try {
      final String url = 'https://www.drg.deveoo.net/wp-json/wp/v2/liste-d-intervention/$postId';
      final String basicAuthUsers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      final http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuthUsers,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to load data single intervention');
      }
    } catch (error) {
      print('Error fetching single intervention: $error');
      throw error;
    }
  }

  void showDefaultSnackbar(final _scaffoldKey) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text('Please! At least add one intervention'),
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
