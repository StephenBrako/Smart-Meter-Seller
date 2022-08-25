import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/buy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'hero_dialog_route.dart';



class Order extends StatefulWidget {


  @override
  _OrderState createState() {
    return _OrderState();
  }
}

class _OrderState extends State<Order> {

  String seller_username=" ";
  String seller_location=" ";
  String seller_status=" ";
  String seller_gps=" ";
  String seller_price=" ";
  String seller_power=" ";
  String seller_email=" ";
  double width = 0.0;
  double height = 0.0;
  String username_="";
  String Order_successful="0";
  String value;
  String power;
  ScrollController _controller;
  String username;
  _OrderState();

  launchcommand(command) async {
    await launch(command);
  }



  Future<void> previous() async {
    final prefs = await SharedPreferences.getInstance();
    final key1 = 'sn';
    final value_username = prefs.getString(key1) ?? 0;
    setState(() {
      username_ = "$value_username";
    });


  }


  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    return Scaffold(

      appBar: AppBar(

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Orders',
          style: TextStyle(color: Colors.amber),
        ),

        backgroundColor: Colors.transparent,
        elevation: 0.0,


        centerTitle: true,
      ),
      body:  AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Column(



                  children:[
                    Container(
                      height: height/1.3,
                      color: Colors.blueGrey,
                      padding: EdgeInsets.only(top: 10.0,),


                      child:  StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("history").where("seller",isEqualTo: username).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return new Padding(padding: EdgeInsets.only( bottom: 5,top: 5),
                              child: SizedBox(

                                child:  new ListView.builder(
                                  controller: _controller,
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot doc = snapshot.data.docs[index];


                                    return new Card(
                                        color:Colors.white,


                                        child:Padding(padding: EdgeInsets.all(10),
                                            child: Column(
                                              children: [

                                                Row(mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width: 5,),
                                                    CircleAvatar(
                                                      backgroundImage: AssetImage("assets/user.png"),
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Column(mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Buyer:"),
                                                        Text("Location:"),
                                                        Text("Price:"),
                                                        Text("Power:"),
                                                        Text("Amount Paid:"),
                                                        Text("Date Orderd:"),



                                                      ],
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Column(mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("${doc["username"]}"),
                                                        Text("${doc["location"]}"),
                                                        Text("${doc["power_purchased"]}kW"),
                                                        Text("£${doc["price"]} per kW"),
                                                        Text("${doc["amount_purchased"]}"),
                                                        Text("${doc["date_time"]}"),


                                                      ],
                                                    ),
                                                    SizedBox(width: 8,),


                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                Row(mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [

                                                    Container(
                                                      width:MediaQuery.of(context).size.width/4,
                                                      child:  ElevatedButton(onPressed:(){
                                                        setState(() {
                                                          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                                                            return buy(value: "${doc["seller"]}", price:" ${doc["price"]}", location: "${doc["location"]}",);
                                                          }));

                                                        });
                                                      }, child: Text("Approve")),
                                                    ),
                                                    SizedBox(width: 8,),

                                                    Container(
                                                      width:MediaQuery.of(context).size.width/4,
                                                      child:  ElevatedButton(onPressed:(){
                                                        setState(() {

                                                        });
                                                      },
                                                          style: ElevatedButton.styleFrom(
                                                            primary: Colors.redAccent, // background
                                                            onPrimary: Colors.white, // foreground
                                                          ),child: Text("Decline")),
                                                    ),
                                                    SizedBox(width: 8,),

                                                    Container(
                                                      width:MediaQuery.of(context).size.width/4,
                                                      child:  ElevatedButton(onPressed:(){
                                                        setState(() {

                                                        });
                                                      }, style: ElevatedButton.styleFrom(
                                                        primary: Colors.deepPurpleAccent, // background
                                                        onPrimary: Colors.white, // foreground
                                                      ),
                                                          child: Text("Send Email")),
                                                    ),

                                                  ],),

                                              ],
                                            )
                                        )

                                    );
                                  },


                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: Text("No data"),
                            );
                          }
                        },
                      ),



                    )]


              ),








            ],
          ),
        ),


      ),
    );
  }
  bool _running = true;
  Stream<String> _username() async* {
    // This loop will run forever because _running is always true
    while (_running) {
      await Future<void>.delayed(const Duration(seconds: 1));

      // This will be displayed on the screen as current time
      yield "$seller_username";
    }
  }

  Stream<String> _location() async* {
    // This loop will run forever because _running is always true
    while (_running) {
      await Future<void>.delayed(const Duration(seconds: 1));

      // This will be displayed on the screen as current time
      yield "$seller_location";
    }
  }
  Stream<String> _power() async* {
    // This loop will run forever because _running is always true
    while (_running) {
      await Future<void>.delayed(const Duration(seconds: 1));

      // This will be displayed on the screen as current time
      yield "$seller_power";
    }
  }
  Stream<String> _price() async* {
    // This loop will run forever because _running is always true
    while (_running) {
      await Future<void>.delayed(const Duration(seconds: 1));

      // This will be displayed on the screen as current time
      yield "$seller_price";
    }
  }
  Stream<String> _gps() async* {
    // This loop will run forever because _running is always true
    while (_running) {
      await Future<void>.delayed(const Duration(seconds: 1));

      // This will be displayed on the screen as current time
      yield "$seller_gps";
    }
  }
  Stream<String> _status() async* {
    // This loop will run forever because _running is always true
    while (_running) {
      await Future<void>.delayed(const Duration(seconds: 1));

      // This will be displayed on the screen as current time
      yield "$seller_status";
    }
  }


  void update_seller(username) async {
    print(username);
    final querySnapshot = await FirebaseFirestore.instance.collection("sellers").where("username",isEqualTo: username).get();

    for (var doc in querySnapshot.docs) {
      final messageUsername = doc.get('username');
      final messageLocation = doc.get('location');
      final messageGps = doc.get('gps');
      final messagePrice = doc.get('price');
      final messagePower = doc.get('max power');
      final messageStatus = doc.get('status');
      final messageEmail = doc.get('email');
      print(messageStatus);


      if (mounted) {
        setState(() {
        seller_username = messageUsername;
        seller_location = messageLocation;
        seller_gps =messageGps;
        seller_price = messagePrice;
        seller_power = messagePower;
        seller_status =messageStatus;
        seller_email = messageEmail;
      });
      }
    }
  }



}
