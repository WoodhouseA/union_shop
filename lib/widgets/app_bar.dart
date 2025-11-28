import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/services/cart_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  const CustomAppBar({super.key, required this.onMenuPressed});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _CustomAppBarState extends State<CustomAppBar> {
  void navigateToHome(BuildContext context) {
    context.go('/');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.0,
      child: Container(
        height: 100,
        color: Colors.white,
        child: Column(
          children: [
            // Top banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: const Color(0xFF4d2963),
              child: const Text(
                'UNIVERSITY OF PORTSMOUTH SHOP',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            // Main header
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 900;
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            navigateToHome(context);
                          },
                          child: Image.network(
                            'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                            height: 18,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                width: 18,
                                height: 18,
                                child: const Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: Colors.grey),
                                ),
                              );
                            },
                          ),
                        ),
                        if (isDesktop)
                          const Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _NavBarItem(title: 'Home', path: '/'),
                                _NavBarItem(title: 'About Us', path: '/about'),
                                _NavBarItem(
                                    title: 'Collections', path: '/collections'),
                                _PrintShackMenu(),
                                _NavBarItem(title: 'Sale!', path: '/sale'),
                              ],
                            ),
                          )
                        else
                          const Spacer(),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppBarButton(
                                icon: Icons.search,
                                onPressed: placeholderCallbackForButtons,
                              ),
                              AppBarButton(
                                icon: Icons.person_outline,
                                onPressed: () {
                                  context.go('/auth');
                                },
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  AppBarButton(
                                    icon: Icons.shopping_bag_outlined,
                                    onPressed: () {
                                      context.go('/cart');
                                    },
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Consumer<CartService>(
                                      builder: (context, cart, child) {
                                        return cart.items.isEmpty
                                            ? const SizedBox.shrink()
                                            : Container(
                                                padding: const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                constraints: const BoxConstraints(
                                                  minWidth: 16,
                                                  minHeight: 16,
                                                ),
                                                child: Text(
                                                  cart.totalItems.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (!isDesktop)
                                AppBarButton(
                                  icon: Icons.menu,
                                  onPressed: widget.onMenuPressed,
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarButton extends StatelessWidget {
  const AppBarButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        size: 18,
        color: Colors.grey,
      ),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
      onPressed: onPressed,
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  final String path;

  const _NavBarItem({required this.title, required this.path});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () => context.go(path),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _PrintShackMenu extends StatelessWidget {
  const _PrintShackMenu();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: PopupMenuButton<String>(
        offset: const Offset(0, 40),
        tooltip: 'The Print Shack',
        onSelected: (value) => context.go(value),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: '/print-shack',
            child: Text('Personalization'),
          ),
          const PopupMenuItem(
            value: '/print-shack-about',
            child: Text('About'),
          ),
        ],
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'The Print Shack',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.black, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
