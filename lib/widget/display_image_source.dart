import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class DisplayImageSource {
  String? url;
  File? file;
  DisplayImageSource({this.url, this.file});

  ImageProvider get imageProvider {
    if (file == null) {
      return CachedNetworkImageProvider(url!);
    } else {
      return FileImage(file!);
    }
  }

  @override
  bool operator ==(other) {
    if (identical(this, other) && other is DisplayImageSource) {
      return true;
    }
    return (other is DisplayImageSource &&
            other.file == this.file &&
            (other.file != null || this.file != null)) ||
        (other is DisplayImageSource &&
            other.url == this.url &&
            (other.url != null || this.url != null));
  }

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + file.hashCode;
    return result;
  }
}
