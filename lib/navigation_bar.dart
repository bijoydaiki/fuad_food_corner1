import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuad_food_corner/details_page.dart';
import 'package:fuad_food_corner/details_page2.dart';
import 'package:fuad_food_corner/details_page3.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about_page.dart';
import 'details_page4.dart';


class NavigationBar_Page extends StatefulWidget {
  const NavigationBar_Page({Key? key}) : super(key: key);

  @override
  _NavigationBar_PageState createState() => _NavigationBar_PageState();
}

class _NavigationBar_PageState extends State<NavigationBar_Page> {
  var page=0;
  final pages=[
    BurgerPage(),
    PizzaPage(),
    HotDogPage(),
    Four(),
  ];
  @override
  Widget build(BuildContext context) {
    //GlobalKey<ScaffoldState> gb=GlobalKey<ScaffoldState>();
    return Scaffold(
      // key: gb,
      drawer: Drawer(  child: ListView(
        children: [
          Image.asset("images/dr.jpg",),
          DrawerHeader(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.max,
            /* children: [
             // Image.asset("images/riad.jpg",height: 100,width: double.infinity,),
              SizedBox(height: 20,),
              Text("This is Riad"),
            ],*/
          )),
          ListTile(
            leading: Icon(Icons.info_outline),
            tileColor: Colors.orange,
            title: Text("About Food Corner"),
            onTap: () {
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs(),));
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_phone),
            tileColor: Colors.orange,
            title: Text("Contact Us"),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.mail_outline),
            tileColor: Colors.orange,
            title: Text("Mail Me"),
            onTap: () {
              launch('mailto:riadrayhan.cse@gmail.com');
            },
          ),
          ListTile(
            leading: Icon(Icons.call),
            tileColor: Colors.orange,
            title: Text("Call me"),
            onTap: () {
              launch('tel://01610473706');
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            tileColor: Colors.orange,
            title: Text("Share"),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.star_rate_outlined),
            tileColor: Colors.orange,
            title: Text("Rate"),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.report_off_outlined),
            tileColor: Colors.orange,
            title: Text("Report"),
            onTap: () {
            },
          ),
        ],
      ),),
      /*appBar: AppBar(
        leading: IconButton(onPressed: () {
          gb.currentState!.openDrawer();
        }, icon: Icon(Icons.call)),
      ),*/
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        animationCurve: Curves.easeInOut,
        color: Colors.deepOrangeAccent,
        backgroundColor: Colors.lightGreenAccent,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            page=index;
          });
        },

        items:
        [
          Icon(Icons.food_bank_outlined),
          Icon(Icons.food_bank_outlined),
          Icon(Icons.food_bank_outlined),
          Icon(Icons.no_drinks_outlined),
        ],

      ),
      body: pages[page],
    );
  }
}