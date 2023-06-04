import 'package:flutter/material.dart';
import 'wishList.dart';
import 'ramdon.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
     String page;
   
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // title text center에 위치하게 끔하는 파라미터
        title: const Text('오 먹', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(onPressed:() => Navigator.pushNamed(context, '/add'), icon: const Icon(Icons.add))
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children:[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Stack(
                children:[
                  Container(
                  height: 350,
                  width: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                    ),  
                  ),
                  const Positioned(
                    left: 135,
                    child: Text('좋아요', style: TextStyle(fontWeight: FontWeight.bold),)
                    ,),
                  Positioned(
                    bottom: 25,
                    left: 24,
                    child: Container(
                      decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ), 
                      height: 300,
                      width: 250,
                      child: Wishlist(),
                    ),
                  ),
                ] 
              ),
            ),
          ),
          const SizedBox(height: 20,),
          const RandomFoodState(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Main',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '한식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '중식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '양식',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
            switch (selectedIndex) {
              case 0:
                page = '/';
              case 1:
                page = '/Kor';
                break;
              case 2:
                page = '/china';
                break;
              case 3:
                page = '/us';
                break;
              default:
                throw UnimplementedError('no widget for $selectedIndex');
            }
            Navigator.pushNamed(context, page);
            selectedIndex = 0;
          });
        },
      ),
    );
  }
}