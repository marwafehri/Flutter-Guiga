import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/cupertino.dart';
import 'package:woocommerce_app/bloc/interventions_bloc.dart';
import 'package:html/parser.dart' as htmlParser;  // Provides HTML parsing capabilities
import 'package:html/dom.dart' as dom;
import 'package:woocommerce_app/bloc/footer_bloc.dart';
import 'package:woocommerce_app/bloc/menu_bar.dart';
import 'package:woocommerce_app/bloc/bottom_app_bar.dart';
import 'package:woocommerce_app/screen/single_intervention_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class SingleCategoryPage extends StatefulWidget {
  final int categoryId;
  final categoryName;

  // Constructor receives the category ID
  SingleCategoryPage(this.categoryId, this.categoryName);

  @override
  _SingleCategoryPageState createState() => _SingleCategoryPageState();
}

class _SingleCategoryPageState extends State<SingleCategoryPage> {
  List<Map<String, dynamic>> _interventions = []; // Store interventions
  bool _isLoading = true; // Show loading state

  String _errorMessage = ''; // Store error message
  final FooterBloc _footerBloc = FooterBloc();
  final List<IconData> icons = [Icons.email, Icons.phone];
  void onIconTapped(int index) {
    print('Icon $index tapped');
  }
  InterventionsBloc _interventionsBloc = InterventionsBloc();
  List<Map<String, dynamic>>? _categoryinterventionList; // List of all category interventions

  // Fetch interventions filtered by categoryId and child category ID
  Future<void> _fetchInterventionsByCategoryy() async {
    List<Map<String, dynamic>> allCategoryinterventions = [];

    try {
      // Fetch all interventions from the bloc
      List<Map<String, dynamic>>? interventions = await _interventionsBloc.fetchCategoriesWithInterventions();

      allCategoryinterventions.addAll(interventions as Iterable<Map<String, dynamic>>);

      print("All interventions fetched: $allCategoryinterventions");

      // Filter interventions based on categoryId and its child category ID
      List<Map<String, dynamic>> filteredInterventions = [];
      for (var category in allCategoryinterventions) {
        // Check if the category's child categories contain the given categoryId
        final childCategories = category['child_category'] ?? [];
        for (var childCategory in childCategories) {
          if (childCategory['id'] == widget.categoryId) {
            filteredInterventions.add({
              'id': category['id'],
              'title': category['title'],
            });
          }
        }
      }

      setState(() {
        _categoryinterventionList = filteredInterventions;
        _isLoading = false; // Hide loading indicator
      });
    } catch (error) {
      print('Error fetching interventions: $error');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching interventions';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchInterventionsByCategoryy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName ?? "Interventions"),
        backgroundColor: Color(0xFFe8e0d7),
      ),
      floatingActionButton: MenuBarr(),
      bottomNavigationBar: BottomAppBarDemo(
        icons: [Icons.email, Icons.phone],
        onIconTapped: (index) => print('Icon $index tapped'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _categoryinterventionList == null || _categoryinterventionList!.isEmpty
          ? Center(child: Text('No interventions found for this category.'))
          : ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10),
        itemCount: (_categoryinterventionList!.length / 2).ceil(), // Two items per row
        itemBuilder: (context, index) {
          final int firstIndex = index * 2; // First item in the row
          final int secondIndex = firstIndex + 1; // Second item in the row
         Map<String, List<Map<String, dynamic>>> groupedInterventions = {};
          _categoryinterventionList!.forEach((intervention) {
            List<dynamic> interventionTypes = getInterventionType(intervention);

              String key = interventionTypes.join('-');
              if (!groupedInterventions.containsKey(key)) {
                groupedInterventions[key] = [];
              }
              groupedInterventions[key]!.add(intervention);

          });
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                // First column
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleInterventionPage(
                              _categoryinterventionList![firstIndex]['id'],
                              _categoryinterventionList![firstIndex]['title'],
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 190,
                        child: Card(
                          color: Color(0xFFe8e0d7),
                          child: Center(
                            child: SingleChildScrollView( // Allows scrolling if content overflows
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 25),
                                  /*Icon(
                                  Icons.area_chart_outlined,
                                  color: Color(0xFFD3546E),
                                  size: 40,
                                ),*/

                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 40.0,
                                    child: Builder(
                                      builder: (context) {
                                        // Get the intervention from the second index
                                        String key = groupedInterventions.keys.elementAt(firstIndex);
                                        print("key 1");

                                        print(key);
                                        List<Map<String, dynamic>> interventions = groupedInterventions[key]!;
                                        List<int> types = key.split('-').map((type) => int.parse(type)).toList();

                                        print(types[0]);

                                        // Pass the first type to get the corresponding image
                                        return getImageForInterventionType(types[0]);
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    _categoryinterventionList![firstIndex]['title'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Second column
                if (secondIndex < _categoryinterventionList!.length) // Ensure it exists
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 15),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleInterventionPage(
                                _categoryinterventionList![secondIndex]['id'],
                                _categoryinterventionList![secondIndex]['title'],
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 190,
                          child: Card(
                            color: Color(0xFFe8e0d7),
                            child: Center(
                            child: SingleChildScrollView( // Allows scrolling if content overflows
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 25),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 40.0,
                                    child: Builder(
                                      builder: (context) {
                                        // Get the intervention from the second index
                                        String key = groupedInterventions.keys.elementAt(secondIndex);
                                        print("key 2");

                                        print(key);
                                        List<Map<String, dynamic>> interventions = groupedInterventions[key]!;
                                        List<int> types = key.split('-').map((type) => int.parse(type)).toList();

                                        print(types[0]);

                                        // Pass the first type to get the corresponding image
                                        return getImageForInterventionType(types[0]);
                                      },
                                    ),
                                  ),


                                  SizedBox(height: 10),
                                  Text(
                                    _categoryinterventionList![secondIndex]['title'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                ],
                              ),
                              ),
                            ),
                          ),
                          ),
                      ),
                    ),
                  )
                else
                  Expanded(child: Container()), // Placeholder for alignment
              ],
            ),
          );
        },
      ),
    );
  }
  List<dynamic> getInterventionType(Map<String, dynamic> intervention) {
    // Print the entire intervention map to understand its structure

    var types = intervention['type-d-intervention'];

    // If 'type-d-intervention' is not a list, return it as a single-element list
    if (types != null && types is List) {
      return types;
    } else {
      // If 'type-d-intervention' is not available, return 'id' as a list
      var id = intervention['id'];
      return [id]; // Wrap 'id' in a list
    }
  }

  Widget getImageForInterventionType(int types) {
    switch (types) {
      case 5325:
        return Expanded(
          child: Image.asset('images/abdominoplastie.png', fit: BoxFit.cover),
        );
      case 5349:
        return Expanded(
          child: Image.asset('images/BBL.png', fit: BoxFit.fitWidth),
        );
      case 5419:
        return Expanded(
          child: Image.asset('images/Lipofilling-des-fesses.png', fit: BoxFit.cover),
        );
      case 5299:
        return Expanded(
          child: Image.asset('images/Lipofilling-des-fesses.png', fit: BoxFit.cover),
        );
      case 5141:
        return Expanded(
          child: Image.asset('images/Liposuccion.png', fit: BoxFit.cover),
        );
      case 5263:
        return Expanded(
          child: Image.asset('images/Mesotherapie.png', fit: BoxFit.cover),
        );
      case 5437:
        return Expanded(
          child: Image.asset('images/PRP.png', fit: BoxFit.cover),
        );
      case 5045:
        return Expanded(
          child: Image.asset('images/reconstruction-seins.png', fit: BoxFit.cover),
        );
      case 5040:
        return Expanded(
          child: Image.asset('images/mamelon-ombilique.png', fit: BoxFit.cover),
        );
      case 5035:
        return Expanded(
          child: Image.asset('images/lifting-des-seins-avec-ou-sans-protheses.png', fit: BoxFit.cover),
        );
      case 4819:
        return Expanded(
          child: Image.asset('images/augmentation-par-prothese.png', fit: BoxFit.cover),
        );
      case 4943:
        return Expanded(
          child: Image.asset('images/reduction-mammaire.png', fit: BoxFit.cover),
        );
      case 5477:
        return Expanded(
          child: Image.asset('images/Blepharoplastie.png', fit: BoxFit.cover),
        );
      case 5129:
        return Expanded(
          child: Image.asset('images/body-lift.png', fit: BoxFit.cover),
        );
      case 5442:
        return Expanded(
          child: Image.asset('images/Chirurgie-de-la-calvitie.png', fit: BoxFit.cover),
        );
      case 5459:
        return Expanded(
          child: Image.asset('images/Chirurgie_maxillaires.png', fit: BoxFit.cover),
        );
      case 5464:
        return Expanded(
          child: Image.asset('images/mentoplasty.png', fit: BoxFit.cover),
        );
      case 5448:
        return Expanded(
          child: Image.asset('images/Les_fentes_labio-palatines.png', fit: BoxFit.cover),
        );
      case 5115:
        return Expanded(
          child: Image.asset('images/Lifting-bras.png', fit: BoxFit.cover),
        );
      case 5110:
        return Expanded(
          child: Image.asset('images/Lifting_cuisses.png', fit: BoxFit.cover),
        );
      case 5121:
        return Expanded(
          child: Image.asset('images/Lifting_dos.png', fit: BoxFit.cover),
        );
      case 5104:
        return Expanded(
          child: Image.asset('images/Lifting-fesses.png', fit: BoxFit.cover),
        );
      case 5492:
        return Expanded(
          child: Image.asset('images/lifting-visage.png', fit: BoxFit.cover),
        );
      case 5487:
        return Expanded(
          child: Image.asset('images/Lipofilling-visage.png', fit: BoxFit.cover),
        );
      case 5098:
        return Expanded(
          child: Image.asset('images/Nymphoplastie.png', fit: BoxFit.cover),
        );
      case 5472:
        return Expanded(
          child: Image.asset('images/otoplasty.png', fit: BoxFit.cover),
        );
      case 5082:
        return Expanded(
          child: Image.asset('images/Penoplastie.png', fit: BoxFit.cover),
        );
      case 5135:
        return Expanded(
          child: Image.asset('images/Protheses-fessiers.png', fit: BoxFit.cover),
        );
      case 5093:
        return Expanded(
          child: Image.asset('images/Reconstruction-de-lhymen.png', fit: BoxFit.cover),
        );
      case 5482:
        return Expanded(
          child: Image.asset('images/Rhinoplastie.png', fit: BoxFit.cover),
        );
      case 5088:
        return Expanded(
          child: Image.asset('images/Vaginoplastie.png', fit: BoxFit.cover),
        );

        default:
          return Expanded(
            child: Image.asset('images/interventions.png', fit: BoxFit.cover),
          ); // Aucun type correspondant
    }
  }
}