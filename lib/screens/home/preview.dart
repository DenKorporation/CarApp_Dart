import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_app/shared/constants.dart';
import 'package:car_app/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PreviewImage extends StatelessWidget {
  const PreviewImage({super.key, required this.path});

  final String path;

  Future<String?> getFileUrl(String firebasePath) async {
    try {
      final downloadURL = await FirebaseStorage.instance.ref(firebasePath);
      return await downloadURL.getDownloadURL();
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
      return null;
    }
  }

  Widget _loading() {
    return const SizedBox(
      height: 50,
      width: 50,
      child: SpinKitChasingDots(
        color: primaryColor,
        size: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFileUrl(path),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            return CachedNetworkImage(
              imageUrl: snapshot.data!,
              height: 50,
              placeholder: (context, url) => _loading(),
              errorWidget: (context, url, error) => SvgPicture.asset('assets/car_logo.svg', height: 50),
            );
          } else if (snapshot.error != null || snapshot.data == null) {
            return SvgPicture.asset('assets/car_logo.svg', height: 50);
          }
        }
        return _loading();
      },
    );
  }
}
