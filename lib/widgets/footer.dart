import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(32.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Opening Hours
          const Text(
            'Opening Hours',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            '❄️ Winter Break Closure Dates ❄️',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text('Closing 4pm 19/12/2025'),
          const Text('Reopening 10am 05/01/2026'),
          const Text('Last post date: 12pm on 18/12/2025'),
          const SizedBox(height: 16),
          const Text(
            '(Term Time)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text('Monday - Friday 10am - 4pm'),
          const SizedBox(height: 8),
          const Text(
            '(Outside of Term Time / Consolidation Weeks)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text('Monday - Friday 10am - 3pm'),
          const SizedBox(height: 8),
          const Text('Purchase online 24/7'),

          const Divider(height: 48),

          // Help and Information
          const Text(
            'Help and Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFooterLink('Search', () {}),
          const SizedBox(height: 8),
          _buildFooterLink('Terms & Conditions of Sale Policy', () {}),

          const Divider(height: 48),

          // Latest Offers
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

          const SizedBox(height: 32),

          // Social Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.facebook),
                onPressed: () {},
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.twitter),
                onPressed: () {},
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.instagram),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
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
