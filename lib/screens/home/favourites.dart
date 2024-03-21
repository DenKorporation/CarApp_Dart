import 'package:car_app/models/car.dart';
import 'package:car_app/screens/home/car_list.dart';
import 'package:car_app/screens/home/home.dart';
import 'package:car_app/screens/home/settings.dart';
import 'package:car_app/screens/wrapper.dart';
import 'package:car_app/services/authentication_service.dart';
import 'package:car_app/services/database_service.dart';
import 'package:car_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Favourites extends StatelessWidget {
  Favourites({super.key});

  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Car>>.value(
        value: DatabaseService(uid: null).cars,
        initialData: [],
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              leading: SvgPicture.asset('assets/car_logo.svg'),
              title: Text('Избранное'),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
              automaticallyImplyLeading: false,
              backgroundColor: primaryColor,
              actionsIconTheme: IconThemeData(),
              elevation: 0.0,
              actions: <Widget>[
                PopupMenuButton<MenuItem>(
                  color: primaryColor,
                  iconColor: secondaryColor,
                  onSelected: (MenuItem item) {
                    switch (item) {
                      case MenuItem.Home:
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                        break;
                      case MenuItem.Logout:
                        _auth.signOut();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Wrapper()));
                        break;
                      case MenuItem.Settings:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Settings()));
                        break;
                      case MenuItem.Favourites:
                        // TODO: Handle this case.
                        break;
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu, color: secondaryColor),
                      SizedBox(width: 10),
                      Text('Меню', style: TextStyle(color: secondaryColor)),
                      SizedBox(width: 20)
                    ],
                  ),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<MenuItem>>[
                    const PopupMenuItem<MenuItem>(
                      value: MenuItem.Home,
                      child: Row(
                        children: [
                          Icon(Icons.list, color: secondaryColor),
                          Text('Список',
                              style: TextStyle(color: secondaryColor)),
                        ],
                      ),
                    ),
                    const PopupMenuItem<MenuItem>(
                      value: MenuItem.Settings,
                      child: Row(
                        children: [
                          Icon(Icons.settings, color: secondaryColor),
                          Text('Профиль',
                              style: TextStyle(color: secondaryColor)),
                        ],
                      ),
                    ),
                    const PopupMenuItem<MenuItem>(
                      value: MenuItem.Logout,
                      child: Row(
                        children: [
                          Icon(Icons.door_front_door_outlined,
                              color: secondaryColor),
                          Text('Выйти',
                              style: TextStyle(color: secondaryColor)),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            body: Container(
                decoration: BoxDecoration(color: backgroundColor),
                child: CarList(onlyFavourites: true,)),
          );
        });
  }
}
