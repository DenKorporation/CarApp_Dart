import 'package:car_app/models/car.dart';

class User {
  final String uid;

  User({required this.uid});
}

class UserData {
  final String uid;
  final String firstname;
  final String lastname;
  final DateTime birthday;
  final String gender;
  final String address;
  final String phone;
  final String carCountry;
  final String carBody;
  final String carDrive;
  final String transmission;
  final List<String> favCars;

  UserData({
    required this.uid,
    required this.firstname,
    required this.lastname,
    required this.birthday,
    required this.gender,
    required this.address,
    required this.phone,
    required this.carCountry,
    required this.carBody,
    required this.carDrive,
    required this.transmission,
    required this.favCars,
  });
}
