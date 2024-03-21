import 'package:car_app/models/car.dart';
import 'package:car_app/models/user.dart';
import 'package:car_app/screens/home/car_detailed.dart';
import 'package:car_app/screens/home/preview.dart';
import 'package:car_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarTile extends StatelessWidget {
  const CarTile({super.key, required this.car, required this.userData});

  final UserData? userData;
  final Car car;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    void _showCarDetailed() {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
              child: CarDetailed(car: car, folderPath: '${car.name}/detailed_photos',),
            );
          });
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          onTap: () {
            _showCarDetailed();
          },
          leading: SizedBox(
              height: 50,
              width: 100,
              child: PreviewImage(
                path: '${car.name}/preview.jpg',
              )),
          title: Text(car.name),
          subtitle: Text(car.years),
          trailing: IconButton(
            icon: Icon(car.isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              if (userData != null) {
                if (car.isFav) {
                  userData!.favCars.remove(car.uid);
                } else {
                  userData!.favCars.add(car.uid);
                }
                DatabaseService(uid: user!.uid)
                    .updateUserFavCars(userData!.favCars);
              }
            },
          ),
        ),
      ),
    );
  }
}
