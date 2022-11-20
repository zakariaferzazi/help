import 'package:Yemenaman/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color color;
  final FontWeight fontWeight;
  const TitleText(
      {Key? key,
      this.text,
      this.fontSize,
      this.color = OurColor.titleTextColor,
      this.fontWeight = FontWeight.w800})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text!,
        overflow: TextOverflow.fade,
        maxLines: 1,
        softWrap: false,
        style: GoogleFonts.getFont('Markazi Text',
            fontSize: fontSize, fontWeight: fontWeight, color: color));
  }
}
