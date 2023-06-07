import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'model/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app/appstate.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const List<String> dorplist = ['한식', '중식', '양식', '일식', '디저트'];

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({Key? key}) : super(key: key);

  @override
  _ProductAddPageState createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  File? _image;
  TextEditingController scoreController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final String defaultImage =
      "http://handong.edu/site/handong/res/img/logo.png";
  AppStatement appstate = AppStatement();
  late File? imageFiles;

  String selectedCategory = dorplist.first;
  String selectedTakeout = '';

  Future<void> _saveProduct(File? imageFile) async {
    final name = nameController.text;
    final price = priceController.text;
    final place = descriptionController.text;
    final userUid = FirebaseAuth.instance.currentUser!.uid;
    final category = selectedCategory;
    final takeout = selectedTakeout;
    final score = scoreController.text;
    try {
      String imageUri = defaultImage;

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      int productCount = querySnapshot.docs.length;
      int productId = (productCount + 1);

      if (imageFile != null) {
        imageUri = await appstate.uploadImageToStorage(imageFile, productId);
      }
      Product product = Product(
        category: category,
        id: productId,
        timestamp: Timestamp.now(),
        imageuri: imageUri,
        name: name,
        time: price,
        place: place,
        takeout: takeout,
        userid: userUid,
        score: double.tryParse(score),
      );
      await appstate.addProductToDatabase(product);
    } catch (error) {
      print('Failed to upload product: $error');
    }
    Navigator.pop(context);
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    scoreController.clear();
  }

  Future<void> _pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
      }
    } catch (e) {
      print("Image picker error: $e");
    }
  }

  Widget _buildCategoryButton(
      String value, List<String> categoryname, Function(String?) onchanged) {
    return DropdownButton(
      value: value,
      items: categoryname.map((String categoryname) {
        return DropdownMenuItem<String>(
          value: categoryname,
          child: Text(categoryname),
        );
      }).toList(),
      onChanged: (newvalue) {
        setState(() {
          if (newvalue != null || newvalue != value) {
            value = newvalue!;
            selectedCategory = newvalue;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('음식점 추가'),
        actions: [
          TextButton(
            onPressed: () {
              nameController.clear();
              priceController.clear();
              descriptionController.clear();
              Navigator.pop(context);
            },
            child: const Text(
              '취소',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _saveProduct(_image != null ? File(_image!.path) : null);
              });
            },
            child: const Text(
              '저장',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 20),
          Column(
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
                      ? const Icon(
                          Icons.photo,
                          size: 100,
                          color: Colors.grey,
                        )
                      : Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '음식점 이름',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: '영업시간',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: scoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '평점',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: '주소지',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedTakeout = "매장";
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedTakeout == "매장" ? Colors.blue : Colors.grey,
                ),
                child: Text("매장"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedTakeout = "포장";
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedTakeout == "포장" ? Colors.blue : Colors.grey,
                ),
                child: Text("포장"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCategoryButton(selectedCategory, dorplist, (value) {
                setState(() {
                  selectedCategory = value!;
                });
              }),
            ],
          ),
        ],
      ),
    );
  }
}
