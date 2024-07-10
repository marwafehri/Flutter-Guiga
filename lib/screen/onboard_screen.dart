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
import 'package:woocommerce_app/screen/customer_add.dart';
import 'package:woocommerce_app/helper/ui_helper.dart';
import 'package:woocommerce_app/screen/dashboard_page.dart';
import 'package:woocommerce_app/bloc/blog_bloc.dart';
import 'package:woocommerce_app/screen/blog_page.dart';
import 'package:woocommerce_app/bloc/footer_bloc.dart';
import 'package:woocommerce_app/screen/single_blog_page.dart';
import 'package:woocommerce_app/screen/single_intervention_page.dart';
import 'package:woocommerce_app/screen/sejour_page.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

import 'home_page.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  void _onIntroEnd() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'S’enregistrer',
      onFinish: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => CustomerAddPage(),
          ),
        );
      },
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: Color(0xFFD3546E),
      ),
      skipTextButton: Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFD3546E),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        'Connecter',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFD3546E),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      },
      controllerColor: Color(0xFFD3546E),
      totalPage: 3,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      background: [
        Image.asset(
          'images/logo-slider1.png',
          height: 320,
        ),
        Image.asset(
          'images/suivi.png',
          height: 350,
        ),
        Image.asset(
          'images/temoigne.png',
          height: 400,
        ),
      ],
      speed: 1.8,
      pageBodies: [ 
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Dr.Bilel Guiga',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD3546E),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Maxillofacial Surgery – Aesthetic Surgery',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Suivi Personnalisé',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD3546E),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Suivi post-opératoire et conseils',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Témoignages et Résultats',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD3546E),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Témoignages et résultats patients',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}