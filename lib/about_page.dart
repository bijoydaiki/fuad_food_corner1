
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
      ),
      body: Center(
        child: Text(
            "The Fuad Food Corner app is designed to make delicious food easily accessible to everyone. "
                "With a simple and user-friendly interface, customers can quickly browse the menu, place orders, "
                "and enjoy their favorite meals from the comfort of their home. The restaurant currently employs 10 dedicated staff members, "
                "including 3 skilled chefs who specialize in crafting mouth-watering dishes. "
                "We take pride in our efficient service and smooth control panel — there are no issues with placing or managing orders. "
                "In case of any concerns, you can easily reach out or file a complaint through the app. "

                "Fuad Food Corner is proudly located in Khulna and has earned a strong reputation for offering fun and flavorful food. "
                "Our menu includes 4 popular items that everyone loves: crispy Pizza, juicy Burgers, spicy Hotdogs, and refreshing Soft Drinks. "
                "Whether you're craving a quick snack or a full meal, Fuad Food Corner has something for you. "
                "We're committed to quality, hygiene, and making sure every bite brings a smile. 🍕🍔🌭🥤"
        ),

      ),
    );
  }
}