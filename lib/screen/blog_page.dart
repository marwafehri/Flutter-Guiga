import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce_app/bloc/blog_bloc.dart';
import 'package:woocommerce_app/bloc/footer_bloc.dart';
import 'package:woocommerce_app/screen/single_blog_page.dart';
import 'package:woocommerce_app/bloc/menu_bar.dart';
import 'package:woocommerce_app/bloc/bottom_app_bar.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}


class _BlogPageState extends State<BlogPage> {

  BlogBloc _blogBloc = BlogBloc();
  List<Map<String, dynamic>>? _blogList;
  final FooterBloc _footerBloc = FooterBloc();

  final List<IconData> icons = [Icons.email, Icons.phone];
  void onIconTapped(int index) {
    print('Icon $index tapped');
  }
  var bloc;

  @override

  void initState() {
    super.initState();
    _fetchBlog();
  }


  Future<void> _fetchBlog() async {
    List<Map<String, dynamic>> allBlogs = [];

    try {
      // Fetch all interventions from the bloc
      List<Map<String, dynamic>>? blogs = await _blogBloc.fetchListeBlogs();

      allBlogs.addAll(blogs as Iterable<Map<String, dynamic>>);

      print("All blog home page: $allBlogs");

      setState(() {
        _blogList = allBlogs;
      });
    } catch (error) {
      print('Error fetching blog: $error');
      // Handle the error
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog'),
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
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 700),
               // color: Color(0xFFffffff),
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        // Your content for the first container
                        Container(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                          child: Column(
                            children: [
                              _buildBlog(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
              _footerBloc.blocFooter(context),
            ],
          ),
      ),
    );
  }

  Widget _buildBlog() {
    if (_blogList == null) {
      // Show a loading indicator while fetching data
      return Center(child: CircularProgressIndicator());
    } else if (_blogList!.isEmpty) {
      // Show a message if the list is empty
      return Center(child: Text('No blog found.'));
    } else {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(), // Disables scrolling on the ListView
            shrinkWrap: true,  // Makes ListView only occupy needed height
            itemCount: _blogList!.length,
            itemBuilder: (context, index) {
            // Extract blog details
            Map<String, dynamic> blog = _blogList![index];
           // String titleHtml = blog['title']['rendered'];
            String titleHtml = blog['title'];
            String title = _stripHtmlAndSpecialChars(titleHtml);
           // String excerptHtml = blog['excerpt']['rendered'];
            String excerptHtml = blog['excerpt'];
            String excerpt = _stripHtmlAndSpecialChars(excerptHtml);
            String date = blog['date'];
            int postId = blog['id'];
            // Extract image URL
           // String imageUrl = '';
            String imageUrl = '';
           /* if (blog.containsKey('_embedded') &&
                blog['_embedded'] != null &&
                blog['_embedded'].containsKey('wp:featuredmedia') &&
                blog['_embedded']['wp:featuredmedia'] != null &&
                blog['_embedded']['wp:featuredmedia'] is List &&
                blog['_embedded']['wp:featuredmedia'].isNotEmpty &&
                blog['_embedded']['wp:featuredmedia'][0] != null &&
                blog['_embedded']['wp:featuredmedia'][0].containsKey('source_url')) */
            if(blog['featuredMediaUrl'] != null){
              imageUrl =  blog['featuredMediaUrl'];
            } else {
              imageUrl = "https://www.drg.deveoo.net/wp-content/uploads/2024/03/Les-Tendances-en-Chirurgie_Esthetique-150x150.jpg";
            }

            return GestureDetector(
                onTap: () {
                  // Navigate to SingleBlogPage passing the postId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleBlogPage(postId),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl.isNotEmpty)
                      Image.network(
                        imageUrl,
                        width: MediaQuery.of(context).size.width,
                        height: 200, // Adjust height as needed
                        fit: BoxFit.cover,
                      ),
                    SizedBox(height: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Blog excerpt
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        excerpt,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // Blog date
                    Text(
                      'Date: $date',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(), // Add a divider between blogs
                  ],
                ),
            );
          },
      );
    }
  }
  String _stripHtmlAndSpecialChars(String htmlString) {
    // Remove HTML tags
    RegExp htmlExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    String strippedString = htmlString.replaceAll(htmlExp, '');

    // Remove special characters and non-alphanumeric characters
    RegExp specialCharsExp = RegExp(r'[^\w\s]', multiLine: true, caseSensitive: true);
    String cleanString = strippedString.replaceAll(specialCharsExp, '');

    return cleanString;
  }


}
