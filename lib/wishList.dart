import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/app/wishprovider.dart';

class Wishlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistStream = wishlistProvider.wishlistStream;

    return StreamBuilder<List<WishlistItem>>(
      stream: wishlistStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final wishlistItems = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              final item = wishlistItems[index];
              return ListTile(
                leading: const Icon(Icons.favorite),
                title: Text(item.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    wishlistProvider.removeItemFromWishlist(item);
                  },
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('데이터를 불러오는 중에 오류가 발생했습니다.');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
