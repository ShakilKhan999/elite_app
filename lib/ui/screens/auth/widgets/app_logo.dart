import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/ui_utils.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(context) => SizedBox(
        width: 145,
        child: Image.asset(
          UiUtils.getImagePath("splash_logo.png"),
        ),
      );
}
