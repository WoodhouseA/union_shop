import 'package:flutter/material.dart';
import 'package:union_shop/widgets/app_bar.dart';
import 'package:union_shop/widgets/mobile_menu.dart';
import 'package:union_shop/widgets/footer.dart';

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
      body: Stack(
        children: [
          widget.scrollable
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.child,
                            const Footer(),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Column(
                  children: [
                    Expanded(child: widget.child),
                    const Footer(),
                  ],
                ),
          if (_isMenuOpen) const MobileMenu(),
        ],
      ),
    );
  }
}
