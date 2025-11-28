import 'package:flutter/material.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/product_service.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/widgets/page_wrapper.dart';
import 'package:union_shop/widgets/product_card.dart';

class CollectionPage extends StatefulWidget {
  final String collectionId;
  final String collectionName;

  const CollectionPage({
    super.key,
    required this.collectionId,
    required this.collectionName,
  });

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final ProductService _productService = ProductService();
  
  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Filtering
  RangeValues _currentPriceRange = const RangeValues(0, 1000);
  double _minPrice = 0;
  double _maxPrice = 1000;

  // Sorting
  String _sortOption = 'name_asc'; // name_asc, name_desc, price_asc, price_desc

  // Pagination
  int _currentPage = 1;
  final int _itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _productService.getProductsByCollection(widget.collectionId);
      
      double max = 1000;
      if (products.isNotEmpty) {
        max = products
            .map((p) =>
                (p.onSale && p.salePrice != null) ? p.salePrice! : p.price)
            .reduce((a, b) => a > b ? a : b);
      }

      setState(() {
        _allProducts = products;
        _minPrice = 0;
        _maxPrice = max + 1;
        _currentPriceRange = RangeValues(_minPrice, _maxPrice);
        _applyFiltersAndSort();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFiltersAndSort() {
    List<Product> temp = List.from(_allProducts);

    // Filter
    temp = temp.where((p) {
      final effectivePrice =
          (p.onSale && p.salePrice != null) ? p.salePrice! : p.price;
      return effectivePrice >= _currentPriceRange.start &&
          effectivePrice <= _currentPriceRange.end;
    }).toList();

    // Sort
    switch (_sortOption) {
      case 'name_asc':
        temp.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'name_desc':
        temp.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'price_asc':
        temp.sort((a, b) {
          final priceA =
              (a.onSale && a.salePrice != null) ? a.salePrice! : a.price;
          final priceB =
              (b.onSale && b.salePrice != null) ? b.salePrice! : b.price;
          return priceA.compareTo(priceB);
        });
        break;
      case 'price_desc':
        temp.sort((a, b) {
          final priceA =
              (a.onSale && a.salePrice != null) ? a.salePrice! : a.price;
          final priceB =
              (b.onSale && b.salePrice != null) ? b.salePrice! : b.price;
          return priceB.compareTo(priceA);
        });
        break;
    }

    setState(() {
      _displayedProducts = temp;
      _currentPage = 1; // Reset to first page
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filter by Price', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  RangeSlider(
                    values: _currentPriceRange,
                    min: _minPrice,
                    max: _maxPrice,
                    divisions: 20,
                    labels: RangeLabels(
                      '£${_currentPriceRange.start.toStringAsFixed(0)}',
                      '£${_currentPriceRange.end.toStringAsFixed(0)}',
                    ),
                    onChanged: (values) {
                      setModalState(() {
                        _currentPriceRange = values;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('£${_currentPriceRange.start.toStringAsFixed(2)}'),
                      Text('£${_currentPriceRange.end.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _applyFiltersAndSort();
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const PageWrapper(child: Center(child: CircularProgressIndicator()));
    }
    if (_errorMessage != null) {
      return PageWrapper(child: Center(child: Text('Error: $_errorMessage')));
    }

    // Pagination Logic
    final int totalPages = (_displayedProducts.length / _itemsPerPage).ceil();
    final int startIndex = (_currentPage - 1) * _itemsPerPage;
    final int endIndex = (startIndex + _itemsPerPage < _displayedProducts.length) 
        ? startIndex + _itemsPerPage 
        : _displayedProducts.length;
    
    final List<Product> currentProducts = _displayedProducts.sublist(startIndex, endIndex);

    return PageWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.collectionName,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Sort Dropdown
                    DropdownButton<String>(
                      value: _sortOption,
                      items: const [
                        DropdownMenuItem(value: 'name_asc', child: Text('Name (A-Z)')),
                        DropdownMenuItem(value: 'name_desc', child: Text('Name (Z-A)')),
                        DropdownMenuItem(value: 'price_asc', child: Text('Price (Low-High)')),
                        DropdownMenuItem(value: 'price_desc', child: Text('Price (High-Low)')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _sortOption = value;
                            _applyFiltersAndSort();
                          });
                        }
                      },
                    ),
                    const Spacer(),
                    // Filter Button
                    OutlinedButton.icon(
                      onPressed: _showFilterDialog,
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Filter'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          if (_displayedProducts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: Text('No products match your filters.')),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              itemCount: currentProducts.length,
              itemBuilder: (context, index) {
                final product = currentProducts[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PageWrapper(child: ProductPage(productId: product.id)),
                      ),
                    );
                  },
                  child: ProductCard(product: product),
                );
              },
            ),

          // Pagination Controls
          if (totalPages > 1)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _currentPage > 1 
                        ? () => setState(() => _currentPage--) 
                        : null,
                  ),
                  Text('Page $_currentPage of $totalPages'),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _currentPage < totalPages 
                        ? () => setState(() => _currentPage++) 
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

