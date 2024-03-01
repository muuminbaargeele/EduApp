import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ColoredSvgIcon extends StatelessWidget {
  final String assetName;
  final double height;
  final double width;
  final Color? color;

  const ColoredSvgIcon({
    Key? key,
    required this.assetName,
    required this.height,
    required this.width,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(assetName,
        height: height,
        width: width,
        alignment: Alignment.centerLeft,
        semanticsLabel: 'Acme Logo',
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null);
  }
}
