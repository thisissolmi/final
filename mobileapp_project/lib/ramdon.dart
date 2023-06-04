import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/appstate.dart';
import 'model/product.dart';


class RandomFoodState extends StatefulWidget {
  const RandomFoodState({Key? key});

  @override
  State<RandomFoodState> createState() => _RandomFoodStateState();
}

class _RandomFoodStateState extends State<RandomFoodState> {
  AppStatement appStatement = AppStatement();

  @override
  void initState() {
    super.initState();
    appStatement.init();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appStatement,
      child: Consumer<AppStatement>(
        builder: (context, appStatement, _) {
          Product? recommendedFood = appStatement.getRandomFoodItem();

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  recommendedFood == null
                      ? '버튼을 클릭하여 음식을 추천받으세요!'
                      : '추천 음식: ${recommendedFood!.name}',
                  style: const TextStyle(fontSize: 20),
                ),
                IconButton(
                  onPressed:(){ 
                    setState(() {
                      recommendedFood = appStatement.getRandomFoodItem();
                    });
                  }, 
                  icon: const Icon(Icons.favorite),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
