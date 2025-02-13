import 'package:flutter/material.dart';

class CryptoSearch extends SearchDelegate {
  final List<dynamic> cryptoData;

  CryptoSearch({required this.cryptoData});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = cryptoData.where((crypto) {
      final name = crypto['name'].toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    return results.isEmpty
        ? const Center(child: Text('No results found'))
        : ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final crypto = results[index];
              return ListTile(
                leading: Image.network(crypto['image'], width: 40),
                title: Text(crypto['name']),
                subtitle: Text('Price: \$${crypto['current_price']}'),
                trailing: Text(
                  '${crypto['price_change_percentage_24h']}%',
                  style: TextStyle(
                    color: crypto['price_change_percentage_24h'] >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = cryptoData.where((crypto) {
      final name = crypto['name'].toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final crypto = suggestions[index];
        return ListTile(
          onTap: () {
            query = crypto['name'];
            showResults(context);
          },
          leading: Image.network(crypto['image'], width: 40),
          title: Text(crypto['name']),
          subtitle: Text('Price: \$${crypto['current_price']}'),
        );
      },
    );
  }
}
