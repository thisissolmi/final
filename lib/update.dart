import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'model/product.dart';
import 'app/appstate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpDatepage extends StatefulWidget {
  const UpDatepage({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  State<UpDatepage> createState() => _UpDatepageState();
}

class _UpDatepageState extends State<UpDatepage> {
  late TextEditingController _nameController;
  late TextEditingController _timeController;
  late TextEditingController _placeController;
  late TextEditingController _scoreController;
  late TextEditingController _phoneController;
  AppStatement appstate = AppStatement();
  final String defaultImage = "http://handong.edu/site/handong/res/img/logo.png";
  File? _image;
  late String? imageuri;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _timeController = TextEditingController(text: widget.product.time.toString());
    _placeController = TextEditingController(text: widget.product.place);
    _scoreController = TextEditingController(text: widget.product.score.toString());
    _phoneController = TextEditingController(text: widget.product.phoneNumber.toString());

    imageuri = widget.product.imageuri;
  }

  Future<void> _saveProduct(String? imageuri) async {
    final name = _nameController.text;
    final time = _timeController.text;
    final place = _placeController.text;
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final score = _scoreController.text;
    final phone = _phoneController.text;
    try {
      if (userUid != null) {
        Product productUpdate = Product(
          category: widget.product.category,
          id: widget.product.id,
          timestamp: Timestamp.now(),
          time: time,
          imageuri: imageuri,
          name: name,
          place: place,
          score: double.tryParse(score),
          phoneNumber: phone,
          takeout: widget.product.takeout,
          userid: userUid,
        );
        await appstate.updateProduct(productUpdate);
      } else {
        // userUid가 null인 경우 처리
      }
    } catch (error) {
      print(imageuri);
      print('Failed to upload product: $error');
    }

    Navigator.pop(context);
    _nameController.clear();
    _timeController.clear();
    _placeController.clear();
  }

  Future<void> updateStorage(File imageFile, int productId) async {
    if (widget.product.imageuri != null) {
      final storageRef = FirebaseStorage.instance.ref().child('productImages/${widget.product.id}.jpg');
      try {
        await storageRef.delete();
        print('Image deleted');
      } catch (e) {
        print('Error deleting image: $e');
      }
    }

    final imageUrl = await appstate.uploadImageToStorage(imageFile, productId);
    await _saveProduct(imageUrl);
    imageuri = imageUrl;
  }

  Future<void> _pickImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
      }
    } catch (e) {
      print("Image picker error: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    _placeController.dispose();
    _phoneController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit'),
        actions: [
          TextButton(
            onPressed: () async {
              if (_image != null) {
                await updateStorage(_image!, widget.product.id ?? 0);
              } else {
                await _saveProduct(imageuri);
              }
              Navigator.pushNamed(context, '/');
            },
            child: const Text('save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _image == null
                          ? Image.network(imageuri ?? defaultImage)
                          : Image.file(
                              File(_image!.path),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: '음식점 이름'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _timeController,
                    decoration: InputDecoration(labelText: '영업시간 '),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _placeController,
                    decoration: InputDecoration(labelText: '주소'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _scoreController,
                    decoration: InputDecoration(labelText: '평점'),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: '전화번호'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
