import 'dart:developer';
import 'dart:io';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/page/util.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../callbacks.dart';
import '../display_image_source.dart';
import '../file_helper.dart';
import '../local_text.dart';
import '../show_multiple_img.dart';
import 'crop_ext_page.dart';
import 'multi_img_controller.dart';

typedef OnFile = void Function(File);

const maxFileSizeKB = 2000;

class MultiImageFile extends StatefulWidget {
  final bool enabled;
  final MultiImgController controller;
  final Color? titleColor;
  final bool? isCrop;
  final String? titleKey;
  final double? fontSize;

  const MultiImageFile(
      {Key? key,
      required this.enabled,
      required this.controller,
      this.titleColor,
      this.isCrop = true,
      this.titleKey,
      this.fontSize})
      : super(key: key);
  @override
  _MultiImageFileState createState() => _MultiImageFileState();
}

class _MultiImageFileState extends State<MultiImageFile> {
  List<DisplayImageSource> fileContainers = [];
  @override
  void initState() {
    super.initState();
    fileContainers = widget.controller.fileContainers;
    widget.controller.onChange(() {
      if (!mounted) return;
      setState(() {
        fileContainers = widget.controller.fileContainers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LocalText(
              context,
              widget.titleKey!,
              color: primaryColor,
              fontSize: widget.fontSize,
            ),
            widget.titleKey != null ? const Spacer() : Container(),
            widget.enabled
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              if (Platform.isLinux ||
                                  Platform.isWindows ||
                                  Platform.isMacOS) {
                                _openImagePickerDesktop();
                              } else {
                                _openImagePicker(false);
                              }
                            },
                            child: Stack(
                              children: [
                                const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    MaterialCommunityIcons.image,
                                    color: primaryColor,
                                    size: 35,
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: actionIcon(
                                        color: Colors.green,
                                        iconData: Icons.add))
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (Platform.isLinux ||
                                  Platform.isWindows ||
                                  Platform.isMacOS) {
                                _openImagePickerDesktop();
                              } else {
                                _openImagePicker(true);
                              }
                            },
                            child: Stack(
                              children: [
                                const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    MaterialCommunityIcons.camera,
                                    color: primaryColor,
                                    size: 35,
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: actionIcon(
                                        color: Colors.green,
                                        iconData: Icons.add))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container()
          ],
        ),
        SizedBox(
          height: 100,
          child: ReorderableListView(
              scrollDirection: Axis.horizontal,
              onReorder: (o, n) {
                fileContainers.insert(n, fileContainers[o]);
                fileContainers.removeAt(o > n ? o + 1 : o);
                setState(() {});
              },
              children: List.generate(fileContainers.length,
                  (i) => _fileItem(fileContainers[i], i))),
        ),
      ],
    );
  }

  Widget _fileItem(DisplayImageSource img, int index) {
    return InkWell(
      key: ValueKey(img),
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => ShowMultiImage(
                  displayImageSources: fileContainers,
                  initialPage: index,
                )));
      },
      child: Stack(alignment: Alignment.topLeft, children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: primaryColor,
                width: 1.0,
              ),
            ),
            child: img.file == null
                ? CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    imageUrl: img.url!,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                      ],
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                // !File(img.url!).existsSync()
                //     ? const SizedBox(
                //         width: 50,
                //         height: 50,
                //         child: Icon(Icons.no_photography))
                //     : FittedBox(
                //         clipBehavior: Clip.antiAlias,
                //         fit: BoxFit.cover,
                //         child: Image.file(File(img.url!)),
                //       )
                : FittedBox(
                    clipBehavior: Clip.antiAlias,
                    fit: BoxFit.cover,
                    child: Image.file(img.file!, height: 50),
                  ),
          ),
        ),
        widget.enabled
            ? Positioned(
                top: 10,
                right: 0,
                child: actionIcon(
                  color: primaryColor,
                  iconData: Icons.remove,
                  onTap: () => _removeFile(img),
                ),
              )
            : Container(),
        widget.enabled && index == 0
            ? Positioned(
                top: 10,
                left: 0,
                child: actionIcon(
                  color: Colors.blue.shade300,
                  iconData: Icons.home,
                  onTap: () => _removeFile(img),
                ),
              )
            : Container(),
      ]),
    );
  }

  _openImagePicker(bool camera) async {
    var selectedFile = await ImagePicker().pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 1500);
    if (selectedFile != null) {
      File? _file = (widget.isCrop ?? true)
          ? await Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => CropExtPage(file: File(selectedFile.path))))
          : File(selectedFile.path);
      if (_file == null) return;
      int _size = _file.lengthSync();
      print("size:$_size");

      double sizeInkb = _size / 1024;
      if (sizeInkb > maxFileSizeKB) {
        showMsgDialog(context, "Error",
            "File Size is too large.File Size must be less than $maxFileSizeKB KB.Please select again image!");
        return;
      }
      _addFile(DisplayImageSource(), File(_file.path));
    }
  }

  _openImagePickerDesktop() async {
    log("_openImagePickerDesktop not implemented");
  }

  _addFile(DisplayImageSource fileContainer, File selectedFile) {
    fileContainer.file = selectedFile;
    setState(() {
      fileContainers.add(fileContainer);
      widget.controller.addFile = fileContainer;
    });
  }

  _removeFile(DisplayImageSource fileContainer) {
    if (fileContainer.file != null) {
      fileContainer.file!.delete();
    }
    if (fileContainer.url != null) {
      FileHelper().deleteImage(fileContainer.url!);
    }

    setState(() {
      widget.controller.removeFile = fileContainer;
    });
  }

  Widget actionIcon(
      {OnTap? onTap, required Color color, required IconData iconData}) {
    return InkWell(
      onTap: onTap,
      child: ClipOval(
        child: Container(
            color: color,
            height: 20,
            width: 20,
            child: Icon(
              iconData,
              color: Colors.white,
              size: 15,
            )),
      ),
    );
  }
}
