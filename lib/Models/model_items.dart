import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ModelItems extends StatelessWidget {
  final int index;
  final double imageWidth;
  final double imageOffset;
  final double indexFactor;
  final String hero;

  const ModelItems(
      {Key? key,
      required this.index,
      required this.imageWidth,
      required this.imageOffset,
      required this.indexFactor,
      required this.hero})
      : super(key: key);

  Widget image() {
    return Hero(
      tag: hero,
      child: Image.network(hero,
        fit: BoxFit.cover,
        alignment: Alignment(-imageOffset + indexFactor * index, 0),
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: imageWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            image(),
          ],
        ),
      ),
    );
  }
}
