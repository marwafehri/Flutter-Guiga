import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:woocommerce_app/bloc/interventions_bloc.dart';
import 'package:woocommerce_app/screen/single_intervention_page.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final InterventionsBloc _interventionsBloc;
  bool _isLoading = true;
  List<Map<String, dynamic>> _interventionsList = [];

  CustomSearchDelegate(this._interventionsBloc) {
    _fetchInterventions();
  }

  Future<void> _fetchInterventions() async {
    try {
      List<Map<String, dynamic>>? interventions = await _interventionsBloc.fetchListeInterventions();
      _interventionsList = interventions ?? [];
      print("Search all interventions: $_interventionsList");
    } catch (error) {
      print('Error fetching interventions: $error');
    } finally {
      _isLoading = false;
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the search bar (e.g., clear button)
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context); // Refresh suggestions when cleared
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon (e.g., back button)
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Pass an empty string instead of null
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Display search results here (e.g., a list view)
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    List<Map<String, dynamic>> matchQuery = [];
    for (var intervention in _interventionsList) {
      if (intervention['title'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(intervention);
      }
    }

    if (matchQuery.isEmpty) {
      return Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result['title']),
         // subtitle: Text("Result details"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleInterventionPage(result['id'],result['name']),  // Ensure this constructor expects an ID
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Optional: Display suggestions as the user types
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    List<Map<String, dynamic>> matchQuery = [];
    for (var intervention in _interventionsList) {
      if (intervention['title'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(intervention);
      }
    }

    if (matchQuery.isEmpty) {
      return Center(child: Text('No suggestions'));
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result['title']),
        //  subtitle: Text("Suggestion details"),
          onTap: () {
            query = result['title'];
            showResults(context);
          },
        );
      },
    );
  }
}