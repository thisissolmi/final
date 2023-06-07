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
        automaticallyImplyLeading: false,
        centerTitle: true, // title text center에 위치하게 끔하는 파라미터
        title: const Text('오 먹 ?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/add'),
              icon: const Icon(Icons.add))
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Stack(children: [
                Container(
                  height: 380,
                  width: 400,
                  decoration: BoxDecoration(
                    color: const Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                const Positioned(
                  left: 130,
                  top: 20,
                  child: Text(
                    '좋아요',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 300,
                    width: 290,
                    child: Wishlist(),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const RandomFoodState(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Main',
            // label: 'Main',
          ),
          BottomNavigationBarItem(
            icon: Text("🍚"),
            // icon: Icon(Icons.add_circle),
            label: '한식',
          ),
          BottomNavigationBarItem(
            icon: Text("🍜 "),
            // icon: Icon(Icons.add_circle),
            label: '중식',
          ),
          BottomNavigationBarItem(
            icon: Text("🍕"),
            // icon: Icon(Icons.add_circle),
            label: '양식',
          ),
          BottomNavigationBarItem(
            icon: Text("🍣"),
            // icon: Icon(Icons.add_circle),
            label: '일식',
          ),
          BottomNavigationBarItem(
            icon: Text("🍰"),
            // icon: Icon(Icons.add_circle),
            label: '디저트',
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
              case 4:
                page = '/Jp';
                break;
              case 5:
                page = '/Ds';
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
