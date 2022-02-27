import 'dart:io';

import '../display_image_source.dart';

typedef CallBack = void Function();

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
    fileContainers.clear();

    this.imageUrls = imageUrls;
    for (var e in imageUrls) {
      fileContainers.add(DisplayImageSource(url: e));
    }
    if (callback != null) {
      callback!();
    }
  }

  void onChange(CallBack callBack) {
    callback = callBack;
  }

  set addFile(DisplayImageSource fileContainer) {
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

  List<File> get getAddedFile {
    List<File> files = [];
    for (var file in addedFiles) {
      if (file.file != null) files.add(file.file!);
    }
    return files;
  }

  List<String> get getDeletedUrls {
    return removedFiles.map((e) => e.url ?? "").toList();
  }
}
