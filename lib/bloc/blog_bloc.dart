import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:woocommerce_app/helper/ui_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class BlogBloc {

  List<Map<String, dynamic>>? listsblog;


  /* Future<List<Map<String, dynamic>>?> fetchListeBlogs({int perPage = 10}) async {
    try {
      final String urllistblog = 'https://www.drg.deveoo.net/wp-json/wp/v2/posts/';
      final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      List<Map<String, dynamic>> allBlogs = [];
      int currentPage = 1;

      while (true) {
        final http.Response response = await http.get(
          Uri.parse('$urllistblog?per_page=$perPage&page=$currentPage&_embed'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': basicAuthusers,
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);

          if (responseData.isEmpty) {
            // No more blog to fetch, exit the loop
            break;
          }

          allBlogs.addAll(responseData.cast<Map<String, dynamic>>());
          currentPage++;
        } else {
          // If the server returns a 400 error, it might indicate data not found, so handle it gracefully
          if (response.statusCode == 400) {
            print('No more blog found.');
            break;
          } else {
            // For other error responses, throw an exception
            throw Exception('Failed to load liste blog: ${response.statusCode}');
          }
        }
      }

      print("All blog: $allBlogs");
      return allBlogs.isEmpty ? null : allBlogs;
    } catch (error) {
      print('Error fetching liste blog: $error');
      throw error;
    }
  } */
  Future<List<Map<String, dynamic>>?> fetchListeBlogs({int perPage = 10}) async {
    try {
      final String urllistblog = 'https://www.drg.deveoo.net/wp-json/wp/v2/posts/';
      final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      List<Map<String, dynamic>> allBlogs = [];
      int currentPage = 1;

      while (true) {
        final http.Response response = await http.get(
          Uri.parse('$urllistblog?per_page=$perPage&page=$currentPage&_embed'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': basicAuthusers,
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);

          if (responseData.isEmpty) {
            // No more blogs to fetch, exit the loop
            break;
          }

          // Extract desired fields from each blog and add them to the list
          for (var blog in responseData) {
            if (blog is Map<String, dynamic>) {
              final featuredMedia = blog['_embedded']['wp:featuredmedia'][0];
              allBlogs.add({
                'id': blog['id'],
                'title': blog['title']['rendered'],
                'date': blog['date'],
                'excerpt': blog['excerpt']['rendered'],
                'featuredMediaUrl': featuredMedia != null ? featuredMedia['source_url'] : null,
              });
            }
          }
          currentPage++;
        } else {
          // If the server returns a 400 error, it might indicate data not found, so handle it gracefully
          if (response.statusCode == 400) {
            print('No more blogs found.');
            break;
          } else {
            // For other error responses, throw an exception
            throw Exception('Failed to load liste blog: ${response.statusCode}');
          }
        }
      }

      print("All blogs: $allBlogs");
      return allBlogs.isEmpty ? null : allBlogs;
    } catch (error) {
      print('Error fetching liste blog: $error');
      throw error;
    }
  }
  Future<Map<String, dynamic>?> fetchSingleBlog(int postId) async {
    try {
      final String url = 'https://www.drg.deveoo.net/wp-json/wp/v2/posts/$postId';
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
        throw Exception('Failed to load data post');
      }
    } catch (error) {
      print('Error fetching post: $error');
      throw error;
    }
  }


  void showDefaultSnackbar(final _scaffoldKey) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text('Please! At least add one blog'),
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
