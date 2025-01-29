import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmetic Shop',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const AccueilPage(title: 'Bienvenue sur Cosmetic Shop'),
    );
  }
}

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key, required this.title});
  final String title;

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> products = [
    Product(image: 'asset/product.jpg', title: 'Huda', price: '\$19.99'),
    Product(image: 'asset/yves.jpg', title: 'Yves Rocher', price: '\$29.99'),
    Product(image: 'asset/ritual.jpg', title: 'Rituals', price: '\$14.99'),
    Product(image: 'asset/kleo.jpg', title: 'Garnier', price: '\$39.99'),
    Product(image: 'asset/este.jpg', title: 'Estée Lauder', price: '\$24.99'),
    Product(image: 'asset/dior.jpg', title: 'Dior', price: '\$49.99'),
  ];

  List<Product> filteredProducts = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    filteredProducts = products; // Initially, all products are visible
  }

  void _searchProduct(String query) {
    setState(() {
      filteredProducts = products
          .where((product) => product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Découvrez nos produits de beauté!',
          style: TextStyle(
            color: Color.fromARGB(255, 202, 21, 21),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _selectedIndex == 0
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Rechercher des produits...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: _searchProduct,
                    ),
                  ),
                  filteredProducts.isEmpty
                      ? const Center(child: Text('Aucun produit trouvé'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: filteredProducts.map((product) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ProductCard(
                                  image: product.image,
                                  title: product.title,
                                  price: product.price,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ],
              ),
            )
          : Center(
              child: Text(
                'Page ${_selectedIndex == 1 ? "Panier" : "Profil"}', // Exemple de contenu
                style: const TextStyle(fontSize: 24),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class Product {
  final String image;
  final String title;
  final String price;

  Product({required this.image, required this.title, required this.price});
}

class ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;

  const ProductCard({
    required this.image,
    required this.title,
    required this.price,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(image, height: 100, width: 100, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(price, style: const TextStyle(fontSize: 14, color: Colors.pink)),
          ),
        ],
      ),
    );
  }
}
