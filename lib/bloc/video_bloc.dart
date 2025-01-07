import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideosBloc {

  List<Map<String, dynamic>>? listsvideo;

  Future<List<Map<String, dynamic>>?> fetchVideoLink({int perPage = 10}) async {
    try {
      final String urllistsvideo = 'https://www.drg.deveoo.net/wp-json/wp/v2/videos/';
      final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      List<Map<String, dynamic>> listsvideo = [];
      int currentPage = 1;

      while (true) {
       
        var response= await http.get(
          Uri.parse('$urllistsvideo?per_page=$perPage&page=$currentPage'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': basicAuthusers,
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);
          // print('Type of responseData: ${responseData.runtimeType}');
          // print("videos $responseData");

         // print(responseData[0]);
          var jsonReponsData = responseData[0];

          // var responseData = response[0];

          if (responseData.isEmpty) {
            print("No more data to fetch.");
          } else {
            // Process the categories only if data is not empty
            for (var videos in responseData) {
              if (videos is Map<String, dynamic>) {
                listsvideo.add({
                  'urlvideo': videos['acf']['lien_video'],
                });
              }
            }
          }
           print("listsvideo fetched in this loop iteration: $listsvideo");

          listsvideo.addAll(responseData.cast<Map<String, dynamic>>());
          currentPage++;
        } else {
          // If the server returns a 400 error, it might indicate data not found, so handle it gracefully
          if (response.statusCode == 400) {
            //   print('No more video found.');
            break;
          } else {
            // For other error responses, throw an exception
            throw Exception('Failed to load liste interventions: ${response.statusCode}');
          }
        }
      }

     // print("All interventions: $typeintervention");
      return listsvideo.isEmpty ? null : listsvideo;
    } catch (error) {
      print('Error fetching liste interventions: $error');
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


