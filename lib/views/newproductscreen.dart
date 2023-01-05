import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:homestay_raya/confiq.dart';

import '../models/user.dart';

class NewProductScreen extends StatefulWidget {
  final User user;
  final Position position;
  const NewProductScreen(
      {super.key,
      required this.user,
      required this.position,
      required placemarks});

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  late Position _position;

  final _prnameEditingController = TextEditingController();
  final _prdescEditingController = TextEditingController();
  final _prpriceEditingController = TextEditingController();
  final _guestEditingController = TextEditingController();
  final _prstateEditingController = TextEditingController();
  final _prlocalEditingController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool? _ischecked = false;
  var _lat, _lng;

  @override
  void initState() {
    super.initState();
    //_checkPermissionGetLoc();

    _lat = widget.position.latitude.toString();
    _lng = widget.position.longitude.toString();
    _getAddress();
    //_prstateEditingController.text =
    // widget.placemarks[0].admin
    //widget.placemarks[0].administrativeArea.toString();
    // _prlocalEditingController.text = widget.placemarks[0].locality.toString();
  }

  File? _image, _image1, _image2;
  var pathAsset = "assets/images/camera.png";
  var pathAsset1 = "assets/images/camera1.png";
  var pathAsset2 = "assets/images/camera2.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New HomeStay")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _selectImageDialog,
              child: Card(
                elevation: 8,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: _image == null
                        ? AssetImage(pathAsset)
                        : FileImage(_image!) as ImageProvider,
                    fit: BoxFit.scaleDown,
                  )),
                ),
              ),
            ),
            GestureDetector(
              onTap: _selectImageDialog,
              child: Card(
                elevation: 8,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: _image1 == null
                        ? AssetImage(pathAsset1)
                        : FileImage(_image1!) as ImageProvider,
                    fit: BoxFit.scaleDown,
                  )),
                ),
              ),
            ),
            const Text(
              "Add New HomeStay",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _prnameEditingController,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "Product name must be longer than 3"
                            : null,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'HomeStay Name',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _prdescEditingController,
                        validator: (val) => val!.isEmpty || (val.length < 10)
                            ? "Product description must be longer than 10"
                            : null,
                        maxLines: 2,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Product Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(
                              Icons.person,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _prpriceEditingController,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Price must contain value"
                                      : null,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Price',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.money),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _guestEditingController,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 0)
                                      ? "Should have a guest"
                                      : null,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Guest',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.people),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Must contain a states"
                                      : null,
                              enabled: false,
                              controller: _prstateEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'States',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.flag),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Should have a Location"
                                      : null,
                              controller: _prlocalEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Location',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.place),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        child: const Text("ADD"),
                        onPressed: () => {
                          _newProductDialog(),
                        },
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  _newProductDialog() {
    if (_image == null) {
      Fluttertoast.showToast(
          msg: "Please take picture of your product/service",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_formkey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Insert this product/service?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertProduct();
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

  void _selectImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select picture from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: _onCamera,
                    icon: const Icon(Icons.camera_alt_rounded)),
                IconButton(onPressed: _onGallery, icon: const Icon(Icons.photo))
              ],
            ));
      },
    );
  }

  Future<void> _onCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);

      //_cropImage();
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  Future<void> _onGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image1 = File(pickedFile.path);
      //_cropImage();
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  _checkPermissionGetLoc() async {
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
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //print(_position.latitude);
    //print(_position.longitude);
    //_getAddress(_position);
  }

  _getAddress() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.position.latitude, widget.position.longitude);
    setState(() {
      //  String loc =
      //   "${placemarks[0].locality},${placemarks[0].administrativeArea},${placemarks[0].country}";
      //print(loc);
      _prstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      // prlat = _currentPosition.latitude.toString();
      _prlocalEditingController.text = placemarks[0].locality.toString();
      //String prlong = _currentPosition.longitude.toString();
    });
  }

  void insertProduct() {
    String _prname = _prnameEditingController.text;
    String _prdesc = _prdescEditingController.text;
    String _prprice = _prpriceEditingController.text;
    String _guest = _guestEditingController.text;
    String _state = _prstateEditingController.text;
    String _prlocal = _prlocalEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    String base64Image1 = base64Encode(_image1!.readAsBytesSync());

    http.post(Uri.parse("${Confiq.SERVER}/php/insert_product.php"), body: {
      "userid": widget.user.id,
      "prname": _prname,
      "prdesc": _prdesc,
      "prprice": _prprice,
      "guest": _guest,
      "state": _state,
      "local": _prlocal,
      "lat": _lat,
      "lon": _lng,
      "image": base64Image,
      "image1": base64Image1,
    }).then((response) {
      //print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
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
  }
}
