import 'dart:async';
import 'dart:io' as Io;
import 'dart:io';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class FileHelper {
  ///Retrieve local path for device
  Future<String> getImagesPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var imgDir = await new Directory(join("${directory.path}", "images"))
        .create(recursive: true);
    return imgDir.path;
  }

  Future<Io.File> saveImage(File file) async {
    var imageDir = await getImagesPath();
    var _extension = extension(file.path);
    Image? image = decodeImage(file.readAsBytesSync());
    var uuID = Uuid(options: {'grng': UuidUtil.cryptoRNG}).v4();
    return File(join('$imageDir', '$uuID$_extension'))
      ..writeAsBytesSync(encodePng(image!));
  }

  Future<void> deleteImage(String fileName) async {
    try {
      var imageDir = await getImagesPath();
      final file = File(join('$imageDir', '$fileName'));
      await file.delete();
    } catch (e) {
      print("deleteImage:$e");
      return;
    }
  }

  Future<File> getImageFile(String fileName) async {
    var imageDir = await getImagesPath();
    final file = File(join('$imageDir', '$fileName'));
    return file;
  }
}
