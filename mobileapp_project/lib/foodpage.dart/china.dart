import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/product.dart';
import '../app/appstate.dart';
import 'package:mobileapp_project/app/wishprovider.dart';

class ChinaPage extends StatefulWidget {
  const ChinaPage({Key? key}) : super(key: key);

  @override
  State<ChinaPage> createState() => _ChinaPageState();
}

class _ChinaPageState extends State<ChinaPage> {
  
  @override
  void initState() {
    super.initState();
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    wishlistProvider.loadWishlistFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('중식'),
      ),
      body: Consumer<AppStatement>(
        builder: (context, appStatement, _) {
          final List<Product> products = appStatement.productFood;

          return ListView.builder(  
            itemCount: products.length,
            itemBuilder: (context, index) {
              final Product product = products[index];
              final bool isAddedToWishlist = wishlistProvider.wishlistItems
                    .any((item) => item.name == product.name);
              if (product.category == '중식') {
                
                return GestureDetector(
                  onTap: () {
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      child: ListTile(
                        leading: Image.network(
                          product.imageuri ??
                              'https://upload.wikimedia.org/wikipedia/commons/0/09/HGU-Emblem-eng2.png',
                        ),
                        title: Text(product.name!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('영업시간: ${product.time}'),
                            Text(
                              '평점: ${product.score}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text('주소: ${product.place}'),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            WishlistItem wishItem = WishlistItem(
                              name: product.name ?? '',
                              timestamp: Timestamp.now(),
                            );
                            setState(() {
                              if (isAddedToWishlist) {
                                wishlistProvider.removeItemFromWishlist(wishItem);
                              } else {
                                wishlistProvider.addItemToWishlist(wishItem);
                              }
                            });
                          },
                          icon: Icon(
                            isAddedToWishlist
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: isAddedToWishlist ? Colors.red : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                
                return  Container();
              }
            },
          );
        },
      ),
    );
  }
}
