import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:absq/helper/theme.dart';

import 'callbacks.dart';
import 'display_image_source.dart';
import 'local_text.dart';
import 'multi_img_controller.dart';
import 'show_multiple_img.dart';

typedef OnFile = void Function(File);

class MultiImageFile extends StatefulWidget {
  final String? title;
  final bool enabled;
  final ImageSource imageSource;
  final MultiImgController? controller;
  final String? titleKey;

  const MultiImageFile(
      {Key? key,
      this.title,
      this.titleKey,
      this.enabled = true,
      this.controller,
      this.imageSource = ImageSource.gallery})
      : super(key: key);
  @override
  _MultiImageFileState createState() => _MultiImageFileState();
}

class _MultiImageFileState extends State<MultiImageFile> {
  List<DisplayImageSource> fileContainers = [];
  @override
  void initState() {
    super.initState();
    fileContainers = widget.controller!.fileContainers;
    widget.controller!.onChange(() {
      setState(() {
        this.fileContainers = widget.controller!.fileContainers;
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
              fontSize: 16,
            ),
            widget.titleKey != null ? const Spacer() : Container(),
            widget.enabled
                ? InkWell(
                    onTap: () => {_openImagePicker(false)},
                    child: Stack(
                      children: [
                        const SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.image,
                            color: primaryColor,
                            size: 35,
                          ),
                        ),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: actionIcon(
                                color: Colors.green, iconData: Icons.add))
                      ],
                    ),
                  )
                : Container(),
            widget.enabled
                ? InkWell(
                    onTap: () => {_openImagePicker(true)},
                    child: Stack(
                      children: [
                        const SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.camera,
                            color: primaryColor,
                            size: 35,
                          ),
                        ),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: actionIcon(
                                color: Colors.green, iconData: Icons.add))
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black,
            ),
            itemCount: fileContainers.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => ShowMultiImage(
                            displayImageSources: fileContainers,
                            initialPage: index,
                          )),
                ),
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
                      child: fileContainers[index].file == null
                          ? CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              imageUrl: fileContainers[index].url!,
                              placeholder: (context, url) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Builder(builder: (context) {
                                    return const SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator());
                                  }),
                                ],
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : FittedBox(
                              fit: BoxFit.cover,
                              child: Image.file(
                                fileContainers[index].file!,
                              ),
                            ),
                    ),
                  ),
                  widget.enabled
                      ? Positioned(
                          top: 10,
                          right: 0,
                          child: actionIcon(
                              color: Colors.red,
                              iconData: Icons.remove,
                              onTap: () =>
                                  {_fileRemove(fileContainers[index])}),
                        )
                      : Container(),
                ]),
              );
            },
          ),
        ),
      ],
    );
  }

  _openImagePicker(bool camera) async {
    var selectedFile = await ImagePicker().pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1000);
    if (selectedFile != null) {
      _fileAdded(DisplayImageSource(), File(selectedFile.path));
    }
  }

  _fileAdded(DisplayImageSource fileContainer, File selectedFile) {
    fileContainer.file = selectedFile;
    setState(() {
      fileContainers.add(fileContainer);
      widget.controller!.addFile = fileContainer;
    });
  }

  _fileRemove(DisplayImageSource fileContainer) {
    setState(() {
      widget.controller!.removeFile = fileContainer;
    });
  }

  Widget actionIcon({OnTap? onTap, Color? color, IconData? iconData}) {
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
