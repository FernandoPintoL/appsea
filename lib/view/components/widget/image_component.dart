import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageComponent extends StatelessWidget {
  String imageUrl;
  double size;
  Widget errorWidget;
  Function function;

  ImageComponent(
      {super.key,
      required this.imageUrl,
      required this.size,
      required this.errorWidget,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        // width: size,
        // height: size,
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          // color: Colors.lightGreen,
          border: Border.all(color: Colors.lightGreen, width: 1),
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(
              value: downloadProgress.progress,
              backgroundColor: Colors.blueAccent),
      errorWidget: (context, url, error) => errorWidget,
    );
  }
}
