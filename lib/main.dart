import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'search/crypto_search.dart';
import 'screens/line_chart_screen.dart';
import 'screens/favorites_page.dart'; // Import Favorites Page

void main() {
  runApp(const CryptoPriceApp());
}

class CryptoPriceApp extends StatefulWidget {
  const CryptoPriceApp({super.key});

  @override
  State<CryptoPriceApp> createState() => _CryptoPriceAppState();
}

class _CryptoPriceAppState extends State<CryptoPriceApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Prices',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: CryptoHomePage(
        toggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
        isDarkMode: isDarkMode, // Pass isDarkMode to CryptoHomePage
      ),
    );
  }
}

class CryptoHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode; // Add isDarkMode as a parameter

  const CryptoHomePage({
    required this.toggleTheme,
    required this.isDarkMode, // Require isDarkMode in the constructor
    super.key,
  });

  @override
  _CryptoHomePageState createState() => _CryptoHomePageState();
}

class _CryptoHomePageState extends State<CryptoHomePage> {
  List<dynamic> cryptoData = [];
  Set<String> favoriteCoins = {};

  @override
  void initState() {
    super.initState();
    fetchCryptoPrices();
  }

  // Fetch Crypto Prices from API
  Future<void> fetchCryptoPrices() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          cryptoData = json.decode(response.body);
        });
      } else {
        debugPrint('Failed to fetch data');
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  // Fetch Historical Prices for Line Chart
  Future<List<double>> fetchHistoricalPrices(String coinId) async {
    final url =
        'https://api.coingecko.com/api/v3/coins/$coinId/market_chart?vs_currency=usd&days=7';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> prices = data['prices'];
        return prices.map((pricePoint) => pricePoint[1] as double).toList();
      } else {
        throw Exception('Failed to fetch historical prices');
      }
    } catch (error) {
      debugPrint('Error fetching historical prices: $error');
      return [];
    }
  }

  // Add or Remove a Coin from Favorites
  void toggleFavorite(String id) {
    setState(() {
      if (favoriteCoins.contains(id)) {
        favoriteCoins.remove(id);
      } else {
        favoriteCoins.add(id);
      }
    });
  }

  // Sorting Functionality
  void sortData(String sortBy) {
    setState(() {
      if (sortBy == 'Price') {
        cryptoData.sort((a, b) =>
            a['current_price'].compareTo(b['current_price'])); // Sort by price
      } else if (sortBy == 'Name') {
        cryptoData
            .sort((a, b) => a['name'].compareTo(b['name'])); // Sort by name
      } else if (sortBy == 'Change') {
        cryptoData.sort((a, b) => b['price_change_percentage_24h']
            .compareTo(a['price_change_percentage_24h'])); // Sort by 24h change
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Prices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              final favoriteCryptoData = cryptoData
                  .where((crypto) => favoriteCoins.contains(crypto['id']))
                  .toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(
                    favoriteCryptoData: favoriteCryptoData,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CryptoSearch(cryptoData: cryptoData),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              sortData(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Price', child: Text('Sort by Price')),
              const PopupMenuItem(value: 'Name', child: Text('Sort by Name')),
              const PopupMenuItem(
                  value: 'Change', child: Text('Sort by % Change')),
            ],
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: cryptoData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cryptoData.length,
              itemBuilder: (context, index) {
                final crypto = cryptoData[index];
                return ListTile(
                  leading: Image.network(crypto['image'], width: 40),
                  title: Text(crypto['name']),
                  subtitle: Text('Price: \$${crypto['current_price']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${crypto['price_change_percentage_24h']}%',
                        style: TextStyle(
                          color: crypto['price_change_percentage_24h'] >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          favoriteCoins.contains(crypto['id'])
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: favoriteCoins.contains(crypto['id'])
                              ? Colors.red
                              : null,
                        ),
                        onPressed: () => toggleFavorite(crypto['id']),
                      ),
                    ],
                  ),
                  onTap: () async {
                    final historicalPrices =
                        await fetchHistoricalPrices(crypto['id']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LineChartScreen(
                          coinName: crypto['name'],
                          historicalPrices: historicalPrices,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
