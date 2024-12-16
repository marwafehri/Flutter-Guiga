import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce_app/helper/const.dart';
import 'package:woocommerce_app/helper/ui_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:woocommerce_app/screen/blog_page.dart';
import 'package:woocommerce_app/screen/home_page.dart';
import 'package:woocommerce_app/screen/place_devis_page.dart';
import 'package:woocommerce_app/screen/sejour_page.dart';
import 'package:url_launcher/url_launcher.dart';

/* whatsapp */
final String message = 'Bonjour';
final Uri _url = Uri.parse('https://wa.me/+21696238882?message=$message');

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url?message=$message');
  }
}
/* telephone */
final Uri _urltel = Uri.parse('tel:+21696238882');
Future<void> _launchUrltel() async {
  if (!await launchUrl(_urltel)) {
    throw Exception('Could not launch $_urltel');
  }
}
/* email */
String? encodeQueryParameters(Map<String, String> params) {
return params.entries
    .map((MapEntry<String, String> e) =>
'${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
    .join('&');
}

Future<void> _launchEmail() async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'marwafehristic@gmail.com',
    query: encodeQueryParameters(<String, String>{
    'subject': 'Example Subject & Symbols are allowed!',
    }),
  );
  if (await launchUrl(emailLaunchUri)) {
    throw Exception('Could not launch $emailLaunchUri');
  }
}
/*
void _launchWhatsApp() async {
  String contact = "+21696238882";
  String message = 'Bonjour';

  // WhatsApp URL for Android and iOS
  String whatsappUrl = Platform.isIOS
      ? "https://wa.me/$contact?text=${Uri.encodeComponent(message)}"
      : "whatsapp://send?phone=$contact&text=${Uri.encodeComponent(message)}";

  try {
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp';
    }
  } catch (e) {
    print('Error launching WhatsApp: $e');
  }
}
*/
class FooterBloc {

  Widget blocFooter(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFA28275),
            ),
            child: Column(
              children: [
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Adresse',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Expanded( // Wrap the Text widget in an Expanded widget
                                child: Text(
                                  'Lake Tower, C2-8, Avenue Beji Caïd Essebsi, Marsa 1053, Tunisie',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  maxLines: 7,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contactez-nous',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.mark_email_unread_sharp,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: InkWell( // Use InkWell for better feedback on tap
                                  onTap: () async {
                                    _launchEmail();
                                  },

                                  child: Text(
                                    'bilelguiga@gmail.com',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    maxLines: 7,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.phone_in_talk_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: InkWell( // Use InkWell for better feedback on tap
                                  onTap: () async {
                                    _launchUrltel();
                                  },

                                  child: Text(
                                    '(+216) 71 749 494',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    maxLines: 7,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: InkWell( // Use InkWell for better feedback on tap
                                  onTap: () async {
                                    _launchUrl();
                                  },

                                  child: Text(
                                    '(+216) 54 583 255',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    maxLines: 7,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                   /* Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFA28275), // Background color
                                      borderRadius: BorderRadius.circular(50), // Border radius
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Text(
                                          "Chirurgie esthétique",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                            color: Colors.white, // Text color
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFA28275), // Background color
                                      borderRadius: BorderRadius.circular(50), // Border radius
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Text(
                                          "Médecine esthétique",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                            color: Colors.white, // Text color
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),*/
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
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
                                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Text(
                                          "Demander un devis",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                            color: Colors.white, // Text color
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SejourPage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFA28275), // Background color
                                      borderRadius: BorderRadius.circular(50), // Border radius
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Text(
                                          "Votre Séjour",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                            color: Colors.white, // Text color
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlogPage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFA28275), // Background color
                                      borderRadius: BorderRadius.circular(50), // Border radius
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Text(
                                          "Blog",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                            color: Colors.white, // Text color
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded( // Wrap the Text widget in an Expanded widget
                                child: Text(
                                  '© 2024 Dr. Bilel guiga – Tous les droits sont réservés Powered By DEVEOO',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                  maxLines: 7,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
            ),
          ),
        ],
      ),
    );
  }

}
