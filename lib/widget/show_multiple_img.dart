import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:absq/helper/theme.dart';

import 'display_image_source.dart';

class ShowMultiImage extends StatefulWidget {
  final List<DisplayImageSource> displayImageSources;
  final int initialPage;
  const ShowMultiImage(
      {Key? key, required this.displayImageSources, this.initialPage = 0})
      : super(key: key);
  @override
  _ShowMultiImageState createState() => _ShowMultiImageState();
}

class _ShowMultiImageState extends State<ShowMultiImage> {
  late PageController pageController;
  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: primaryColor,
          body: Stack(
            children: [
              Positioned.fill(
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider:
                          widget.displayImageSources[index].imageProvider,
                      initialScale: PhotoViewComputedScale.contained * 0.95,
                      // heroAttributes: PhotoViewHeroAttributes(
                      //     tag: widget.displayImageSources[index].hashCode),
                    );
                  },
                  itemCount: widget.displayImageSources.length,
                  loadingBuilder: (context, event) => Center(
                    child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded /
                                event.expectedTotalBytes!,
                      ),
                    ),
                  ),
                  backgroundDecoration: const BoxDecoration(
                    color: primaryColor,
                  ),
                  pageController: pageController,
                ),
              ),
              Positioned(
                top: 0,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
