import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/product.dart';
import '../user/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';

class AppStatement extends ChangeNotifier {
  AppStatement() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  String? fileName;

  StreamSubscription<QuerySnapshot>? _productSubscription;
  List<Product> _productMessages = [];
  List<Product> get productFood => _productMessages;
  StreamSubscription<QuerySnapshot>? get productSubscription => _productSubscription;

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _productSubscription = FirebaseFirestore.instance
            .collection('products')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _productMessages = [];
          for (final document in snapshot.docs) {
            print("데이터가 올바르게 있습니다");
            final category = document.data()['category'] as String?;
            if (category == '한식' || category == '중식' || category == '양식') {
              final id = document.data()['id'];
              final timestamp = document.data()['timestamp'] as Timestamp?;
              final name = document.data()['name'] as String?;
              final time = document.data()['time'] as String?;
              final content = document.data()['content'] as String?;
              final imageuri = document.data()['imageUri'] as String?;
              final userid = document.data()['userId'] as String?;
              final takeout = document.data()['takeout'] as String?;
              final score = document.data()['score'] as double?;
              _productMessages.add(
                Product(
                  id: id,
                  timestamp: timestamp,
                  name: name,
                  time: time,
                  place: content,
                  imageuri: imageuri,
                  userid: userid,
                  category: category,
                  takeout: takeout,
                  score: score,
                ),
              );
            }
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _productMessages = [];
        _productSubscription?.cancel();
        notifyListeners();
      }
    });
  }

  Stream<List<Product?>> get productsStream {
    return FirebaseFirestore.instance
        .collection('products')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final category = doc['category'] as String?;
        if (category == '한식' || category == '중식' || category == '양식') {
          final id = doc['id'];
          final timestamp = doc['timestamp'] as Timestamp?;
          final name = doc['name'] as String?;
          final time = doc['time'];
          final content = doc['content'] as String?;
          final imageuri = doc['imageUri'] as String?;
          final userid = doc['userId'] as String?;
          final takeout = doc['takeout'] as String?;
          final score = doc['score'] as double?;
          return Product(
            id: id,
            timestamp: timestamp,
            name: name,
            time: time,
            place: content,
            imageuri: imageuri,
            userid: userid,
            category: category,
            takeout: takeout,
            score: score,
          );
        } else {
          return null;
        }
      }).where((product) => product != null).toList();
    });
  }

  Future<UserCredential> signInWithAnonymously() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final UserCredential userCredential = await _auth.signInAnonymously();
    final User user = userCredential.user!;
    if (user != null) {
      _loggedIn = true;
      final String uid = user.uid;

      final DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(uid);
      await userRef.set({
        'name': 'Guest',
        'uid': user.uid,
      });
    }
    AnonymousUser(name: 'Guest', userId: user.uid,);

    notifyListeners();
    return userCredential;
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      try {
        print('_loggedIn: $_loggedIn');
        this._loggedIn = true;
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final userUid = FirebaseAuth.instance.currentUser!;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(googleUser.id)
            .set(
          {
            'name': googleUser.displayName,
            'email': googleUser.email,
            'userid': userUid.uid,
            'userPhotoUrl': googleUser.photoUrl,
          },
          SetOptions(merge: true),
        );

        GoolgeUser(
          name: googleUser.displayName!,
          googleUserId: googleUser.email,
        );
        notifyListeners();
        return userCredential;
      } catch (e) {
        print('Error signing in with Google: $e');
        return null;
      }
    }

    return null;
  }

  Future<void> addProductToDatabase(Product product) async {
    if (!_loggedIn) {
      throw Exception('로그인이 필요합니다.');
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference productsRef = firestore.collection('products');

    await productsRef.add({
      'id': product.id,
      'timestamp': product.timestamp,
      'imageUri': product.imageuri,
      'name': product.name,
      'time': product.time,
      'content': product.place,
      'userId': product.userid,
      'category': product.category,
    });
  }

  Future<void> deleteProduct(Product product) async {
    if (!_loggedIn) {
      throw Exception('로그인이 필요합니다.');
    }

    final db = FirebaseFirestore.instance.collection('products');
    QuerySnapshot querySnapshot =
        await db.where('id', isEqualTo: product.id).get();

    if (querySnapshot.docs.isNotEmpty) {
      await db.doc(querySnapshot.docs[0].id).delete();
      print('데이터가 삭제되었습니다.');
    }

    if (product.imageuri != null) {
      final storageRef =
          FirebaseStorage.instance.ref().child('productImages/${product.id}.jpg');
      try {
        await storageRef.delete();
        print('이미지가 삭제되었습니다.');
      } catch (e) {
        print('이미지 삭제 중 오류가 발생했습니다: $e');
      }
    }

    _productMessages.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (!_loggedIn) {
      throw Exception('로그인이 필요합니다.');
    }

    final db = FirebaseFirestore.instance.collection('products');
    QuerySnapshot querySnapshot =
        await db.where('id', isEqualTo: product.id).get();

    if (querySnapshot.docs.isNotEmpty) {
      await db.doc(querySnapshot.docs[0].id).update({
        'updatetime': FieldValue.serverTimestamp(),
        'imageuri': product.imageuri,
        'name': product.name,
        'time': product.time,
        'content': product.place,
        'timestamp': product.timestamp,
      });
    }
  }
  Product? getRandomFoodItem() {
    if (_productMessages.isEmpty) {
      return null;
    }

    final randomIndex = Random().nextInt(_productMessages.length);
    return _productMessages[randomIndex];
  }

  Future<String> uploadImageToStorage(File imageFile, int id) async {
    if (imageFile != null) {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('productImages/$id.jpg');

      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      String? imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl!;
    } else {
      return 'http://handong.edu/site/handong/res/img/logo.png';
    }
  }
}
