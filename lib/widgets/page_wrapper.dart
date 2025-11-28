import 'package:flutter/material.dart';
import 'package:union_shop/widgets/app_bar.dart';
import 'package:union_shop/widgets/mobile_menu.dart';

class PageWrapper extends StatefulWidget {
  final Widget child;
  final bool scrollable;
  const PageWrapper({super.key, required this.child, this.scrollable = true});

  @override
  State<PageWrapper> createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onMenuPressed: _toggleMenu,
      ),
      body: Column(
        children: [
          if (_isMenuOpen) const MobileMenu(),
          Expanded(
            child: widget.scrollable
                ? SingleChildScrollView(
                    child: widget.child,
                  )
                : widget.child,
          ),
        ],
      ),
    );
  }
}
