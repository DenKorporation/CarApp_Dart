import 'package:car_app/models/car.dart';
import 'package:car_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({required this.uid});

  final CollectionReference carsCollection =
      FirebaseFirestore.instance.collection('cars');

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUserData() async {
    return await userCollection.doc(uid).set({
      'firstname': '',
      'lastname': '',
      'birthday': DateTime.now(),
      'gender': 'Мужчина',
      'address': '',
      'phone': '',
      'carCountry': 'DE',
      'carBody': '',
      'carDrive': '',
      'transmission': '',
      'favouriteCars': [],
    });
  }

  Future updateUserData(
      String firstname,
      String lastname,
      DateTime birthday,
      String gender,
      String address,
      String phone,
      String carCountry,
      String carBody,
      String carDrive,
      String transmission) async {
    return await userCollection.doc(uid).update({
      'firstname': firstname,
      'lastname': lastname,
      'birthday': birthday,
      'gender': gender,
      'address': address,
      'phone': phone,
      'carCountry': carCountry,
      'carBody': carBody,
      'carDrive': carDrive,
      'transmission': transmission
    });
  }

  Future updateUserFavCars(List<String> favCars) async {
    return await userCollection.doc(uid).update({
      'favouriteCars': favCars,
    });
  }

  Future deleteUserData() async {
    return await userCollection.doc(uid).delete();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid!,
        firstname: snapshot['firstname'],
        lastname: snapshot['lastname'],
        birthday: DateTime.fromMicrosecondsSinceEpoch(
            (snapshot['birthday'] as Timestamp).microsecondsSinceEpoch),
        gender: snapshot['gender'],
        address: snapshot['address'],
        phone: snapshot['phone'],
        carCountry: snapshot['carCountry'],
        carBody: snapshot['carBody'],
        carDrive: snapshot['carDrive'],
        transmission: snapshot['transmission'],
        favCars: (snapshot['favouriteCars'] as List).map((item) => item as String).toList());
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  List<Car> _carListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) {
          if (doc.data() == null) {
            return null;
          } else {
            return Car(
                uid: doc.id,
                name: doc['name'],
                years: doc['years'],
                description: doc['description'],
                country: doc['country'],
                body: doc['body'],
                drive: doc['drive'],
                transmission: doc['transmission']);
          }
        })
        .where((element) => element != null)
        .cast<Car>()
        .toList();
  }

  Stream<List<Car>> get cars {
    return carsCollection.snapshots().map(_carListFromSnapshot);
  }
}
