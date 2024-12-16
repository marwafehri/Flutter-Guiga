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

         // print(responseData[0]);
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

     // print("All interventions: $typeintervention");
      return typeintervention.isEmpty ? null : typeintervention;
    } catch (error) {
      print('Error fetching liste interventions: $error');
      throw error;
    }
  }
  /*
  Future<List<Map<String, dynamic>>?> fetchCategory() async {
    try {
      final String urllistcategory = 'https://www.drg.deveoo.net/wp-json/wp/v2/type-d-intervention/';
      final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      List<Map<String, dynamic>> typecategory = [];

      final http.Response response = await http.get(
        Uri.parse(urllistcategory),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuthusers,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        if (responseData.isEmpty) {
          print("No more data to fetch.");
        } else {
          // Process the categories only if data is not empty
          for (var category in responseData) {
            if (category is Map<String, dynamic>) {
              typecategory.add({
                'id': category['id'],
                'name': category['name'],
                'description': category['description'],
              });
            }
          }
        }

        // print("Categories fetched in this loop iteration: $typecategory");
      } else {
        // Handle server error responses
        if (response.statusCode == 400) {
          print('No more categories found.');
        } else {
          // For other error responses, throw an exception
          throw Exception('Failed to load categories: ${response.statusCode}');
        }
      }

      // Ensure this print is reached
       print("Final categories: $typecategory");

      return typecategory.isEmpty ? null : typecategory;
    } catch (error) {
      print('Error fetching categories: $error');
      throw error;
    }
  }
*/
 /* Future<List<Map<String, dynamic>>?> fetchCategory() async {
    try {
      final String urllistcategory = 'https://www.drg.deveoo.net/wp-json/wp/v2/type-d-intervention/';
      final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      List<Map<String, dynamic>> typecategory = [];

      final http.Response response = await http.get(
        Uri.parse(urllistcategory),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuthusers,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        if (responseData.isEmpty) {
          print("No more data to fetch.");
        } else {
          // Process the categories only if data is not empty
          for (var category in responseData) {
            if (category is Map<String, dynamic>) {
              // Add parent category
              Map<String, dynamic> categoryData = {
                'id': category['id'],
                'name': category['name'],
                'description': category['description'],
                'parent': category['parent'] ?? null, // Include parent ID if available
                'child_categories': [], // Placeholder for child categories
              };
              typecategory.add(categoryData);
            }
          }
        }
      } else {
        // Handle server error responses
        if (response.statusCode == 400) {
          print('No more categories found.');
        } else {
          throw Exception('Failed to load categories: ${response.statusCode}');
        }
      }

      // After fetching parent categories, fetch child categories
      for (var category in typecategory) {
        int parentId = category['id'];
        List<Map<String, dynamic>> childCategories = await fetchChildCategoriesForCategory(parentId);
        category['child_categories'] = childCategories; // Add child categories to the parent category
     }
print('typecategory $typecategory');
      return typecategory.isEmpty ? null : typecategory;
    } catch (error) {
      print('Error fetching categories: $error');
      throw error;
    }
  }*/


  Future<List<Map<String, dynamic>>?> fetchCategory({int perPage = 20}) async {
    try {
      final String urllistcategory = 'https://www.drg.deveoo.net/wp-json/wp/v2/type-d-intervention/';
      final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      List<Map<String, dynamic>> typecategory = [];
      Map<int, Map<String, dynamic>> categoriesByParent = {}; // Map to group categories by parent ID
      int currentPage = 1;
      bool hasMoreData = true;

      while (hasMoreData) {
        final http.Response response = await http.get(
          Uri.parse('$urllistcategory?per_page=$perPage&page=$currentPage'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': basicAuthusers,
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);

          if (responseData.isEmpty) {
            print("No more data to fetch.");
            hasMoreData = false; // Stop fetching when no more data
          } else {
            // Process the categories and group them by parent ID
            for (var category in responseData) {
              if (category is Map<String, dynamic>) {
                int parentId = category['parent'] ?? 0; // If parent is null, set it to 0 (or some default value)

                // Fetch the parent category name if necessary
                String parentName = '';
                if (parentId != 0) {
                  final String urlparentcategory = 'https://www.drg.deveoo.net/wp-json/wp/v2/type-d-intervention/$parentId';
                  final http.Response responseparent = await http.get(
                    Uri.parse(urlparentcategory),
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                      'Authorization': basicAuthusers,
                    },
                  );

                  if (responseparent.statusCode == 200) {
                    final parentCategoryData = json.decode(responseparent.body);
                    parentName = parentCategoryData['name'] ?? '';
                  } else {
                    print('Failed to fetch parent category: ${responseparent.statusCode}');
                  }
                }

                // Group the category by parentId
                if (!categoriesByParent.containsKey(parentId)) {
                  categoriesByParent[parentId] = {
                    'parent': parentId,
                    'parent_name': parentName, // Store the parent name here
                    'child_categories': [],
                  };
                }

                // Add the current category as a child of its parent
                categoriesByParent[parentId]!['child_categories'].add({
                  'id': category['id'],
                  'name': category['name'],
                  'description': category['description'],
                });
              }
            }

            // Increment currentPage to fetch next set of categories
            currentPage++;
          }
        } else {
          // Handle server error responses
          if (response.statusCode == 400) {
            print('No more categories found.');
            hasMoreData = false;
          } else {
            throw Exception('Failed to load categories: ${response.statusCode}');
          }
        }
      }

      // Convert the map to a list of categories
      typecategory = categoriesByParent.values.toList();
      return typecategory.isEmpty ? null : typecategory;
    } catch (error) {
      print('Error fetching categories: $error');
      throw error;
    }
  }
/*
  Future<List<Map<String, dynamic>>?> fetchCategoriesWithInterventions({int perPage = 10}) async {
    try {
      final String urllistcategory = 'https://www.drg.deveoo.net/wp-json/wp/v2/type-d-intervention/';
      final String urlInterventions = 'https://www.drg.deveoo.net/wp-json/wp/v2/liste-d-intervention';
      final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      List<Map<String, dynamic>> categorizedInterventions = [];
      Map<int, Map<String, dynamic>> categoriesByParent = {};
      int currentPage = 1;

      // Fetch all categories
      final http.Response categoryResponse = await http.get(
        Uri.parse(urllistcategory),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuthusers,
        },
      );

      if (categoryResponse.statusCode == 200) {
        final List<dynamic> categoryData = json.decode(categoryResponse.body);

        // Store categories by parent ID
        for (var category in categoryData) {
          if (category is Map<String, dynamic>) {
            int parentId = category['parent'] ?? 0;

            if (!categoriesByParent.containsKey(parentId)) {
              categoriesByParent[parentId] = {
                'parent_id': parentId,
                'child_categories': [],
              };
            }

            categoriesByParent[parentId]!['child_categories'].add({
              'id': category['id'],
              'name': category['name'],
            });
          }
        }
        print("Categories by Parent:");
        print(categoriesByParent);
      } else {
        throw Exception('Failed to fetch categories: ${categoryResponse.statusCode}');
      }

      // Fetch interventions with pagination
      bool hasMorePages = true;

      while (hasMorePages) {
        final http.Response interventionResponse = await http.get(
          Uri.parse('$urlInterventions?per_page=$perPage&page=$currentPage'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': basicAuthusers,
          },
        );

        if (interventionResponse.statusCode == 200) {
          final List<dynamic> interventionData = json.decode(interventionResponse.body);

          if (interventionData.isEmpty) {
            hasMorePages = false; // Stop if no more interventions
          } else {
            // Fetch interventions
            for (var intervention in interventionData) {
              if (intervention is Map<String, dynamic>) {
                List<int> categoryIds = List<int>.from(intervention['type-d-intervention'] ?? []);
                int parentCategoryId = 0;

                // Determine the parent category ID for the intervention
                for (int id in categoryIds) {
                  if (categoriesByParent.containsKey(id)) {
                    parentCategoryId = id;
                    break;
                  }
                }

                // Identify child IDs
                List<int> childIds = categoryIds.where((id) => id != parentCategoryId).toList();

                // Collect child data
                List<Map<String, dynamic>> childData = [];
                for (int childId in childIds) {
                  final String urlListChild = 'https://www.drg.deveoo.net/wp-json/wp/v2/type-d-intervention/$childId';

                  final http.Response childResponse = await http.get(
                    Uri.parse(urlListChild),
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                      'Authorization': basicAuthusers,
                    },
                  );

                  if (childResponse.statusCode == 200) {
                    final Map<String, dynamic> child = json.decode(childResponse.body);
                    childData.add({
                      'id': child['id'],
                      'name': child['name'],
                    });
                  } else {
                    print('Failed to fetch child category: ${childResponse.statusCode}');
                  }
                }

                // Add intervention with child categories and parent
                categorizedInterventions.add({
                  'id': intervention['id'],
                  'title': intervention['title']['rendered'],
                  'child_category': childData, // Ensures desired structure
                  'parent_category_id': parentCategoryId,
                });
              }
            }

            currentPage++;
          }
        } else {
          throw Exception('Failed to fetch interventions: ${interventionResponse.statusCode}');
        }
      }

      return categorizedInterventions.isEmpty ? null : categorizedInterventions;
    } catch (error) {
      print('Error fetching categories or interventions: $error');
      throw error;
    }
  }*/

  Future<List<Map<String, dynamic>>?> fetchCategoriesWithInterventions({int perPage = 50}) async {
    try {
      final String urllistcategory = 'https://www.drg.deveoo.net/wp-json/wp/v2/type-d-intervention/';
      final String urlInterventions = 'https://www.drg.deveoo.net/wp-json/wp/v2/liste-d-intervention';
      final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';
      int currentPage = 1;

      List<Map<String, dynamic>> categorizedInterventions = [];
      Map<int, Map<String, dynamic>> categoriesByParent = {};

      // Fetch all categories
      final http.Response categoryResponse = await http.get(
        Uri.parse(urllistcategory),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuthusers,
        },
      );

      if (categoryResponse.statusCode == 200) {
        final List<dynamic> categoryData = json.decode(categoryResponse.body);

        // Store categories by parent ID
        for (var category in categoryData) {
          if (category is Map<String, dynamic>) {
            int parentId = category['parent'] ?? 0;

            if (!categoriesByParent.containsKey(parentId)) {
              categoriesByParent[parentId] = {
                'parent_id': parentId,
                'child_categories': [],
              };
            }

            categoriesByParent[parentId]!['child_categories'].add({
              'id': category['id'],
              'name': category['name'],
            });
          }
        }
        print("Categories by Parent:");
        print(categoriesByParent); // Vérification des catégories par parent
      } else {
        throw Exception('Failed to fetch categories: ${categoryResponse.statusCode}');
      }

      // Fetch interventions
      final http.Response interventionResponse = await http.get(
        Uri.parse('$urlInterventions?per_page=$perPage&page=$currentPage'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuthusers,
        },
      );

      if (interventionResponse.statusCode == 200) {
        final List<dynamic> interventionData = json.decode(interventionResponse.body);

        for (var intervention in interventionData) {
          if (intervention is Map<String, dynamic>) {
            List<int> categoryIds = List<int>.from(intervention['type-d-intervention'] ?? []);
            int parentCategoryId = 0;

            // Determine the parent category ID for the intervention
            for (int id in categoryIds) {
              if (categoriesByParent.containsKey(id)) {
                parentCategoryId = id;
                break;
              }
            }

           // print("Intervention categories:");
           // print(categoryIds); // Affichage des IDs des catégories associées à l'intervention

            // Identifie les IDs enfants
            List<int> childIds = categoryIds.where((id) => id != parentCategoryId).toList();

            // Récupère les données des enfants
            List<Map<String, dynamic>> childData = [];
            for (int childId in childIds) {
              final String urlListChild = 'https://www.drg.deveoo.net/wp-json/wp/v2/type-d-intervention/$childId';
              final http.Response childResponse = await http.get(
                Uri.parse(urlListChild),
                headers: <String, String>{
                  'Content-Type': 'application/json',
                  'Authorization': basicAuthusers,
                },
              );

              if (childResponse.statusCode == 200) {
                final Map<String, dynamic> child = json.decode(childResponse.body);
                childData.add({
                  'id': child['id'],
                  'name': child['name'],
                });
              } else {
                print('Failed to fetch child category: ${childResponse.statusCode}');
              }
            }
            String limitExcerpt(String excerpt) {
              // Split the excerpt into words
              List<String> words = excerpt.split(' ');

              // Take the first 20 words
              if (words.length > 20) {
                words = words.sublist(0, 20);
              }

              // Join the words back into a string
              return words.join(' ') + (words.length == 20 ? '...' : '');
            }

            // Ajouter l'intervention avec les catégories enfants et le parent
            categorizedInterventions.add({
              'id': intervention['id'],
              'title': intervention['title']['rendered'],
              'excerpt': limitExcerpt(intervention['excerpt']['rendered']),
              'child_category': childData, // Liste des catégories enfants avec noms et IDs
              'parent_category_id': parentCategoryId,
            });
          }
        }
       // print("Intervention Data:");
       // print(interventionData); // Vérification des données des interventions
        currentPage++;
      } else {
        throw Exception('Failed to fetch interventions: ${interventionResponse.statusCode}');
      }

      return categorizedInterventions.isEmpty ? null : categorizedInterventions;
    } catch (error) {
      print('Error fetching categories or interventions: $error');
      throw error;
    }
  }





  /*
  Future<List<Map<String, dynamic>>?> fetchCategoryWithInterventions() async {
    try {
      final String urllistcategory =
          'https://www.drg.deveoo.net/wp-json/wp/v2/type-d-intervention/';
      final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      List<Map<String, dynamic>> typecategory = [];
      Map<int, Map<String, dynamic>> categoriesByParent = {}; // Map to group categories by parent ID

      final http.Response response = await http.get(
        Uri.parse(urllistcategory),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuthusers,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        if (responseData.isEmpty) {
          print("No more data to fetch.");
        } else {
          // Process the categories and group them by parent ID
          for (var category in responseData) {
            if (category is Map<String, dynamic>) {
              int parentId = category['parent'] ?? 0; // Default to 0 if parent is null

              // Fetch the parent category name if necessary
              String parentName = '';
              if (parentId != 0) {
                final String urlparentcategory =
                    'https://www.drg.deveoo.net/wp-json/wp/v2/type-d-intervention/$parentId';
                final http.Response responseparent = await http.get(
                  Uri.parse(urlparentcategory),
                  headers: <String, String>{
                    'Content-Type': 'application/json',
                    'Authorization': basicAuthusers,
                  },
                );

                if (responseparent.statusCode == 200) {
                  final parentCategoryData = json.decode(responseparent.body);
                  parentName = parentCategoryData['name'] ?? '';
                } else {
                  print('Failed to fetch parent category: ${responseparent.statusCode}');
                }
              }

              // Group the category by parentId
              if (!categoriesByParent.containsKey(parentId)) {
                categoriesByParent[parentId] = {
                  'parent': parentId,
                  'parent_name': parentName, // Store the parent name here
                  'child_categories': [],
                };
              }

              // Fetch interventions for this category
              final List<dynamic> interventions =
              await fetchInterventionsByCategory(category['id'], basicAuthusers);

              // Add the current category as a child of its parent
              categoriesByParent[parentId]!['child_categories'].add({
                'id': category['id'],
                'name': category['name'],
                'interventions': interventions, // Attach the fetched interventions here
              });
            }
          }
        }

        // Convert the map to a list of categories
        typecategory = categoriesByParent.values.toList();
      } else {
        // Handle server error responses
        if (response.statusCode == 400) {
          print('No more categories found.');
        } else {
          throw Exception('Failed to load categories: ${response.statusCode}');
        }
      }

      print('typecategory $typecategory');
      return typecategory.isEmpty ? null : typecategory;
    } catch (error) {
      print('Error fetching categories: $error');
      throw error;
    }
  }*/

  //Future<List<Map<String, dynamic>>?> fetchInterventionsByCategory() async {


  Future<List<dynamic>> fetchInterventionsByCategory(
      int categoryId, String basicAuthusers) async {
    try {
      final String urlInterventions =
          'https://www.drg.deveoo.net/wp-json/wp/v2/interventions/?category=$categoryId';
      final http.Response response = await http.get(
        Uri.parse(urlInterventions),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuthusers,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> interventions = json.decode(response.body);
        return interventions;
      } else {
        print('Failed to fetch interventions for category $categoryId: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error fetching interventions for category $categoryId: $error');
      return [];
    }
  }
    /*
  Future<List<Map<String, dynamic>>> fetchChildCategoriesForCategory(int parentId) async {
    try {
      final String urllistcategory = 'https://www.drg.deveoo.net/wp-json/wp/v2/type-d-intervention/';
      final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      List<Map<String, dynamic>> childCategories = [];

      final http.Response response = await http.get(
        Uri.parse('$urllistcategory?parent=$parentId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuthusers,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        if (responseData.isNotEmpty) {
          for (var category in responseData) {
            if (category is Map<String, dynamic>) {
              childCategories.add({
                'id': category['id'],
                'name': category['name'],
              });
            }
          }
        }
      } else {
        throw Exception('Failed to load child categories for parent ID $parentId');
      }

      return childCategories;
    } catch (error) {
      print('Error fetching child categories: $error');
      return [];
    }
  }*/
/*
  Future<Map<String, dynamic>> fetchInterventionsForCategory(int categoryId) async {

    try {
      final String urllistintervention = 'https://www.drg.deveoo.net/wp-json/wp/v2/intervention-client/';
      final String basicAuthusers = 'Basic ZHJnX2RldmVvbzomOUJralQjSmFC';

      List<Map<String, dynamic>> interventions = [];
      int currentPage = 1;

      while (true) {
        var response = await http.get(
          Uri.parse('$urllistintervention?category=$categoryId&page=$currentPage'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': basicAuthusers,
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);

          if (responseData.isEmpty) {
            print("No more data to fetch.");
          } else {
            // Process the categories only if data is not empty
            for (var interventioncategory in responseData) {
              if (interventioncategory is Map<String, dynamic>) {
                interventions.add({
                  'id': interventioncategory['id'],
                  'title': interventioncategory['title']['rendered'],
                });
              }
            }
          }

          interventions.addAll(responseData.cast<Map<String, dynamic>>());

        } else {
          if (response.statusCode == 400) {
            break; // No more interventions for this category
          } else {
            throw Exception('Failed to load list of interventions for category: ${response.statusCode}');
          }
        }
      }
print('categoryId $categoryId interventions $interventions');
      return {'categoryId': categoryId, 'interventions': interventions};
    } catch (error) {
      print('Error fetching interventions for category: $error');
      throw error;
    }
  }*/
    /* Future<Map<String, dynamic>> fetchCategoriesAndInterventions() async {
    print("fetchCategoriesAndInterventions1");
    try {
      print("fetchCategoriesAndInterventions2");
      InterventionsBloc bloc = InterventionsBloc();
      List<Map<String, dynamic>>? categories = await bloc.fetchCategory();
      //print("Categories with interventions: $categories");
      if (categories != null && categories.isNotEmpty) {
        print("fetchCategoriesAndInterventions3");
        for (var category in categories) {
          int categoryId = category['id'];
          print('Fetching interventions for category ID: $categoryId');
          Map<String, dynamic> categoryInterventions =
          await bloc.fetchInterventionsForCategory(categoryId);
          category['interventions'] = categoryInterventions['interventions'];
        }
        print("Categories with interventions: $categories");
        return {'categories': categories};
      } else {
        print("No categories found.");
        return {'categories': []}; // Return an empty map when no categories are found
      }
    } catch (error) {
      print('Error fetching categories and interventions: $error');
      return {'error': error.toString(), 'categories': []}; // Return an error response
    }
  }*/

    //Future<Map<String, dynamic>> fetchCategoriesAndInterventions(int categoryId) async {
    /*Future<void> fetchCategoriesAndInterventions() async {
    try {
      // Fetch categories
      List<Map<String, dynamic>>? categories = await fetchCategory();

      if (categories != null && categories.isNotEmpty) {
        // For each category, fetch the interventions
        for (var category in categories) {
          int categoryId = category['id'];
          print('Fetching interventions for category ID: $categoryId');

          // Fetch interventions for the category
          Map<String, dynamic> categoryInterventions = await fetchInterventionsForCategory(categoryId);

          // Combine category info with its interventions
          category['interventions'] = categoryInterventions['interventions'];
        }
        // At this point, all categories will have their interventions
        print("Categories with interventions: $categories");
      } else {
        print("No categories found.");
      }
    } catch (error) {
      print('Error fetching categories and interventions: $error');
    }
  }*/
    // static Future<void> fetchCategoriesAndInterventions() async {


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
        // print(response);
        // print("addInterventions");

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

        //print("All interventions: $allInterventions");
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


