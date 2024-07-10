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
      _sendEmail();
      print('Icon $index tapped mail');
    } else if (index == 1){
      _launchWhatsApp();
      print('Icon $index tapped phone');
    } else {
      print('Icon $index tapped other');
    }
  }
  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'mf@deveoo.com',
      queryParameters: {'subject': 'Dr Guiga'},
    );

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch email app';
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
  }
  void _launchWhatsApp() async {
    const phoneNumber = '+21696238882';
    //final url = 'https://wa.me/$phoneNumber?text=Hello';
    final url = 'https://wa.me/$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}