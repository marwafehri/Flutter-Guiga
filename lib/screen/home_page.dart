import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:gradient_like_css/gradient_like_css.dart';
import 'package:woocommerce_app/bloc/interventions_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:woocommerce_app/bloc/home_page_bloc.dart';
import 'package:woocommerce_app/screen/order_list_page.dart';
import 'package:woocommerce_app/screen/place_order_page.dart';
import 'package:woocommerce_app/screen/place_devis_page.dart';
import 'package:woocommerce_app/screen/mon_compte_page.dart';
import 'package:woocommerce_app/screen/login_page.dart';
import 'package:woocommerce_app/helper/ui_helper.dart';
import 'package:woocommerce_app/screen/dashboard_page.dart';
import 'package:woocommerce_app/bloc/blog_bloc.dart';
import 'package:woocommerce_app/screen/blog_page.dart';
import 'package:woocommerce_app/bloc/footer_bloc.dart';
import 'package:woocommerce_app/screen/single_blog_page.dart';
import 'package:woocommerce_app/screen/single_intervention_page.dart';
import 'package:woocommerce_app/screen/sejour_page.dart';
import 'package:woocommerce_app/bloc/menu_bar.dart';
import 'package:woocommerce_app/bloc/bottom_app_bar.dart';

class HomePage extends StatefulWidget {
  @override
  HomePagePageState createState() => new HomePagePageState();
}
class HomePagePageState extends State<HomePage> {
//class HomePagePageState extends State<HomePage> with TickerProviderStateMixin {

  late String userId = '';
  late String username= '';

  late AnimationController _controller;
  //late Animation<Offset> _offsetAnimation;
  //Animation<Offset>? _offsetAnimation;


  InterventionsBloc _interventionsBloc = InterventionsBloc();
  List<Map<String, dynamic>>? _interventionsList;

  BlogBloc _blogBloc = BlogBloc();
  List<Map<String, dynamic>>? _blogList;

  final FooterBloc _footerBloc = FooterBloc();

  int _currentIndex = 0;
  //final CarouselController _controllersliderreview = CarouselController();
  // final CarouselController _controllersliderblog = CarouselController();
  final CarouselSliderController _controllersliderreview = CarouselSliderController();

  final CarouselSliderController _controllersliderblog = CarouselSliderController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool isExpandedesth = false;
  bool isExpandedmedec = false;

  var bloc;

  final List<IconData> icons = [Icons.email, Icons.phone];
  void onIconTapped(int index) {
    print('Icon $index tapped');
  }

  @override

  void initState() {
    super.initState();
   // _initializeAnimations();

    bloc = HomePageBloc();

    // Function call for sales status report
    //bloc.fetchSalesReports();
    _fetchInterventions();

    loadUserId().then((value) {
      setState(() {
        userId = value['userId'] ?? 'Unknown';
        username = value['username'] ?? 'Unknown';
        print("userId");
        print(userId);

      });
    });
  }
  @override
  /*void dispose() {
    _controller?.dispose();
    super.dispose();
  }*/

  /*void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _offsetAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }*/

  Future<void> _fetchInterventions() async {
    List<Map<String, dynamic>> allInterventions = [];

    try {
      // Fetch all interventions from the bloc
      List<Map<String, dynamic>>? interventions = await _interventionsBloc.fetchListeInterventions();

      allInterventions.addAll(interventions as Iterable<Map<String, dynamic>>);

      print("All interventions home page: $allInterventions");

      setState(() {
        _interventionsList = allInterventions;
        _fetchBlog();
      });
    } catch (error) {
      print('Error fetching interventions: $error');
      // Handle the error
    }
  }
  Future<void> _fetchBlog() async {
    List<Map<String, dynamic>> allBlogs = [];

    try {
      // Fetch all interventions from the bloc
      List<Map<String, dynamic>>? blogs = await _blogBloc.fetchListeBlogs();

      allBlogs.addAll(blogs as Iterable<Map<String, dynamic>>);

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
    return new Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, // Change your icon color here
          ),
          title: Row(
            children: [
              Spacer(), // Add Spacer to push logo to the center
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: kToolbarHeight, // Set the height to match the app bar height
                  width: 180, // Adjust the width as needed
                  child: Image.asset(
                    'images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Spacer(), // Add Spacer to push login icon to the right
            ],
          ),
          backgroundColor: Colors.white,
          actions: [
            if (userId != 'Unknown')
              IconButton(
                icon: Icon(
                  Icons.account_circle_outlined,
                  size: 30,
                  color: Color(0xFF000000),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MonComptePage(null)),
                  );
                },
              ),
            if (userId == 'Unknown')
              IconButton(
                icon: Icon(
                  Icons.wifi,
                  size: 30,
                  color: Color(0xFF000000),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              )
            else
              IconButton(
                icon: Icon(
                  Icons.wifi,
                  size: 30,
                  color: Color(0xFF000000),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  ).then((_) => LoginPage().clearUserInformation(context));
                },
              )
          ],
        ),

     /* bottomNavigationBar: BottomAppBar(
        child: MenuBarr(
          icons: [
            Icons.email, Icons.phone, Icons.message
          ],
          onIconTapped: (int index) {
            setState(() {
              _currentIndex = index;
            });
            // Handle icon tapped
            print('Icon $index tapped');
          },
        ),
      ),*/




      floatingActionButton: MenuBarr(),

      bottomNavigationBar: BottomAppBarDemo(
        icons: icons,
        onIconTapped: onIconTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
     /* floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.isDismissed) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),*/




     /* bottomNavigationBar: _DemoBottomAppBar(
        fabLocation: FloatingActionButtonLocation.endDocked, // Example location
        shape: const CircularNotchedRectangle(), // Example shape
      ),*/
     /* bottomNavigationBar: BottomAppBar(
        child: MenuBarr(
          icons: [
            Icons.home, // Home
            Icons.account_circle, // Account
            Icons.exit_to_app, // Disconnect
            Icons.article, // Quote
          ],
          onIconTapped: (int index) {
            setState(() {
              _currentIndex = index;
            });
            // Handle icon tapped
            print('Icon $index tapped');
          },
        ),
      ),*/
      //bottomNavigationBar: MenuBar(),
        drawer: Drawer(
          child: Scrollbar(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'images/logo.png',
                        fit: BoxFit.cover, // To stretch the image to full width
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFe8e0d7),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Accueil'),
                  onTap: () {

                    // Route to Order List Page

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage()));

                  },
                ),

                // Check if userId is known
                if (userId == 'Unknown')
                  ListTile(
                    leading: Icon(Icons.wifi),
                    title: Text('Connexion'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage()
                          )
                      );
                    },
                  )
                else
                  ListTile(
                    leading: Icon(Icons.wifi),
                    title: Text('Deconnecter'),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      ).then((_) => LoginPage().clearUserInformation(context));
                    },
                  ),
                if (userId != 'Unknown')
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Compte'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MonComptePage(null)
                          )
                      );
                    },
                  ),
                ListTile(
                  leading: Icon(Icons.feed_outlined),
                  title: Text('Demander un devis'),
                  onTap: () {

                    // Route to Order List Page

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PlaceDevisPage()));

                  },
                ),
                ListTile(
                  leading: Icon(Icons.chrome_reader_mode),
                  title: Text('Blog'),
                  onTap: () {

                    // Route to Order List Page

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BlogPage()));

                  },
                ),
                ListTile(
                  leading: Icon(Icons.star_border_purple500),
                  title: Text('Votre Séjour'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SejourPage()));

                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey, // Choose your border color here
                        width: 1.0, // Choose your border width here
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text("Categories"),
                      ),
                      Container(
                        color: Color(0xFFe8e0d7),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Chirurgie esthétique'),
                              leading: Icon(
                                isExpandedesth ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                size: 16,
                                color: Color(0xFFA28275),
                              ),
                              onTap: () {
                                setState(() {
                                  isExpandedesth = !isExpandedesth;
                                });
                              },
                            ),
                            if (isExpandedesth) ...[
                              _menuInterventionsEsthetiqueList(),
                             /* ListTile(
                                title: Text('Chirurgie mammaire'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlogPage(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                title: Text('Chirurgie intime'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlogPage(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                title: Text('Chirurgie de la silhouette'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlogPage(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                title: Text('Chirurgie faciale'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlogPage(),
                                    ),
                                  );
                                },
                              ),*/
                            ],
                          ],
                        ),
                      ),
                      Container(
                        color: Color(0xFFfffff),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Médecine esthétique'),
                              leading: Icon(
                                isExpandedmedec ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                size: 16,
                                color: Color(0xFFA28275),
                              ),
                              onTap: () {
                                setState(() {
                                  isExpandedmedec = !isExpandedmedec;
                                });
                              },
                            ),
                            if (isExpandedmedec) ...[
                              _menuInterventionsMedecineList(),
                              /*ListTile(
                                title: Text('Chirurgie mammaire'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlogPage(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                title: Text('Chirurgie intime'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlogPage(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                title: Text('Chirurgie de la silhouette'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlogPage(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                title: Text('Chirurgie faciale'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlogPage(),
                                    ),
                                  );
                                },
                              ),*/
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/slider.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    // Slider
                    Container(
                      color : Color(0xFFffffff).withOpacity(0.8),
                      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 2.0, color: Color(0xFFD9D9D9)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 2.0),
                                      child: Text(
                                        "Dr. Bilel Guiga",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 26,
                                          color: Color(0xFFD3546E),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20), // Adjust internal padding here
                              child: Text(
                                "chirurgien Maxillofacial & esthétique en Tunisie".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "Découvrez l'excellence en chirurgie maxillo-faciale et esthétique avec le Dr. Bilel Guiga. Des soins personnalisés, une expertise exceptionnelle, et des résultats remarquables vous attendent dans notre clinique ultramoderne en Tunisie.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaceDevisPage(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFA28275), // Background color
                                borderRadius: BorderRadius.circular(50), // Border radius
                              ),
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20).copyWith(bottom: 40),
                              child: Center(
                                child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Demander un devis".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                    color: Colors.white, // Text color
                                  ),
                                ),
                              ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
           /* Container(
              color: Color(0xFFffffff),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_offsetAnimation != null)
                          SlideTransition(
                            child: Text(
                              "Révéler la beauté naturelle, redéfinir la confiance - l'harmonie entre la science et l'esthétique.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                            position: _offsetAnimation!,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),*/
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/bg-esthetique.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
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
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 2.0),
                                      child: Text(
                                        "Nos services",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 26,
                                          color: Color(0xFFD3546E),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 2.0, color: Color(0xFFD9D9D9)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MonComptePage(null),
                                      ),
                                    );
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 2.0),
                                      child: Text(
                                        "Chirurgie esthétique".toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildInterventionsEsthetiqueList(),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaceDevisPage(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFA28275), // Background color
                          borderRadius: BorderRadius.circular(50), // Border radius
                        ),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20).copyWith(bottom: 40),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Demander un devis".toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                                color: Colors.white, // Text color
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Second Container with Red Background Color
            Container(
              color: Color(0xFFe8e0d7),
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
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 2.0),
                                      child: Text(
                                        "Nos services",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 26,
                                          color: Color(0xFFD3546E),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 2.0, color: Color(0xFFD9D9D9)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MonComptePage(null),
                                      ),
                                    );
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 2.0),
                                      child: Text(
                                        "Médecine esthétique".toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildInterventionsMedecineList(),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaceDevisPage(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFA28275), // Background color
                          borderRadius: BorderRadius.circular(50), // Border radius
                        ),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20).copyWith(bottom: 40),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Demander un devis".toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                                color: Colors.white, // Text color
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                gradient: linearGradient(Alignment.centerRight,
                    ['white 40%', '#e8e0d7 40%']),
              ),
              child: Column(
                children: [
                  Container(
                   // color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Row(
                            children: [
                              GestureDetector(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 2.0),
                                    child: Text(
                                      "Votre Séjour".toUpperCase(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        color: Color(0xFF5B5B5B),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.0),
                            child: Text(
                              "Profitez d’un séjour confortable et accueillant. Nous nous engageons à rendre votre expérience aussi agréable que possible, vous offrant un soutien complet tout au long de votre parcours esthétique.",
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color(0xFFA28275),
                            ),
                            SizedBox(width: 10),
                            Text(
                                "Demander un devis gratuit",
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color(0xFFA28275),
                            ),
                            SizedBox(width: 10),
                            Text(
                                "Diagnostic médical",
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color(0xFFA28275),
                            ),
                            SizedBox(width: 10),
                            Text(
                                "Dossier médical",
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color(0xFFA28275),
                            ),
                            SizedBox(width: 10),
                            Text(
                                "Opération",
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.0),
                            child: Text(
                              "Laissez-nous prendre soin de vous dès votre arrivée jusqu’à votre départ.",
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Image.asset(
                          'images/sidi-bou-said-tunisie.jpg',
                          fit: BoxFit.cover, // To stretch the image to full width
                        ),
                        SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlaceDevisPage(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFA28275), // Background color
                              borderRadius: BorderRadius.circular(50), // Border radius
                            ),
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20).copyWith(bottom: 40),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Demander un devis".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                    color: Colors.white, // Text color
                                  ),
                                ),

                              ),
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Color(0xFFffffff),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  Container(
                    // color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 2.0),
                                    child: Text(
                                      "Témoignages".toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        color: Color(0xFF5B5B5B),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.0),
                            child: Text(
                              "Découvrez ce que nos patients satisfaits ont à dire sur leur expérience avec le Dr. Bilel Guiga:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        _buildCarouselTemoignage(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
           /* Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/chirurgie-esthetique.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Add your onTap logic here
                                },
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 2.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Vous avez plus".toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26,
                                            color: Color(0xFF5B5B5B),
                                          ),
                                        ),
                                        Text(
                                          "des questions?".toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26,
                                            color: Color(0xFF5B5B5B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5), // Add margin for spacing if needed
                          decoration: BoxDecoration(
                            color : Color(0xFFffffff).withOpacity(0.8),// Set your desired background color here
                            border: Border.all(width: 2.0, color: Color(0xFFA28275)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20), // Add padding for spacing if needed
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Votre nom',
                                    prefixIcon: Icon(Icons.person), // Add the icon here
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: phoneController,
                                  decoration: InputDecoration(
                                    labelText: 'Numéro de télephone',
                                    prefixIcon: Icon(Icons.phone_in_talk_outlined), // Add the icon here
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Adresse Email',
                                    prefixIcon: Icon(Icons.email_rounded), // Add the icon here
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: messageController,
                                  decoration: InputDecoration(
                                    labelText: 'Comment je peux vous aider?',
                                    prefixIcon: Icon(Icons.comment_bank_outlined), // Add the icon here
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () => _sendContactForm(context),
                                  child: Text('Contactez-nous'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),*/
            Container(
              color: Color(0xFFffffff),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  Container(
                    // color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 2.0),
                                    child: Text(
                                      "Notre blog".toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        color: Color(0xFF5B5B5B),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.0),
                            child: Text(
                              "Découvrez notre blog sur la chirurgie esthétique. Conseils, tendances et inspirations pour sublimer votre beauté.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        _buildCarouselBlog(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _footerBloc.blocFooter(context),
          ],
        ),
      ),
    );
}
                      /*Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: Colors.black), // Add a border at the top
                          ),
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle the click event here
                                // For example, you can navigate to a new screen
                                // or perform any other action you want
                                print('Text clicked');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MonComptePage(null),
                                  ),
                                );
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    "Chirurgie esthétique",
                                    style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),*/





               /* Container(

                    color: Colors.transparent,

                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.35,


                    child: Row(


                      children: <Widget>[

                        Expanded(

                            child: Container(

                              margin: EdgeInsets.only(
                                  left: 20, top: 30, bottom: 30, right: 15),


                              child: InkWell(
                                  onTap: () {

                                    // Route to Customer List Page

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                //CustomerListPage()));
                                              PlaceOrderPage(null)));
                                  },
                                  child: Card(

                                    child: Center(


                                        child: Column(

                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            mainAxisSize: MainAxisSize.max,

                                            children: <Widget>[

                                              Icon(
                                                Icons.people,
                                                color: UIHelper.themeColor,
                                                size: 40,
                                              ),

                                              Container(height: 10,),

                                              Text('Demander un RDV',style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14
                                              ))

                                            ]

                                        )


                                    ),
                                  )),
                            )


                        ),
                        Expanded(

                            child: Container(

                              margin: EdgeInsets.only(
                                  left: 20, top: 30, bottom: 30, right: 15),


                              child: InkWell(
                                  onTap: () {

                                    // Route to Customer List Page

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            //CustomerListPage()));
                                            MonComptePage(null)));
                                  },
                                  child: Card(

                                    child: Center(


                                        child: Column(

                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            mainAxisSize: MainAxisSize.max,

                                            children: <Widget>[

                                              Icon(
                                                Icons.people,
                                                color: UIHelper.themeColor,
                                                size: 40,
                                              ),

                                              Container(height: 10,),

                                              Text('Mon compte',style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14
                                              ))

                                            ]

                                        )


                                    ),
                                  )),
                            )


                        ),
                        Expanded(

                            child: Container(

                              margin: EdgeInsets.only(
                                  left: 20, top: 30, bottom: 30, right: 15),


                              child: InkWell(
                                  onTap: () {

                                    // Route to Customer List Page

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            //CustomerListPage()));
                                            PlaceDevisPage()));
                                  },
                                  child: Card(

                                    child: Center(


                                        child: Column(

                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            mainAxisSize: MainAxisSize.max,

                                            children: <Widget>[

                                              Icon(
                                                Icons.people,
                                                color: UIHelper.themeColor,
                                                size: 40,
                                              ),

                                              Container(height: 10,),

                                              Text('Demander un devis',style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14
                                              ))

                                            ]

                                        )


                                    ),
                                  )),
                            )


                        ),

                        Expanded(

                            child: Container(

                              margin: EdgeInsets.only(
                                  left: 20, top: 30, bottom: 30, right: 15),


                              child: InkWell(
                                  onTap: () {

                                    // Route to Customer List Page

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerListPage()));
                                  },
                                  child: Card(

                                    child: Center(


                                        child: Column(

                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            mainAxisSize: MainAxisSize.max,

                                            children: <Widget>[

                                              Icon(
                                                Icons.people,
                                                color: UIHelper.themeColor,
                                                size: 40,
                                              ),

                                              Container(height: 10,),

                                              Text('Customers',style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14
                                              ))

                                            ]

                                        )


                                    ),
                                  )),
                            )


                        ),

                        Expanded(

                            child: Container(

                              margin: EdgeInsets.only(
                                  left: 15, top: 30, bottom: 30, right: 20),


                              child: InkWell(
                                  onTap: () {

                                    // Route to Order List Page

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrderListPage()));
                                  },
                                  child: Card(

                                    child: Center(


                                        child: Column(

                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            mainAxisSize: MainAxisSize.max,

                                            children: <Widget>[

                                              Icon(
                                                Icons.assignment,
                                                color: UIHelper.themeColor,
                                                size: 40,
                                              ),

                                              Container(height: 10,),

                                              Text('Orders',style: TextStyle(
                                              color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14
                                              ))

                                            ]

                                        )


                                    ),
                                  )),
                            )


                        )


                      ],


                    )

                ),

                Container(


                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.45,

                    child: Container(


                        margin: EdgeInsets.all(20.0),

                        child: Card(


                          elevation: 2,
                          child: ClipPath(

                              clipper: ShapeBorderClipper(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3))),

                              child: Container(

                                  decoration: BoxDecoration(
                                      border: Border(top: BorderSide(
                                          color: Colors.red, width: 5))),

                                  child: Container(


                                      margin: EdgeInsets.all(20.0),

                                      child:

                                      Column(

                                        children: <Widget>[


                                          Flexible(

                                              flex: 5,

                                              child: new Row(

                                                  children: <Widget>[


                                                    Flexible(

                                                        flex: 3,
                                                        child: new Center(

                                                            child: Column(

                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                                mainAxisSize: MainAxisSize
                                                                    .max,

                                                                children: <
                                                                    Widget>[

                                                                  totalCountPerModuleWidget(
                                                                      'customers'),

                                                                  Container(
                                                                    height: 5,),

                                                                  Text(
                                                                    'Customer',
                                                                     style: UIHelper.getTextStyleForHomeScreenItem(),)

                                                                ]

                                                            )

                                                        )),


                                                    new Container(
                                                      color: Colors.grey,
                                                      width: .5, height: 40,),

                                                    Flexible(

                                                        flex: 3,
                                                        child: new Container(

                                                            child: Column(

                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                                mainAxisSize: MainAxisSize
                                                                    .max,

                                                                children: <
                                                                    Widget>[

                                                                  totalCountPerModuleWidget(
                                                                      'products'),

                                                                  Container(
                                                                    height: 5,),

                                                                  Text(
                                                                    'Products',
                                                                    style: UIHelper.getTextStyleForHomeScreenItem())

                                                                ]

                                                            )

                                                        )),

                                                    new Container(
                                                      color: Colors.grey,
                                                      width: .5, height: 40,),
                                                    Flexible(

                                                        flex: 3,
                                                        child: new Container(
                                                            child: Column(

                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                                mainAxisSize: MainAxisSize
                                                                    .max,

                                                                children: <
                                                                    Widget>[

                                                                  totalCountPerModuleWidget(
                                                                      'orders'),

                                                                  Container(
                                                                    height: 5,),

                                                                  Text('Orders',
                                                                    style: UIHelper.getTextStyleForHomeScreenItem(),)

                                                                ]

                                                            ))),


                                                  ]
                                              )),


                                          new Container(
                                            height: .5, color: Colors.grey,),


                                          Flexible(

                                              flex: 5,

                                              child: new Row(

                                                  children: <Widget>[


                                                    Flexible(

                                                        flex: 3,
                                                        child: new Center(

                                                            child: Column(

                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                                mainAxisSize: MainAxisSize
                                                                    .max,

                                                                children: <
                                                                    Widget>[

                                                                  salesValueReportBySalesType('average'),

                                                                  Container(
                                                                    height: 5,),

                                                                  Text(
                                                                    'Avg sales',
                                                                    style: UIHelper.getTextStyleForHomeScreenItem())

                                                                ]

                                                            )

                                                        )),


                                                    new Container(
                                                      color: Colors.grey,
                                                      width: .5, height: 40,),

                                                    Flexible(

                                                        flex: 3,
                                                        child: new Container(

                                                            child: Column(

                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                                mainAxisSize: MainAxisSize
                                                                    .max,

                                                                children: <
                                                                    Widget>[

                                                                  salesValueReportBySalesType('net'),

                                                                  Container(
                                                                    height: 5,),

                                                                  Text(
                                                                    'Net sales',
                                                                    style: UIHelper.getTextStyleForHomeScreenItem())

                                                                ]

                                                            )

                                                        )),

                                                    new Container(
                                                      color: Colors.grey,
                                                      width: .5, height: 40,),
                                                    Flexible(

                                                        flex: 3,
                                                        child: new Container(
                                                            child: Column(

                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                                mainAxisSize: MainAxisSize
                                                                    .max,

                                                                children: <
                                                                    Widget>[

                                                                  salesValueReportBySalesType('total'),

                                                                  Container(
                                                                    height: 5,),

                                                                  Text(
                                                                    'Total sales',
                                                                    style: UIHelper.getTextStyleForHomeScreenItem())

                                                                ]

                                                            ))),


                                                  ]
                                              )),


                                        ],


                                      )


                                  ))),


                        )


                    )


                )
              ],

            )


        )
    );
  }*/

  /*
  * This function takes input module name
  * Perform a http request
  * return the total count of module
  * Set the count value in Text Widget
  * return a Widget
  */
 /* Widget animateText() {
    return SlideTransition(
      position: _offsetAnimation,
      child: Text(
        "Révéler la beauté naturelle, redéfinir la confiance - l'harmonie entre la science et l'esthétique.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          fontSize: 17,
        ),
      ),
    );
  }*/

  Future<Map<String, String?>> loadUserId() async {
    final storage = FlutterSecureStorage();
    //return await storage.readAll();
    return {
      'userId': await storage.read(key: 'userId'),
      'username': await storage.read(key: 'username'),
      'email': await storage.read(key: 'email'),
      // Add other pieces of user information as needed
    };
  }
  Future<void> clearUserInformation(BuildContext context) async {
    final storage = FlutterSecureStorage();

    // Delete stored values
    await storage.delete(key: 'userId');
    await storage.delete(key: 'username');
    await storage.delete(key: 'email');
    await storage.delete(key: 'phone');
    await storage.delete(key: 'first_name');
    await storage.delete(key: 'last_name');
    await storage.delete(key: 'billing_naissance');
    await storage.delete(key: 'billing_sexe');
    await storage.delete(key: 'role');

    // Add more keys if needed

    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Widget _buildInterventionsEsthetiqueList() {
    if (_interventionsList == null) {
      // Show a loading indicator while fetching data
      return Center(child: CircularProgressIndicator());
    } else if (_interventionsList!.isEmpty) {
      // Show a message if the list is empty
      return Center(child: Text('No interventions found.'));
    } else {
      // Group interventions by their types
      Map<String, List<Map<String, dynamic>>> groupedInterventions = {};
      _interventionsList!.forEach((intervention) {
        List<dynamic> interventionTypes = getInterventionType(intervention);
        if (interventionTypes.contains(41)) {
          List<int> otherTypes = interventionTypes.where((type) => type != 41).cast<int>().toList();
          String key = otherTypes.join('-');
          if (!groupedInterventions.containsKey(key)) {
            groupedInterventions[key] = [];
          }
          groupedInterventions[key]!.add(intervention);
        }
      });

      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: groupedInterventions.length,
        separatorBuilder: (context, index) => Divider(), // Add a divider between different intervention types
        itemBuilder: (context, index) {
          String key = groupedInterventions.keys.elementAt(index);
          List<Map<String, dynamic>> interventions = groupedInterventions[key]!;

          // Extract the types from the key
          List<int> types = key.split('-').map((type) => int.parse(type)).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the large title and image based on the first type
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Render the appropriate image based on the first type
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40.0,
                      child: getImageForInterventionType(types[0]),
                    ),
                    SizedBox(width: 20),
                    // Render the appropriate title based on the first type
                    Text(
                      getTitleForInterventionType(types[0]),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Display the list of interventions for this type
              Column(
                children: interventions.map((intervention) {
                  return ListTile(
                    leading: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFFA28275),
                    ),
                    title: Text(
                      //  intervention['title']['rendered'],
                      intervention['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      // Navigate to SingleBlogPage passing the postId
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleInterventionPage(intervention['id']),  // Make sure this constructor expects a postId
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          );
        },
      );
    }
  }
  Widget _menuInterventionsEsthetiqueList() {
    if (_interventionsList == null) {
      // Show a loading indicator while fetching data
      return Center(child: CircularProgressIndicator());
    } else if (_interventionsList!.isEmpty) {
      // Show a message if the list is empty
      return Center(child: Text('No interventions found.'));
    } else {
      // Group interventions by their types
      Map<String, List<Map<String, dynamic>>> groupedInterventions = {};
      _interventionsList!.forEach((intervention) {
        List<dynamic> interventionTypes = getInterventionType(intervention);
        if (interventionTypes.contains(41)) {
          List<int> otherTypes = interventionTypes.where((type) => type != 41).cast<int>().toList();
          String key = otherTypes.join('-');
          if (!groupedInterventions.containsKey(key)) {
            groupedInterventions[key] = [];
          }
          groupedInterventions[key]!.add(intervention);
        }
      });

      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: groupedInterventions.length,
        separatorBuilder: (context, index) => Divider(), // Add a divider between different intervention types
        itemBuilder: (context, index) {
          String key = groupedInterventions.keys.elementAt(index);
          List<Map<String, dynamic>> interventions = groupedInterventions[key]!;

          // Extract the types from the key
          List<int> types = key.split('-').map((type) => int.parse(type)).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the large title and image based on the first type
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Render the appropriate title based on the first type
                    Text(
                      getTitleForInterventionType(types[0]),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Display the list of interventions for this type
              Column(
                children: interventions.map((intervention) {
                  return ListTile(
                    title: Text(
                      //  intervention['title']['rendered'],
                      intervention['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      // Navigate to SingleBlogPage passing the postId
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleInterventionPage(intervention['id']),  // Make sure this constructor expects a postId
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          );
        },
      );
    }
  }
  Widget _buildInterventionsMedecineList() {
    if (_interventionsList == null) {
      // Show a loading indicator while fetching data
      return Center(child: CircularProgressIndicator());
    } else if (_interventionsList!.isEmpty) {
      // Show a message if the list is empty
      return Center(child: Text('No interventions found.'));
    } else {
      // Group interventions by their types
      Map<String, List<Map<String, dynamic>>> groupedInterventions = {};
      _interventionsList!.forEach((intervention) {
        List<dynamic> interventionTypes = getInterventionType(intervention);
        if (interventionTypes.contains(14)) {
          List<int> otherTypes = interventionTypes.where((type) => type != 41).cast<int>().toList();
          String key = otherTypes.join('-');
          if (!groupedInterventions.containsKey(key)) {
            groupedInterventions[key] = [];
          }
          groupedInterventions[key]!.add(intervention);
        }
      });

      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: groupedInterventions.length,
        separatorBuilder: (context, index) => Divider(), // Add a divider between different intervention types
        itemBuilder: (context, index) {
          String key = groupedInterventions.keys.elementAt(index);
          List<Map<String, dynamic>> interventions = groupedInterventions[key]!;

          // Extract the types from the key
          List<int> types = key.split('-').map((type) => int.parse(type)).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the large title and image based on the first type
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Render the appropriate image based on the first type
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40.0,
                      child: getImageForInterventionType(types[0]),
                    ),
                    SizedBox(width: 20),
                    // Render the appropriate title based on the first type
                    Text(
                      getTitleForInterventionType(types[0]),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Display the list of interventions for this type
              Column(
                children: interventions.map((intervention) {
                  return ListTile(
                    leading: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFFA28275),
                    ),
                    title: Text(
                      //  intervention['title']['rendered'],
                      intervention['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      // Handle onTap event here
                    },
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1.0, color: Color(0xFFD9D9D9)),
                        top: BorderSide(width: 1.0, color: Color(0xFFD9D9D9))
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  child: Row(
                    children: [
                      // Render the appropriate image based on the first type
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40.0,
                        child: Image.asset('images/lasers-dermatologiques.png'),
                      ),
                      SizedBox(width: 20),
                      // Render the appropriate title based on the first type
                      Text(
                        "Les Lasers".toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "dermatologiques".toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Render the appropriate image based on the first type
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40.0,
                      child: Image.asset('images/traitement-medical-de-la-silhouette.png'),
                    ),
                    SizedBox(width: 20),
                    // Render the appropriate title based on the first type
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Traitement médical".toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "de la silhouette".toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
  }
  Widget _menuInterventionsMedecineList() {
    if (_interventionsList == null) {
      // Show a loading indicator while fetching data
      return Center(child: CircularProgressIndicator());
    } else if (_interventionsList!.isEmpty) {
      // Show a message if the list is empty
      return Center(child: Text('No interventions found.'));
    } else {
      // Group interventions by their types
      Map<String, List<Map<String, dynamic>>> groupedInterventions = {};
      _interventionsList!.forEach((intervention) {
        List<dynamic> interventionTypes = getInterventionType(intervention);
        if (interventionTypes.contains(14)) {
          List<int> otherTypes = interventionTypes.where((type) => type != 41).cast<int>().toList();
          String key = otherTypes.join('-');
          if (!groupedInterventions.containsKey(key)) {
            groupedInterventions[key] = [];
          }
          groupedInterventions[key]!.add(intervention);
        }
      });

      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: groupedInterventions.length,
        separatorBuilder: (context, index) => Divider(), // Add a divider between different intervention types
        itemBuilder: (context, index) {
          String key = groupedInterventions.keys.elementAt(index);
          List<Map<String, dynamic>> interventions = groupedInterventions[key]!;

          // Extract the types from the key
          List<int> types = key.split('-').map((type) => int.parse(type)).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the large title and image based on the first type
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      getTitleForInterventionType(types[0]),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Display the list of interventions for this type
              Column(
                children: interventions.map((intervention) {
                  return ListTile(
                    title: Text(
                    //  intervention['title']['rendered'],
                      intervention['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      // Handle onTap event here
                    },
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  child: Row(
                    children: [
                      Text(
                        "Les Lasers".toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "dermatologiques".toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Traitement médical".toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "de la silhouette".toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
  }

  // Function to get the intervention type
List<dynamic> getInterventionType(Map<String, dynamic> intervention) {
  if (intervention.containsKey('type-d-intervention') && intervention['type-d-intervention'] != null) {
    List<dynamic> interventionTypes = intervention['type-d-intervention'];
    return interventionTypes;
  }
  return []; // Return an empty list if intervention types are not found
}

  // Function to get the image for each intervention type
  Widget getImageForInterventionType(int interventionType) {
    switch (interventionType) {
      case 12:
        return Image.asset('images/chirurgie-mammaire.png');
      case 13:
        return Image.asset('images/chirurgie-intime.png');
      case 10:
        return Image.asset('images/chirurgie-de-la-silhouette.png');
      case 45:
        return Image.asset('images/chirurgie-de-la-face.png');
      case 66:
        return Image.asset('images/injections-de-botox.png');
      case 67:
        return Image.asset('images/lasers-dermatologiques.png');
      case 68:
        return Image.asset('images/traitement-medical-de-la-silhouette.png');
      default:
        return Container(); // Return an empty container if intervention type is not recognized
    }
  }


// Function to get the title for each intervention type
  String getTitleForInterventionType(int interventionType) {
    switch (interventionType) {
      case 12:
        return "Chirurgie mammaire".toUpperCase();
      case 13:
        return "Chirurgie intime".toUpperCase();
      case 10:
        return "Chirurgie de la silhouette".toUpperCase();
      case 45:
        return "Chirurgie faciale".toUpperCase();
      case 66:
        return "Injection et comblement".toUpperCase();
      case 67:
        return "Les Lasers dermatologiques".toUpperCase();
      case 68:
        return "Traitement médical de la silhouette".toUpperCase();
      default:
        return "";
    }
  }

  Widget _buildCarouselTemoignage() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 340,
            aspectRatio: 16/9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 10),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            scrollDirection: Axis.horizontal,

          ),
          carouselController: _controllersliderreview,

          items: [
            _buildReview1(),
            _buildReview2(),
          ],

        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  if (_controllersliderreview != null) {
                    _controllersliderreview.previousPage();
                  }
                },
                child: Text(
                    '←',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  if (_controllersliderreview != null) {
                    _controllersliderreview.nextPage();
                  }
                },
                child: Text(
                    '→',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
  Widget _buildReview1() {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFf3ece9),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mae hmd',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'il y a 2 mois',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(Icons.star, color: Colors.yellow);
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Dr.Guiga is extremely professional, he takes time to listen and time to explain. A first rate professional experience. Completely satisfied and all the support staff. HIGHLY recommend. 💯 Thank you for ensuring my surgery was a success.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildReview2() {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFf3ece9),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Ryad',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'il y a 3 mois',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(Icons.star, color: Colors.yellow);
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Je viens de faire une rhinoplastie avec Dr Bilal guiga , franchement il est adorable super gentil il prend le temps de parler avec le patient le met a l\'aise je ne regrette pas du tout, pour moi allez y les yeux fermés avec ce docteur ❤️🙏 le résultat vous ne serez pas déçu car il a des mains en or 👌❤️',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCarouselBlog() {
    return Column(
      children: [
        if (_blogList != null)
          CarouselSlider(
            options: CarouselOptions(
              height: 520,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 10),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
            ),
            carouselController: _controllersliderblog,
            items: _blogList!.map((blog) {
              return Column(
                children: [

                /*  if (blog.containsKey('_embedded') &&
                      blog['_embedded'] != null &&
                      blog['_embedded'].containsKey('wp:featuredmedia') &&
                      blog['_embedded']['wp:featuredmedia'] != null &&
                      blog['_embedded']['wp:featuredmedia'] is List &&
                      blog['_embedded']['wp:featuredmedia'].isNotEmpty &&
                      blog['_embedded']['wp:featuredmedia'][0] != null &&
                      blog['_embedded']['wp:featuredmedia'][0].containsKey('source_url'))
                    Image.network(
                      blog['_embedded']['wp:featuredmedia'][0]['source_url'],
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      fit: BoxFit.cover,
                    ),*/
                    if(blog['featuredMediaUrl'] != null)
                    Image.network(
                      blog['featuredMediaUrl'],
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // Navigate to SingleBlogPage passing the postId
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleBlogPage(blog['id']),  // Make sure this constructor expects a postId
                        ),
                      );
                    },
                    child: Text(
                    //  _stripHtmlAndSpecialChars(blog['title']['rendered']),
                      _stripHtmlAndSpecialChars(blog['title']),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      //_stripHtmlAndSpecialChars(blog['excerpt']['rendered']),
                      _stripHtmlAndSpecialChars(blog['excerpt']),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    'Date: ${blog['date']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Divider(),
                ],
              );
            }).toList(),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  if (_controllersliderblog != null) {
                    _controllersliderblog.previousPage();
                  }
                },
                child: Text(
                  '←',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  if (_controllersliderblog != null) {
                    _controllersliderblog.nextPage();
                  }
                },
                child: Text(
                  '→',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
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
  /*Widget _buildBlogsList() {
    if (_blogList == null) {
      // Show a loading indicator while fetching data
      return Center(child: CircularProgressIndicator());
    } else if (_blogList!.isEmpty) {
      // Show a message if the list is empty
      return Center(child: Text('No blog found.'));
    } else {
      // Limit the number of items to display to a maximum of 5
      List<Map<String, dynamic>> limitedBlogs = _blogList!.take(5).toList();

      return Container( // Wrap ListView.builder with a Container
        height: MediaQuery.of(context).size.height, // Set height to fill available space
        child: ListView.builder(
          itemCount: limitedBlogs!.length,
          itemBuilder: (context, index) {
            // Extract blog details
            Map<String, dynamic> blog = limitedBlogs![index];
            String titleHtml = blog['title']['rendered'];
            String title = _stripHtmlAndSpecialChars(titleHtml);
            String excerptHtml = blog['excerpt']['rendered'];
            String excerpt = _stripHtmlAndSpecialChars(excerptHtml);
            String date = blog['date'];
            // Extract image URL
           // String imageUrl = '';
            String imageUrl = '';
            if (blog.containsKey('_embedded') &&
                blog['_embedded'] != null &&
                blog['_embedded'].containsKey('wp:featuredmedia') &&
                blog['_embedded']['wp:featuredmedia'] != null &&
                blog['_embedded']['wp:featuredmedia'] is List &&
                blog['_embedded']['wp:featuredmedia'].isNotEmpty &&
                blog['_embedded']['wp:featuredmedia'][0] != null &&
                blog['_embedded']['wp:featuredmedia'][0].containsKey('source_url')) {
              imageUrl = blog['_embedded']['wp:featuredmedia'][0]['source_url'];
            } else {
              imageUrl = "https://www.drg.deveoo.net/wp-content/uploads/2024/03/Les-Tendances-en-Chirurgie_Esthetique-150x150.jpg";
            }

            return Column(
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
            );
          },
        ),
      );
    }
  }*/


  /*
  Widget _buildCarouselTemoignage() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Ryad',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'il y a 3 mois',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(Icons.star, color: Colors.yellow);
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Je viens de faire une rhinoplastie avec Dr Bilal guiga , franchement il est adorable super gentil il prend le temps de parler avec le patient le met a l\'aise je ne regrette pas du tout, pour moi allez y les yeux fermés avec ce docteur ❤️🙏 le résultat vous ne serez pas déçu car il a des mains en or 👌❤️',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Ryad',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'il y a 3 mois',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(Icons.star, color: Colors.yellow);
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Je viens de faire une rhinoplastie avec Dr Bilal guiga , franchement il est adorable super gentil il prend le temps de parler avec le patient le met a l\'aise je ne regrette pas du tout, pour moi allez y les yeux fermés avec ce docteur ❤️🙏 le résultat vous ne serez pas déçu car il a des mains en or 👌❤️',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Ryad',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'il y a 3 mois',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(Icons.star, color: Colors.yellow);
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Je viens de faire une rhinoplastie avec Dr Bilal guiga , franchement il est adorable super gentil il prend le temps de parler avec le patient le met a l\'aise je ne regrette pas du tout, pour moi allez y les yeux fermés avec ce docteur ❤️🙏 le résultat vous ne serez pas déçu car il a des mains en or 👌❤️',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }*/
  /*
  Widget _buildInterventionsMedecineList() {
    if (_interventionsList == null) {
      // Show a loading indicator while fetching data
      return Center(child: CircularProgressIndicator());
    } else if (_interventionsList!.isEmpty) {
      // Show a message if the list is empty
      return Center(child: Text('No interventions found.'));
    } else {
      bool titreComblement = _interventionsList!.any((item) => item['type-d-intervention'].contains(66));
      bool titreDermatologiques = _interventionsList!.any((item) => item['type-d-intervention'].contains(67));
      bool titreMedicalSilhouette = _interventionsList!.any((item) => item['type-d-intervention'].contains(68));
      // Display the list of interventions
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Conditionally display the title if there is at least one matching item
          if (titreComblement)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SvgPicture.asset('images/icon_Injections-de-Botox.svg'),
                  SizedBox(height: 20,),
                  Text(
                    "Injection et comblement",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          if (titreDermatologiques)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SvgPicture.asset('images/Lasers-dermatologiques.svg'),
                  SizedBox(height: 20,),
                  Text(
                    "Les Lasers dermatologiques",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          if (titreMedicalSilhouette)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SvgPicture.asset('images/silhouette.svg'),
                  SizedBox(height: 20,),
                  Text(
                    "Traitement médical de la silhouette",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), // Use this to prevent scrolling inside a Column
            itemCount: _interventionsList!.length,
            itemBuilder: (context, index) {
              // Check if the current item has type-d-intervention equal to 45
              if (titreComblement) {
                // Display the title of the intervention
                return ListTile(
                  title: Text(_interventionsList![index]['title']['rendered']),
                );
              } else if (titreDermatologiques) {

                return ListTile(
                  title: Text(_interventionsList![index]['title']['rendered']),
                );
              } else if (titreMedicalSilhouette) {

                return ListTile(
                  title: Text(_interventionsList![index]['title']['rendered']),
                );
              }  else {
                // If the current item does not have type-d-intervention equal to 45, return an empty container
                return SizedBox.shrink();
              }
            },
          ),
        ],
      );
    }
  }*/

  Widget totalCountPerModuleWidget(String moduleName ) {

    bloc.fetchPerModuleCount(moduleName);


    // Stream stream ;
    Stream stream = bloc.customerCountFetcher.stream; // Default value

    if(moduleName=='customers')
    {
      stream = bloc.customerCountFetcher.stream;
      print(stream);
    }
    else if(moduleName=='products')
    {
      stream = bloc.productCountFetcher.stream;
    }
    else if(moduleName=='orders')
    {
      stream = bloc.orderCountFetcher.stream;
    }


    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? new Container(
            child: Text(snapshot.data.toString(),style: TextStyle(color: UIHelper.themeColor,fontWeight: FontWeight.w600,fontSize: 14)))
            : new Container(
            height: 20,
            width: 20,
            child:CircularProgressIndicator(strokeWidth: 2,));
      },
    );
  }

  Widget salesValueReportBySalesType(String salesType ) {

   // Stream stream ;
    Stream stream = bloc.customerCountFetcher.stream; // Default value

    if(salesType=='average')
    {
      stream = bloc.averageSalesValueFetcher.stream;
    }
    else if(salesType=='net')
    {
      stream = bloc.netSalesValueFetcher.stream;
    }
    else if(salesType=='total')
    {
      stream = bloc.totalSalesValueFetcher.stream;
    }

    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? new Container(
            child: Text('\$ '+snapshot.data.toString(),style: TextStyle(color: UIHelper.themeColor)))
            : new Container(
            height: 20,
            width: 20,
            child:CircularProgressIndicator(strokeWidth: 2,));
      },
    );
  }


}


/*class _DemoBottomAppBar extends StatelessWidget {
  const _DemoBottomAppBar({
    this.fabLocation = FloatingActionButtonLocation.endDocked,
    this.shape = const CircularNotchedRectangle(),
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;

  static final List<FloatingActionButtonLocation> centerLocations =
  <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Colors.blue,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),*/
            /*if (centerLocations.contains(fabLocation)) const Spacer(),
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Favorite',
              icon: const Icon(Icons.favorite),
              onPressed: () {},
            ),*/
          /*],
        ),
      ),
    );
  }
}*/