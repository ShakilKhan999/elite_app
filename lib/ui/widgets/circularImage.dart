import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterquiz/utils/ui_utils.dart';

class CircularImage extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final String imageUrl;
  const CircularImage(
      {super.key,
      this.width = 80,
      this.height = 80,
      this.radius = 40,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) => Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          errorWidget: (context, url, error) {
            print("error image ===========================================");
            return ClipOval(
              child: SvgPicture.asset(
                UiUtils.getImagePath("circular_person_icon.svg"),
                width: width,
                height: height,
              ),
            );
          }),
    );
    // return svg. (UiUtils.getImagePath("circular_person_icon.svg"));
  
  }
}
