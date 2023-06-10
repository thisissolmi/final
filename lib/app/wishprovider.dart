import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WishlistItem {
  final String name;
  final Timestamp timestamp;

  WishlistItem({required this.timestamp, required this.name});
}

class WishlistProvider extends ChangeNotifier {
  List<WishlistItem> _wishlistItems = [];
  ValueNotifier<List<WishlistItem>> wishlistItemsValue = ValueNotifier<List<WishlistItem>>([]);
  List<WishlistItem> get wishlistItems => _wishlistItems;
  final CollectionReference wishListRef = FirebaseFirestore.instance.collection('wishList');
  
  Stream<List<WishlistItem>> get wishlistStream =>
      wishListRef.snapshots().map((snapshot) => snapshot.docs.map((doc) {
            Map<String, dynamic> itemData = doc.data() as Map<String, dynamic>;
            return WishlistItem(
              timestamp: itemData['timestamp'],
              name: itemData['name'],
            );
    }).toList());

  Future<void> loadWishlistFromDatabase()async{
    QuerySnapshot querySnapshot = await wishListRef.get();
    _wishlistItems = querySnapshot.docs.map((doc) {
      Map<String, dynamic> itemData = doc.data() as Map<String, dynamic>;
      return WishlistItem(timestamp: itemData['timestamp'], name: itemData['name']);
    }).toList();
  }
  Future<void> addItemToWishlist(WishlistItem item) async {
    if (_wishlistItems.contains(item)) {
      return; // Skip adding if the item already exists
    }
    _wishlistItems.add(item);

    await  wishListRef.add({
        'name': item.name,
        'timestamp': item.timestamp,
      }
    );

    wishlistItemsValue.value = _wishlistItems;   
  }

  Future<void> removeItemFromWishlist(WishlistItem item) async{
    _wishlistItems.remove(item);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference wishListRef = firestore.collection('wishList');
    QuerySnapshot querySnapshot = await wishListRef.where('name', isEqualTo: item.name).get();
    if(querySnapshot.docs.isNotEmpty){
      await wishListRef.doc(querySnapshot.docs[0].id).delete();
    }
    notifyListeners();
  }
}