import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<dynamic> favoriteCryptoData;

  const FavoritesPage({super.key, required this.favoriteCryptoData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Coins'),
      ),
      body: favoriteCryptoData.isEmpty
          ? const Center(child: Text('No favorite coins added yet'))
          : ListView.builder(
              itemCount: favoriteCryptoData.length,
              itemBuilder: (context, index) {
                final crypto = favoriteCryptoData[index];
                return ListTile(
                  leading: Image.network(crypto['image'], width: 40),
                  title: Text(crypto['name']),
                  subtitle: Text('Price: \$${crypto['current_price']}'),
                );
              },
            ),
    );
  }
}
