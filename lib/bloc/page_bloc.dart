import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:woocommerce_app/helper/ui_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PageBloc {

  List<Map<String, dynamic>>? listspage;


  Future<Map<String, dynamic>?> fetchSinglePage(int pageId) async {
    try {
      final String url = 'https://www.drg.deveoo.net/wp-json/wp/v2/pages/$pageId';
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
        throw Exception('Failed to load data page');
      }
    } catch (error) {
      print('Error fetching page: $error');
      throw error;
    }
  }


  void showDefaultSnackbar(final _scaffoldKey) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text('Please! At least add one page'),
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
