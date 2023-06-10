import 'package:flutter/material.dart';
import 'update.dart';
import 'model/product.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Detailpage extends StatefulWidget {
  const Detailpage({
    super.key,
    required this.product,
  });
  final Product product;
  @override
  State<Detailpage> createState() => _DetailpageState();
}

class _DetailpageState extends State<Detailpage> {
  String defaulturi =
      'https://upload.wikimedia.org/wikipedia/en/c/c8/HGUseal.png';
  late final Product product = widget.product;
  Future<void> PhoneCall(String phoneNumber) async {
    String number = phoneNumber;
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    if (!res!) {
      print('전화 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(product.name ?? ''),
        actions: [
          TextButton(
            child: Text(
              '수정',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpDatepage(product: widget.product)),
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.product.imageuri ?? defaulturi,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  '카테고리: ${widget.product.category ?? ''}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.phone,
                      ),
                      onPressed: () {
                        if (widget.product.phoneNumber != null) {
                          PhoneCall(widget.product.phoneNumber!);
                        }
                      },
                    ),
                    Text(
                      '${widget.product.phoneNumber ?? '등록된 전화번호가 없습니다.'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.home,
                      ),
                    ),
                    Text(
                      '${widget.product.place ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.timelapse_outlined,
                      ),
                    ),
                    Text(
                      '${widget.product.time ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                    ),
                    Text(
                      '${widget.product.score ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
