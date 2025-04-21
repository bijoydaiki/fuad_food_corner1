import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';


class BurgerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Riad Food Corner',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
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

class HomePage extends StatelessWidget {
  Future<List<Spacecraft>> fetchData() async {
    final url = "https://raw.githubusercontent.com/johnriad/recycle/main/recycle.JSON";
    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((item) => Spacecraft.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riad Food Corner'),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
              Positioned(
                right: 10,
                top: 10,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.white,
                  child: Text(
                    '0',
                    style: TextStyle(fontSize: 12, color: Colors.deepOrange),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Spacecraft>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
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
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(spacecraft: spacecraft),
            ),
          );
        },
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    spacecraft.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${spacecraft.propellant}',
                    style: TextStyle(fontSize: 16, color: Colors.green[800]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final Spacecraft spacecraft;

  DetailScreen({required this.spacecraft});

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
      SnackBar(content: Text("Item added to cart!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.spacecraft.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.spacecraft.imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.spacecraft.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Price: \$${widget.spacecraft.propellant}',
              style: TextStyle(fontSize: 20, color: Colors.green[700]),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: decrement,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent),
                  child: Icon(Icons.remove),
                ),
                SizedBox(width: 20),
                Text(
                  '$itemCount',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: increment,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange),
                  child: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: addToCart,
                icon: Icon(Icons.shopping_cart_checkout),
                label: Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
