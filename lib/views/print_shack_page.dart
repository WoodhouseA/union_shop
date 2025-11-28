import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/cart_service.dart';

class PrintShackPage extends StatefulWidget {
  const PrintShackPage({super.key});

  @override
  State<PrintShackPage> createState() => _PrintShackPageState();
}

class _PrintShackPageState extends State<PrintShackPage> {
  int _numberOfLines = 1;
  String _line1Text = '';
  String _line2Text = '';
  int _quantity = 1;

  double get _price => _numberOfLines == 1 ? 3.00 : 5.00;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personalisation',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '£${_price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          const Text('Tax included.'),
          const SizedBox(height: 24),

          // Options
          const Text('Number of Lines:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Radio<int>(
                value: 1,
                groupValue: _numberOfLines,
                onChanged: (val) {
                  setState(() {
                    _numberOfLines = val!;
                  });
                },
              ),
              const Text('One Line of Text (£3.00)'),
            ],
          ),
          Row(
            children: [
              Radio<int>(
                value: 2,
                groupValue: _numberOfLines,
                onChanged: (val) {
                  setState(() {
                    _numberOfLines = val!;
                  });
                },
              ),
              const Text('Two Lines of Text (£5.00)'),
            ],
          ),

          const SizedBox(height: 16),

          TextField(
            decoration: const InputDecoration(
              labelText: 'Line 1 Text',
              border: OutlineInputBorder(),
              helperText: 'Max 10 characters',
            ),
            maxLength: 10,
            onChanged: (val) => _line1Text = val,
          ),

          if (_numberOfLines == 2) ...[
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Line 2 Text',
                border: OutlineInputBorder(),
                helperText: 'Max 10 characters',
              ),
              maxLength: 10,
              onChanged: (val) => _line2Text = val,
            ),
          ],

          const SizedBox(height: 24),

          // Quantity
          Row(
            children: [
              const Text('Quantity',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                    ),
                    Text('$_quantity'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() => _quantity++);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _addToCart,
              child: const Text('Add to cart'),
            ),
          ),

          const SizedBox(height: 32),

          const Text(
            '£3 for one line of text! £5 for two!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('One line of text is 10 characters.'),
          const SizedBox(height: 16),
          const Text(
            'Please ensure all spellings are correct before submitting your purchase as we will print your item with the exact wording you provide. We will not be responsible for any incorrect spellings printed onto your garment. Personalised items do not qualify for refunds.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _addToCart() {
    if (_line1Text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter text for Line 1')));
      return;
    }
    if (_numberOfLines == 2 && _line2Text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter text for Line 2')));
      return;
    }

    final cartService = Provider.of<CartService>(context, listen: false);
    final product = Product(
      id: 'personalisation-${DateTime.now().millisecondsSinceEpoch}',
      collectionId: 'service',
      name:
          'Personalisation (${_numberOfLines == 1 ? "One Line" : "Two Lines"})',
      price: _price,
      onSale: false,
      imageUrl:
          'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854', // Placeholder
      sizes: [],
      colors: [],
    );

    String customText = _line1Text;
    if (_numberOfLines == 2) {
      customText += ' | $_line2Text';
    }

    cartService.addToCart(
      product,
      quantity: _quantity,
      customText: customText,
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Added to cart!')));
  }
}
