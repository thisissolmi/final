import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  Product({
    required this.id,
    required this.name,
    required this.time,
    required this.place,
    required this.imageuri,
    required this.userid,
    required this.timestamp,
    required this.category,
    required this.takeout,
    required this.score,
    required this.phoneNumber,
  });
  final String? category;
  final int? id;
  final String? imageuri;
  final Timestamp? timestamp;
  final String? name;
  final String? time;
  final String? place;
  final String? takeout; 
  final String? userid;
  final double? score;
  final String? phoneNumber;
}



/*
 *String get assetName => '$id-0.jpg';
  String get assetPackage => 'shrine_images';
  @override
  String toString() => "$name (id=$id)";
 */