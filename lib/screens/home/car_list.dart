import 'package:car_app/models/car.dart';
import 'package:car_app/models/user.dart';
import 'package:car_app/screens/home/car_tile.dart';
import 'package:car_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarList extends StatefulWidget {
  const CarList({super.key, required this.onlyFavourites});

  final bool onlyFavourites;

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  @override
  Widget build(BuildContext context) {
    final bool onlyFavourites = widget.onlyFavourites;

    final user = Provider.of<User?>(context);
    final cars = Provider.of<List<Car>>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
          UserData? userData;
          if (snapshot.hasData) {
            userData = snapshot.data!;
            for (Car car in cars) {
              if (userData!.favCars.any((element) => element == car.uid)) {
                car.isFav = true;
              } else {
                car.isFav = false;
              }
            }
          }

          if(onlyFavourites){
            cars.removeWhere((car) => !car.isFav);
          }

          return ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                return CarTile(car: cars[index], userData: userData);
              });
        });
  }
}
