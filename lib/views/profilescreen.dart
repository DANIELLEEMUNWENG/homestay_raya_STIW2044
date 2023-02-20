import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:homestay_raya/models/user.dart';
import 'package:homestay_raya/views/detailsscreen.dart';
import 'package:homestay_raya/views/loginscreen.dart';
import 'package:homestay_raya/views/mainscreen.dart';
import 'package:homestay_raya/views/newproductscreen.dart';
import 'package:homestay_raya/views/updatescreen.dart';
import 'package:http/http.dart' as http;
import 'package:homestay_raya/confiq.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'signupscreen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  var _lat, _lng;
  late Position _position;
  List<Product> productList = <Product>[];
  String titlecenter = "Loading...";
  var placemarks;
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile '),
          actions: [
            IconButton(onPressed: _loginform, icon: const Icon(Icons.login)),
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Add New HomeStay"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                _gotoNewProduct();
                print("My account menu is selected.");
              } else if (value == 1) {
                print("Settings menu is selected.");
              } else if (value == 2) {
                print("Logout menu is selected.");
              }
            }),
          ],
        ),
        body: productList.isEmpty
            ? Center(
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
            : Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(productList.length, (index) {
                        return Card(
                            elevation: 8,
                            child: InkWell(
                              onTap: () {
                                _showDetails(index);
                              },
                              onLongPress: () {
                                _deleteDialog(index);
                              },
                              child: Column(children: [
                                Flexible(
                                  flex: 6,
                                  child: CachedNetworkImage(
                                    width: 150 / 2,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${Confiq.SERVER}/assets/productimages/${productList[index].productId}.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Flexible(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            (productList[index]
                                                .productName
                                                .toString()),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              "RM ${double.parse(productList[index].productPrice.toString()).toStringAsFixed(2)}"),
                                        ],
                                      ),
                                    ))
                              ]),
                            ));
                      }),
                    ),
                  )
                ],
              ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 204, 255, 229)),
                accountEmail: const Text('',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0,
                            0))), // keep blank text because email is required
                accountName: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 150,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: const CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        child: Icon(
                          Icons.check,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          'user',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        Text(
                          '@User',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => MainScreen(
                                user: User(
                                    id: "id",
                                    name: "name",
                                    email: "email",
                                    phone: "phone",
                                    address: "address",
                                    regdate: "regdate"),
                              )));
                },
              ),
              ListTile(
                title: const Text('Sign Up'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (content) => const SignUp()));
                },
              ),
              ListTile(
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => ProfileScreen(
                                user: User(
                                    id: "id",
                                    name: "name",
                                    email: "email",
                                    phone: "phone",
                                    address: "address",
                                    regdate: "regdate"),
                              )));
                },
              ),
              ListTile(
                title: const Text('Update Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => UpdateScreen(
                              user: User(
                                  id: "id",
                                  name: "name",
                                  email: "email",
                                  phone: "phone",
                                  address: "address",
                                  regdate: "regdate"))));
                },
              ),
            ],
          ),
        ));
  }

  void _loginform() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const Login()));
  }

  Future<void> _gotoNewProduct() async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please login/register",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);

      return;
    }

    if (await _checkPermissionGetLoc()) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewProductScreen(
                  position: _position,
                  user: widget.user,
                  placemarks: placemarks)));
      _loadProducts();
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

//check permission,get location,get address return false if any problem.
  Future<bool> _checkPermissionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    try {
      placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Error in fixing your location. Make sure internet connection is available and try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return false;
    }
    return true;
  }

  void _loadProducts() {
    if (widget.user.id == "0") {
      //check if the user is registered or not
      Fluttertoast.showToast(
          msg: "Please register an account first", //Show toast
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);

      setState(() {});
      return; //exit method if true l
    }
    http
        .get(Uri.parse(
            "${Confiq.SERVER}/php/localprofileproduct.php?userid=${widget.user.id}"))
        .then((response) {
      // wait for response from the request
      if (response.statusCode == 200) {
        //if statuscode OK
        var jsondata =
            jsonDecode(response.body); //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array
          if (extractdata['products'] != null) {
            //check if  array object is not null
            productList = <Product>[]; //complete the array object definition
            extractdata['products'].forEach((v) {
              //traverse products array list and add to the list object array productList
              productList.add(Product.fromJson(v));
              //add each product array to the list object array productList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "Not Product Available"; //if no data returned show title center
            productList.clear();
          }
        } else {
          titlecenter = "Not Product Available";
        }
      } else {
        titlecenter = "No Product Available"; //status code other than 200
        productList.clear(); //clear productList array
      }
      setState(() {}); //refresh UI
    });
  }

  Future<void> _showDetails(int index) async {
    Product product = Product.fromJson(productList[index].toJson());

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => DetailsScreen(
                  product: product,
                  user: widget.user,
                )));
    _loadProducts();
  }

  _deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Delete ${truncateString(productList[index].productName.toString(), 15)}",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteProduct(index);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(index) {
    try {
      http.post(Uri.parse("${Confiq.SERVER}/php/delete_product.php"), body: {
        "productname": productList[index].productName,
      }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadProducts();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  truncateString(String string, int i) {}
}
