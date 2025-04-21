import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;



class PizzaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuad Food Corner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}

// Model
class Spacecraft {
  final String id;
  final String name, imageUrl, propellant;

  Spacecraft({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.propellant,
  });

  factory Spacecraft.fromJson(Map<String, dynamic> jsonData) {
    return Spacecraft(
      id: jsonData['id'],
      name: jsonData['name'],
      propellant: jsonData['propellant'],
      imageUrl: jsonData['imageurl'],
    );
  }
}

// API Call
Future<List<Spacecraft>> downloadJSON() async {
  final jsonEndpoint =
      "https://raw.githubusercontent.com/johnriad/pizza/main/pizza.json";
  final response = await get(Uri.parse(jsonEndpoint));

  if (response.statusCode == 200) {
    List spacecrafts = json.decode(response.body);
    return spacecrafts
        .map((spacecraft) => Spacecraft.fromJson(spacecraft))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fuad Food Corner'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          )
        ],
      ),
      body: FutureBuilder<List<Spacecraft>>(
        future: downloadJSON(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return FoodCard(food: snapshot.data![index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

// Food Card Widget
class FoodCard extends StatelessWidget {
  final Spacecraft food;

  FoodCard({required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => DetailScreen(food: food)),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                food.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    food.name,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${food.propellant}",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[800],
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Detail Screen
class DetailScreen extends StatefulWidget {
  final Spacecraft food;

  DetailScreen({required this.food});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int itemCount = 0;

  void increment() {
    setState(() {
      itemCount++;
    });
  }

  void decrement() {
    if (itemCount > 0) {
      setState(() {
        itemCount--;
      });
    }
  }

  void addToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Item added to cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                widget.food.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.food.name,
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Price: \$${widget.food.propellant}",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.green[800],
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: decrement,
                  icon: Icon(Icons.remove),
                  iconSize: 28,
                  color: Colors.deepOrange,
                ),
                Text(
                  '$itemCount',
                  style: TextStyle(fontSize: 22),
                ),
                IconButton(
                  onPressed: increment,
                  icon: Icon(Icons.add),
                  iconSize: 28,
                  color: Colors.deepOrange,
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: addToCart,
              icon: Icon(Icons.shopping_cart),
              label: Text(
                "Add to Cart",
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
