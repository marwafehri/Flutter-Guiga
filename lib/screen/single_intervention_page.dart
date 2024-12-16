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

class SingleInterventionPage extends StatefulWidget {
  var postId;  // Order place to this customer
  final postTitle;

  SingleInterventionPage(this.postId, this.postTitle);
  @override
  _SingleInterventionPageState createState() => _SingleInterventionPageState();
}


class _SingleInterventionPageState extends State<SingleInterventionPage> {
  InterventionsBloc _postIntervention = InterventionsBloc();
  List<Map<String, dynamic>>? _interventionList;
  final FooterBloc _footerBloc = FooterBloc();
  final List<IconData> icons = [Icons.email, Icons.phone];
  void onIconTapped(int index) {
    print('Icon $index tapped');
  }

  @override

  void initState() {
    super.initState();
    _fetchPostIntervention(widget.postId);
  }

  Future<void> _fetchPostIntervention(int postId) async {
    try {
      // Fetch the single blog post using the postId
      Map<String, dynamic>? singleintervention = await _postIntervention.fetchSingleIntervention(postId);
      if (singleintervention != null) {
        // Set the fetched blog post to the _blogList
        setState(() {
          _interventionList = [singleintervention]; // Wrap the blog in a list for consistency with the ListView.builder
        });
      } else {
        // If the blog is null, show a message indicating no blog post found
        setState(() {
          _interventionList = null;
        });
      }
    } catch (error) {
      print('Error fetching post: $error');
      // Handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postTitle ?? "Interventions"),
        backgroundColor: Color(0xFFe8e0d7),
      ),
      floatingActionButton: MenuBarr(),
      bottomNavigationBar: BottomAppBarDemo(
        icons: icons,
        onIconTapped: onIconTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (_interventionList != null && _interventionList!.isNotEmpty) // Check if _blogList is not null and not empty
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 700),
               // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(), // Disables scrolling on the ListView
                    shrinkWrap: true,  // Makes ListView only occupy needed height
                    itemCount: _interventionList!.length,
                    itemBuilder: (context, index) {
                    // Extract blog details
                    Map<String, dynamic> intervention = _interventionList![index];
                    String content = intervention['content']['rendered'];

                    String date = intervention['date'];

                    return GestureDetector(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 700),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Html(
                                  data: processHtmlContent(content, 'breadcrumbs'),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                    );
                  },
                ),
              ),
            if (_interventionList == null || _interventionList!.isEmpty) // Check if _blogList is null or empty
              Center(child: CircularProgressIndicator()),
            _footerBloc.blocFooter(context),
          ],
        ),
      ),
    );
  }

  String removeHtmlElementsByClass(String htmlString, String className) {
    RegExp regExp = RegExp(
        '<div class="$className"[^>]*>.*?</div>',
        dotAll: true, // Allows . to match newlines
        caseSensitive: false
    );

    return htmlString.replaceAll(regExp, '');
  }
  String processHtmlContent(String htmlString, String className) {
    dom.Document document = htmlParser.parse(htmlString);

    // Remove elements by class name
    document.querySelectorAll('.$className').forEach((element) {
      element.remove();
    });

    // Add max-width to images
    document.querySelectorAll('img').forEach((dom.Element img) {
      String currentStyle = img.attributes['style'] ?? '';
      if (currentStyle.isNotEmpty && !currentStyle.trim().endsWith(';')) {
        currentStyle += '; ';
      }

      // Check if 'width' is not already specified
      if (!currentStyle.contains('width')) {
        currentStyle += 'width: 350px;';
      }

      // Ensure 'height' is set to 'auto' to maintain aspect ratio
      if (!currentStyle.contains('height')) {
        currentStyle += 'height: 200pv';
      }

      // Update the style attribute with the new styles
      img.attributes['style'] = currentStyle;
    });

    return document.outerHtml;
  }
}
