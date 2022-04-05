import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:resturant/constants/values.dart';
import 'package:resturant/model/cart_model.dart';
import 'package:resturant/model/food_model.dart';
import 'package:resturant/pages/user_profile.dart';
import 'package:resturant/widgets/cart_bottom_sheet.dart';
import 'package:resturant/widgets/food_card.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int value = 1;

  Future<FoodModel> foodModels;

  // Future<FoodModel> fetchAllFoods() async {
  //   var dio = Dio();
  //   dio.options.connectTimeout = 5000;
  //   print('krappa');
  //   try {
  //     var response = await dio.get('$BASE_URL/api/foods');
  //     return FoodModel.fromJson(response.data);
  //   } catch (e) {
  //     if (e is DioError) {
  //       print("Dio Error: " + e.message);
  //       throw SocketException(e.message);
  //     } else {
  //       print("Type error: " + e.toString());
  //       throw Exception(e.toString());
  //     }
  //   }
  // }

  showCart() {
    showModalBottomSheet(
      shape: roundedRectangle40,
      context: context,
      builder: (context) => CartBottomSheet(),
    );
  }

  viewProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UserProfilePage()),
    );
  }

  @override
  void initState() {
    // foodModels = fetchAllFoods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: <Widget>[
            buildAppBar(),
            buildFoodFilter(),
            Divider(),
            buildFoodList(),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar() {
    int items = 0;
    Provider.of<MyCart>(context).cartItems.forEach((cart) {
      items += cart.quantity;
    });
    return SafeArea(
      child: Row(
        children: <Widget>[
          Text('MENU', style: headerStyle),
          Spacer(),
          // IconButton(icon: Icon(Icons.person), onPressed: viewProfile),
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                // foodModels = fetchAllFoods();
                setState(() {});
              }),
          Stack(
            children: <Widget>[
              IconButton(icon: Icon(Icons.shopping_cart), onPressed: showCart),
              Positioned(
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(4),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: mainColor),
                  child: Text(
                    '$items',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFoodFilter() {
    return Container(
      height: 50,
      //color: Colors.red,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              selectedColor: mainColor,
              labelStyle: TextStyle(
                  color: value == index ? Colors.white : Colors.black),
              label: Text(FoodTypes.values[index].toString().split('.').last),
              selected: value == index,
              onSelected: (selected) {
                setState(() {
                  value = index;
                });
              },
            ),
          );
        }),
      ),
    );
  }

  Widget buildFoodList() {
    return Expanded(
      child: FutureBuilder<FoodModel>(
        future: foodModels,
        builder: (BuildContext context, snapshot) {
          // if (snapshot.hasData) {
          return GridView.count(
            childAspectRatio: 0.65,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            crossAxisCount: 2,
            physics: BouncingScrollPhysics(),
            children: [
              FoodCard(Food(
                  name: 'Salad recipes',
                  id: '1',
                  images: ['food.png'],
                  rating: 5,
                  price: 20,
                  v: 1,
                  shop: Shop(id: '1',name: 'Salad',email: 'asfewgrehttwd'),
                  description: 'Serve this vibrant salad with blue cheese as a light supper or side dish. Kale or chard will also work in place of the spring greens'))
            ],
          );
          // } else if (snapshot.hasError) {
          //   return Center(child: Text(snapshot.error.toString()));
          // }
          // return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
