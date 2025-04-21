import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;


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
      "https://raw.githubusercontent.com/johnriad/softdrink/main/softdrinks.json";

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

class Four extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riad Food Corner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Riad Food Corner'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart_outlined),
            )
          ],
        ),
        body: FutureBuilder<List<Spacecraft>>(
          future: downloadJSON(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Spacecraft> spacecrafts = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: spacecrafts.length,
                itemBuilder: (context, index) {
                  return FoodCard(spacecraft: spacecrafts[index]);
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
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
          MaterialPageRoute(builder: (_) => SecondScreen(spacecraft: spacecraft)),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  spacecraft.imageUrl,
                  height: 200,
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
                      spacecraft.name,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${spacecraft.propellant}",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
  int quantity = 0;

  void increment() => setState(() => quantity++);
  void decrement() => setState(() => quantity > 0 ? quantity-- : 0);

  void addToCart() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("✔ Added to cart successfully!"),
      backgroundColor: Colors.deepOrange,
      behavior: SnackBarBehavior.floating,
    ));
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
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.spacecraft.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 25),
            Text(
              'SOFT DRINK DETAILS',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 25),
            ListTile(
              leading: Icon(Icons.local_drink, color: Colors.deepOrange),
              title: Text("Name"),
              subtitle: Text(widget.spacecraft.name),
            ),
            ListTile(
              leading: Icon(Icons.monetization_on, color: Colors.green[700]),
              title: Text("Price"),
              subtitle: Text("\$${widget.spacecraft.propellant}"),
            ),
            SizedBox(height: 20),
            Text(
              'Quantity',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: decrement,
                  icon: Icon(Icons.remove_circle_outline),
                  iconSize: 32,
                  color: Colors.redAccent,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade300,
                  ),
                  child: Text(
                    '$quantity',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                IconButton(
                  onPressed: increment,
                  icon: Icon(Icons.add_circle_outline),
                  iconSize: 32,
                  color: Colors.green,
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: addToCart,
              icon: Icon(Icons.add_shopping_cart_rounded),
              label: Text("ADD TO CART"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
