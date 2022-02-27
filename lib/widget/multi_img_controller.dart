import 'dart:io';

import 'callbacks.dart';
import 'display_image_source.dart';

class MultiImgController {
  List<String> imageUrls = [];
  List<DisplayImageSource> addedFiles = [];
  List<DisplayImageSource> removedFiles = [];

  List<DisplayImageSource> fileContainers = [];
  CallBack? callback;
  MultiImgController() {
    fileContainers = [];
  }

  set setImageUrls(List<String> imageUrls) {
    if (imageUrls == null) {
      return;
    }
    fileContainers.clear();

    this.imageUrls = imageUrls;
    imageUrls.forEach((e) {
      fileContainers.add(DisplayImageSource(url: e));
    });
    if (callback != null) {
      callback!();
    }
  }

  void onChange(CallBack callBack) {
    this.callback = callBack;
  }

  set addFile(DisplayImageSource fileContainer) {
    // if (fileContainers.contains(fileContainer)) return;
    addedFiles.add(fileContainer);
    if (callback != null) {
      callback!();
    }
  }

  set removeFile(DisplayImageSource fileContainer) {
    if (!fileContainers.contains(fileContainer)) return;
    fileContainers.remove(fileContainer);

    if (addedFiles.contains(fileContainer)) {
      addedFiles.remove(fileContainer);
    }
    if (imageUrls.contains(fileContainer.url)) {
      removedFiles.add(fileContainer);
    }
    if (callback != null) {
      callback!();
    }
  }

  List<File?> get getAddedFile {
    return addedFiles.map((e) => e.file).toList();
  }

  List<String?> get getDeletedUrl {
    return removedFiles.map((e) => e.url).toList();
  }
}
