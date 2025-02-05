import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }

  void _searchProduct(String query) {
    setState(() {
      filteredProducts = products
          .where((product) => product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _ajouterProduit(String title, String price, String image) async {
    final url = Uri.parse("http://ton-serveur/ajouter_produit.php");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nom": title,
        "description": "Description du produit",
        "prix": double.parse(price),
        "image": image,
        "stock": 10,
        "categorie": "Beauté",
      }),
    );
    if (response.statusCode == 200) {
      print("Produit ajouté avec succès");
    } else {
      print("Erreur: ${response.body}");
    }
  }

  void _ouvrirFormulaireAjout() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un produit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Nom du produit')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Prix')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              _ajouterProduit(titleController.text, priceController.text, 'asset/default.png');
              Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Découvrez nos produits de beauté!'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _ouvrirFormulaireAjout),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher des produits...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: _searchProduct,
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('Aucun produit trouvé'))
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: Image.asset(product.image, width: 50, height: 50, fit: BoxFit.cover),
                          title: Text(product.title),
                          subtitle: Text(product.price),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                  ),
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
