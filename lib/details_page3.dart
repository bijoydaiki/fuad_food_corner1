import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;



class HotDogPage extends StatelessWidget {
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
      home: HomePage(),
    );
  }
}

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

Future<List<Spacecraft>> downloadJSON() async {
  final jsonEndpoint =
      "https://raw.githubusercontent.com/johnriad/hot-dog/main/hot%20dog.json";

  final response = await get(Uri.parse(jsonEndpoint));

  if (response.statusCode == 200) {
    List spacecrafts = json.decode(response.body);
    return spacecrafts
        .map((spacecraft) => Spacecraft.fromJson(spacecraft))
        .toList();
  } else {
    throw Exception('Failed to load JSON data.');
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fuad Food Corner'),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))],
      ),
      body: FutureBuilder<List<Spacecraft>>(
        future: downloadJSON(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return FoodCard(spacecraft: snapshot.data![index]);
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

class FoodCard extends StatelessWidget {
  final Spacecraft spacecraft;

  FoodCard({required this.spacecraft});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SecondScreen(spacecraft: spacecraft),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                spacecraft.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(spacecraft.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("\$${spacecraft.propellant}",
                      style: TextStyle(fontSize: 16, color: Colors.green[700])),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  final Spacecraft spacecraft;

  SecondScreen({required this.spacecraft});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
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
      SnackBar(content: Text("Added to cart successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.spacecraft.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                widget.spacecraft.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text('FOOD DETAILS',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text(
              'NAME: ${widget.spacecraft.name}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'PRICE: \$${widget.spacecraft.propellant}',
              style: TextStyle(fontSize: 18, color: Colors.green[800]),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: decrement,
                  icon: Icon(Icons.remove_circle_outline),
                  iconSize: 30,
                  color: Colors.deepOrange,
                ),
                Text(
                  '$itemCount',
                  style: TextStyle(fontSize: 24),
                ),
                IconButton(
                  onPressed: increment,
                  icon: Icon(Icons.add_circle_outline),
                  iconSize: 30,
                  color: Colors.deepOrange,
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: addToCart,
              icon: Icon(Icons.shopping_cart),
              label: Text('ADD TO CART', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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
