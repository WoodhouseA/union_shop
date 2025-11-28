import 'package:flutter/material.dart';

class PrintShackAboutPage extends StatelessWidget {
  const PrintShackAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Print Shack',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 32),
          Text(
            'Welcome to the Print Shack!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 32),
          Text(
            'The Print Shack is your one-stop shop for personalized merchandise. '
            'Whether you need custom t-shirts, hoodies, or mugs, we have you covered.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 32),
          Text(
            'Our high-quality printing services ensure that your designs look great and last long. '
            'Choose from a variety of fonts and colors to make your product truly unique.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 32),
          Text(
            'Visit us in-store or order online today!',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
