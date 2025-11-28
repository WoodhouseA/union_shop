import 'package:flutter/material.dart';

class PrintShackPage extends StatefulWidget {
  const PrintShackPage({super.key});

  @override
  State<PrintShackPage> createState() => _PrintShackPageState();
}

class _PrintShackPageState extends State<PrintShackPage> {
  String _customText = '';
  String _selectedFont = 'Roboto';
  Color _selectedColor = Colors.black;

  final List<String> _fonts = ['Roboto', 'Arial', 'Times New Roman', 'Courier'];
  final Map<String, Color> _colors = {
    'Black': Colors.black,
    'Red': Colors.red,
    'Blue': Colors.blue,
    'Green': Colors.green,
    'Purple': Colors.purple,
    'Orange': Colors.orange,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Print Shack Personalization',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Preview Section
          const Text(
            'Preview:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              _customText.isEmpty ? 'Your Text Here' : _customText,
              style: TextStyle(
                fontFamily: _selectedFont,
                color: _selectedColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          // Form Section
          const Text(
            'Customize Your Product',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Text Input
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Custom Text',
              border: OutlineInputBorder(),
              helperText: 'Enter the text you want to print',
            ),
            onChanged: (value) {
              setState(() {
                _customText = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Font Selector
          DropdownButtonFormField<String>(
            value: _selectedFont,
            decoration: const InputDecoration(
              labelText: 'Select Font',
              border: OutlineInputBorder(),
            ),
            items: _fonts.map((String font) {
              return DropdownMenuItem<String>(
                value: font,
                child: Text(font),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedFont = newValue;
                });
              }
            },
          ),
          const SizedBox(height: 16),

          // Color Selector
          DropdownButtonFormField<Color>(
            value: _selectedColor,
            decoration: const InputDecoration(
              labelText: 'Select Color',
              border: OutlineInputBorder(),
            ),
            items: _colors.entries.map((entry) {
              return DropdownMenuItem<Color>(
                value: entry.value,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: entry.value,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(entry.key),
                  ],
                ),
              );
            }).toList(),
            onChanged: (Color? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedColor = newValue;
                });
              }
            },
          ),
          const SizedBox(height: 32),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Placeholder for add to cart or order functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to cart!')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
