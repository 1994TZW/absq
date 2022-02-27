import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:absq/helper/theme.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import '../file_helper.dart';
import '../local_progress.dart';
import 'crop_util.dart';

class CropExtPage extends StatefulWidget {
  final File file;

  const CropExtPage({Key? key, required this.file}) : super(key: key);
  @override
  _CropExtPageState createState() => _CropExtPageState();
}

class _CropExtPageState extends State<CropExtPage> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LocalProgress(
      inAsyncCall: _isLoading,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Row(
                children: [
                  Container(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      color: primaryColor,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: _cropImage,
                      icon: const Icon(Icons.save),
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ExtendedImage.file(
                  widget.file,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.editor,
                  enableLoadState: true,
                  extendedImageEditorKey: editorKey,
                  cacheRawData: true,
                  initEditorConfigHandler: (ExtendedImageState? state) {
                    return EditorConfig(
                        cropRectPadding: const EdgeInsets.all(20.0),
                        hitTestSize: 20.0,
                        initCropRectType: InitCropRectType.imageRect,
                        cropAspectRatio: CropAspectRatios.custom,
                        editActionDetailsIsChanged:
                            (EditActionDetails? details) {
                          print(details?.totalScale);
                        });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.crop_rotate_outlined),
                    tooltip: 'Rotate',
                    onPressed: () {
                      editorKey.currentState!.rotate(right: true);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    setState(() {
      _isLoading = true;
    });
    File? _file;
    try {
      final Uint8List fileData = Uint8List.fromList(kIsWeb
          ? (await cropImageDataWithDartLibrary(
              state: editorKey.currentState!))!
          : (await cropImageDataWithNativeLibrary(
              state: editorKey.currentState!))!);
      img.Image? image = img.decodeImage(fileData);

      String imgDir = await FileHelper().getImagesPath();
      var uuid = const Uuid(options: {'grng': UuidUtil.cryptoRNG});
      _file = File(path.join('$imgDir', uuid.v4() + '.jpg'));
      _file.writeAsBytesSync(img.encodeJpg(image!, quality: 80));
      // _file.writeAsBytesSync(fileData);
    } on Exception catch (e) {
      print("err:$e");
    } finally {
      Navigator.of(context).pop(_file);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
