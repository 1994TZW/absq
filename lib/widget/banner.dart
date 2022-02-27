import 'package:flutter/material.dart';

import '../config.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;
  const FlavorBanner({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Config.isProduction()) return child;
    return Stack(
      children: <Widget>[child, _buildBanner(context)],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: BannerPainter(
            message: Config.instance.name,
            textDirection: Directionality.of(context),
            layoutDirection: Directionality.of(context),
            location: BannerLocation.topStart,
            color: Config.instance.color),
      ),
    );
  }
}
