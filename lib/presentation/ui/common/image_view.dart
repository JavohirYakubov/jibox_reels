import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../../../utils/constants.dart';
class ImageView extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;

  ImageView(this.url, {super.key, this.width, this.height, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return url == null
        ? Container()
        : CachedNetworkImage(
            imageUrl: url!.startsWith("http") ? url! : BASE_FILE_URL + url!,
            placeholder: (context, url) => CupertinoActivityIndicator(),
            errorWidget: (context, url, error) => Container(),
            width: width,
            height: height,
            fit: fit,
          );
  }
}
