import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_app/models/car.dart';
import 'package:car_app/shared/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarDetailed extends StatelessWidget {
  const CarDetailed({super.key, required this.car, required this.folderPath});

  final String folderPath;
  final Car car;

  Future<List<String>> _getDetailedFilesUrl(String firebasePath) async {
    try {
      List<String> result = [];
      final files =
          await FirebaseStorage.instance.ref(firebasePath).listAll();

      for (var file in files.items) {
        result.add(await file.getDownloadURL());
      }
      return result;
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
      return [];
    }
  }

  Widget _loading() {
    return const SizedBox(
      height: 150,
      width: 150,
      child: SpinKitChasingDots(
        color: primaryColor,
        size: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String transmission = car.transmission.replaceAll('/', '\n');
    String body = car.body.replaceAll('/', '\n');

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(car.name, style: TextStyle(fontSize: 20, color: textColor)),
          Text(car.years, style: TextStyle(fontSize: 17, color: textColor)),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 150,
            child: FutureBuilder(
              future: _getDetailedFilesUrl(folderPath),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return CarouselSlider(
                      options: CarouselOptions(height: 150.0),
                      items: snapshot.data!.map((url) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                                child: SizedBox(
                                  child: CachedNetworkImage(
                                    imageUrl: url,
                                    height: 150,
                                    placeholder: (context, url) => _loading(),
                                    errorWidget: (context, url, error) => SvgPicture.asset('assets/car_logo.svg', height: 150),
                                  ),
                                ));
                          },
                        );
                      }).toList(),
                    );
                  } else if (snapshot.error != null || snapshot.data!.isEmpty) {
                    return SvgPicture.asset('assets/car_logo.svg', height: 150);
                  }
                }
                return _loading();
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text('Описание', style: TextStyle(fontSize: 20, color: textColor)),
          Text(car.description,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 17, color: textColor)),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Страна', style: TextStyle(fontSize: 17, color: textColor)),
              Image.asset(
                'packages/country_code_picker/flags/${car.country.toLowerCase()}.png',
                height: 50,
                alignment: Alignment.centerRight,
              )
              // Text(car.country, style: TextStyle(fontSize: 17, color: textColor)),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Кузов', style: TextStyle(fontSize: 17, color: textColor)),
              Text(body,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 17, color: textColor)),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Привод', style: TextStyle(fontSize: 17, color: textColor)),
              Text(car.drive, style: TextStyle(fontSize: 17, color: textColor)),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Коробка передач',
                  style: TextStyle(fontSize: 17, color: textColor)),
              Text(transmission,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 17, color: textColor)),
            ],
          ),
        ],
      ),
    );
  }
}
