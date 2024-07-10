import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:woocommerce_app/screen/home_page.dart';
import 'package:woocommerce_app/bloc/search_delegate.dart';
import 'package:woocommerce_app/bloc/search_delegate.dart';
import 'package:woocommerce_app/screen/mon_compte_page.dart';
import 'package:woocommerce_app/bloc/interventions_bloc.dart';

class BottomAppBarDemo extends StatefulWidget {
  final List<IconData> icons;
  final ValueChanged<int> onIconTapped;

  const BottomAppBarDemo({
    Key? key,
    required this.icons,
    required this.onIconTapped,
  }) : super(key: key);

  @override
  State createState() => _BottomAppBarDemoState();
}

class _BottomAppBarDemoState extends State<BottomAppBarDemo> with TickerProviderStateMixin {
  bool _showFab = true;
  bool _showNotch = true;
  FloatingActionButtonLocation _fabLocation = FloatingActionButtonLocation.endDocked;

  late AnimationController _controller;
  bool _isOverlayVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  void _toggleOverlay() {
    setState(() {
      _isOverlayVisible = !_isOverlayVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_showFab)
          FloatingActionButton(
            onPressed: () {
              _toggleOverlay();
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
            tooltip: 'Create',
            child: const Icon(Icons.add),
          ),
        _DemoBottomAppBar(
          fabLocation: _fabLocation,
          shape: _showNotch ? const CircularNotchedRectangle() : null,
          icons: widget.icons,
          onIconTapped: widget.onIconTapped,
        ),
        if (_isOverlayVisible)
          _OverlayIcons(
            icons: widget.icons,
            onIconTapped: widget.onIconTapped,
            onClose: _toggleOverlay,
          ),
      ],
    );
  }
}

class _DemoBottomAppBar extends StatelessWidget {
  final List<IconData> icons;
  final ValueChanged<int> onIconTapped;
  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;

   _DemoBottomAppBar({
    Key? key,
    required this.icons,
    required this.onIconTapped,
    this.fabLocation = FloatingActionButtonLocation.endDocked,
    this.shape = const CircularNotchedRectangle(),
  }) : super(key: key);

  static final List<FloatingActionButtonLocation> centerLocations = <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];
  final InterventionsBloc _interventionsBloc = InterventionsBloc();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Color(0xFFA28275),
      child: Container(
        height: 80.0, // Height of the BottomAppBar
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                tooltip: 'Home',
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              if (centerLocations.contains(fabLocation)) const Spacer(),
              IconButton(
                tooltip: 'Search',
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(_interventionsBloc),
                  );
                },
              ),
              IconButton(
                tooltip: 'Compte',
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MonComptePage(null)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverlayIcons extends StatelessWidget {
  final List<IconData> icons;
  final ValueChanged<int> onIconTapped;
  final VoidCallback onClose;

  const _OverlayIcons({
    Key? key,
    required this.icons,
    required this.onIconTapped,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose, // Close overlay when tapped outside icons
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: icons.map((icon) {
            return IconButton(
              icon: Icon(icon),
              onPressed: () {
                onIconTapped(icons.indexOf(icon));
                onClose(); // Close overlay when an icon is tapped
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}