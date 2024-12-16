import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class MenuBarr extends StatefulWidget {
  @override
  State createState() => MenuBarrState();
}

class MenuBarrState extends State<MenuBarr> with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<IconData> icons = [Icons.email, Icons.phone];

 /* whatsapp */
  final String message = 'Bonjour';
  final Uri _url = Uri.parse('https://wa.me/+21696238882?text=Bonjour');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url?message=$message');
    }
  }
  /* email */
  static String? encodeQueryParameters(Map<String, String> params) {
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



  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(icons.length, (int index) {
        return _buildChild(index);
      }).toList()
        ..add(
          _buildFab(),
        ),
    );
  }

  Widget _buildChild(int index) {
     Color backgroundColor = Theme
        .of(context)
        .cardColor;
    Color foregroundColor = Theme
        .of(context)
        .colorScheme
        .secondary;
    return Container(
      height: 60.0,
      width: 80.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(
              0.0,
              1.0 - index / icons.length / 2.0,
              curve: Curves.easeOut
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: backgroundColor,
          mini: true,
          child: Icon(icons[index], color: Color(0xFFA28275)),
          onPressed: () => _onTapped(index),
        ),
      ),
    );
  }
  Widget _buildFab() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0), // Adjust this value to position the FAB higher
      child: FloatingActionButton(
        onPressed: () {
          if (_controller.isDismissed) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        },
        backgroundColor: const Color(0xFFffffff),
        tooltip: 'Increment',
        child: const Icon(Icons.add, color: Color(0xFFA28275), size: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        elevation: 2.0,
      ),
    );
  }


  void _onTapped(int index) {
    _controller.reverse();
    if (index == 0) {
      _launchEmail();
      print('Icon $index tapped mail');
    } else if (index == 1){
      _launchUrl();
      print('Icon $index tapped phone');
    } else {
      print('Icon $index tapped other');
    }
  }
  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'mf@deveoo.com',
      queryParameters: {
        'subject': 'Dr Guiga',
        'body': 'Hello, I am contacting you regarding...'
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      print('No email app found!');
      // Optionally, show a Snackbar or AlertDialog for better user feedback.
    }
  }
   /* final Uri params = Uri(
      scheme: 'mailto',
      path: 'mf@deveoo.com',
      query: 'subject=Hello&body=How are you?', // add subject and body here if needed
    );
    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }*/

 /* void _launchWhatsApp() async {
    const phoneNumber = '+21696238882';
    //final url = 'https://wa.me/$phoneNumber?text=Hello';
    final url = 'https://wa.me/$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }*/

  /*void _launchWhatsApp() async {
    String contact = "+21696238882";
    String text = 'Bonjour';
    String androidUrl = "whatsapp://send?phone=$contact&text=$text";
    String iosUrl = "https://wa.me/$contact?text=${Uri.parse(text)}";

    String webUrl = 'https://wa.me/$contact';

    const url = "https://wa.me/?text=Your Message here";
    var encoded = Uri.encodeFull(webUrl);
    print("encoded $encoded");

    try {
      if (Platform.isIOS) {
        if (await canLaunchUrl(Uri.parse(iosUrl))) {
          await launchUrl(Uri.parse(iosUrl));
        }
      } else {
        if (await canLaunchUrl(Uri.parse(encoded))) {
          await launchUrl(Uri.parse(encoded));
        }
      }
    } catch(e) {
      print('object');
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }

  }*/
}