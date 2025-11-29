import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(32.0),
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildOpeningHours()),
                    const SizedBox(width: 32),
                    Expanded(child: _buildHelpInfo()),
                    const SizedBox(width: 32),
                    Expanded(child: _buildLatestOffers()),
                  ],
                ),
                const SizedBox(height: 32),
                _buildSocialIcons(),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOpeningHours(),
              const Divider(height: 48),
              _buildHelpInfo(),
              const Divider(height: 48),
              _buildLatestOffers(),
              const SizedBox(height: 32),
              Center(child: _buildSocialIcons()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOpeningHours() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opening Hours',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Text(
          '❄️ Winter Break Closure Dates ❄️',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text('Closing 4pm 19/12/2025'),
        Text('Reopening 10am 05/01/2026'),
        Text('Last post date: 12pm on 18/12/2025'),
        SizedBox(height: 16),
        Text(
          '(Term Time)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('Monday - Friday 10am - 4pm'),
        SizedBox(height: 8),
        Text(
          '(Outside of Term Time / Consolidation Weeks)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('Monday - Friday 10am - 3pm'),
        SizedBox(height: 8),
        Text('Purchase online 24/7'),
      ],
    );
  }

  Widget _buildHelpInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Help and Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _FooterSearchField(),
        const SizedBox(height: 8),
        _buildFooterLink('Terms & Conditions of Sale Policy', () {}),
      ],
    );
  }

  Widget _buildLatestOffers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Latest Offers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            hintText: 'Email address',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.facebook),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.alternate_email), // Placeholder for Twitter
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.camera_alt), // Placeholder for Instagram
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildFooterLink(String title, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class _FooterSearchField extends StatefulWidget {
  @override
  State<_FooterSearchField> createState() => _FooterSearchFieldState();
}

class _FooterSearchFieldState extends State<_FooterSearchField> {
  final TextEditingController _controller = TextEditingController();

  void _submitSearch(String value) {
    if (value.isNotEmpty) {
      context.go(Uri(path: '/search', queryParameters: {'q': value}).toString());
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search products...',
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, size: 20),
            onPressed: () => _submitSearch(_controller.text),
          ),
        ),
        onSubmitted: _submitSearch,
      ),
    );
  }
}
