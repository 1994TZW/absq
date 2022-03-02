import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:absq/helper/theme.dart';

class ShowImage extends StatefulWidget {
  final String? url;
  final File? imageFile;
  final String? fileName;
  final String? localImage;
  const ShowImage(
      {Key? key, this.imageFile, this.fileName, this.url, this.localImage})
      : super(key: key);
  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    final ImageProvider<Object>? p;
    if (widget.imageFile != null) {
      p = FileImage(widget.imageFile!);
    } else {
      p = AssetImage(widget.localImage!);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: primaryColor,
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.download))],
      ),
      body: Center(
          child: PhotoView(
              backgroundDecoration: const BoxDecoration(
                color: primaryColor,
              ),
              imageProvider: widget.url != null ? NetworkImage(widget.url!) : p,
              minScale: PhotoViewComputedScale.contained * 1)),
    );
  }
}
