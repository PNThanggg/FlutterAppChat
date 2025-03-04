import 'package:flutter/material.dart';

class Noises extends StatelessWidget {
  final List<double> rList;
  final Color activeSliderColor;

  const Noises({
    super.key,
    required this.rList,
    required this.activeSliderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: rList
          .map(
            (e) => _singleNoise(e),
          )
          .toList(),
    );
  }

  Widget _singleNoise(double height) {
    return Container(
      width: 4,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: activeSliderColor,
      ),
    );
  }
}
