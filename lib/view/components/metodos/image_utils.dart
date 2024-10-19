import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImagesUtils {
  Uint8List? _imageUint8List;

  Uint8List? get imageUint8List => _imageUint8List;

  set imageUint8List(Uint8List? value) {
    _imageUint8List = value;
  }

  Uint8List? _imageCompressimageUint8List;
  File? _imageFile;
  XFile? _xFile;

  Uint8List? get imageCompressimageUint8List => _imageCompressimageUint8List;

  set imageCompressimageUint8List(Uint8List? value) {
    _imageCompressimageUint8List = value;
  }

  File? get imageFile => _imageFile;

  set imageFile(File? value) {
    _imageFile = value;
  }

  XFile? get xFile => _xFile;

  set xFile(XFile? value) {
    _xFile = value;
  }

  Future<Uint8List?> compressFile(XFile file) async {
    Uint8List? result;
    try {
      result = await FlutterImageCompress.compressWithFile(
        file.path,
        quality: 69,
      );
      return result;
    } on UnsupportedError catch (e) {
      print("UnsupportedError");
      print(e.message);
      return null;
    } on Error catch (e) {
      print("Error");
      print(e.toString());
      print(e.stackTrace);
      return null;
    } on Exception catch (e) {
      print("Exception");
      print(e.toString());
      return null;
    }
  }
}
