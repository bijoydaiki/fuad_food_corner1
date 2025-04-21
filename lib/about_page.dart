
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
        child: Text("The Fuad Food Corner app is basically made available to people. "
            "Everyone can easily order food using the app. Our restaurant has 10 employees."
            " There are 3 chefs who prepare delicious food. There is no problem with the control panel. "
            "You can complain wherever you want.It is located in Khulna. Which gained a reputation for fun food"),
      ),
    );
  }
}