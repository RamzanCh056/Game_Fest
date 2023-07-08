import 'package:flutter/material.dart';

import '../constants/exports.dart';

class SmallImageWidget extends StatefulWidget {
  final bool isBorder;
  final bool isShadow;
  final bool isStar;
  final double imageWidth;
  final double imageHeight;
  final double boxHeight;
  final double boxWidth;
  final String? imageUrl;
  final Color borderColor;
  final  Color? shadowColor;

  const SmallImageWidget({
    Key? key,
    this.isBorder = false,
    this.isShadow = false,
    this.isStar = false,
    this.imageWidth = 50.0,
    this.imageHeight = 46.0,
    this.boxHeight = 50.0,
    this.boxWidth = 55.0,
    this.imageUrl,
    this.borderColor = Colors.red,
    this.shadowColor=Colors.black
  }) : super(key: key);

  @override
  State<SmallImageWidget> createState() => _SmallImageWidgetState();
}

class _SmallImageWidgetState extends State<SmallImageWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.boxHeight,
      width: widget.boxWidth,
      child: Stack(
        children: [
          Container(
            height: widget.imageHeight,
            width: widget.imageWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: widget.isBorder == true
                  ? Border.all(
                      color: widget.borderColor,
                      width: 2.0,
                    )
                  : null,
              boxShadow: widget.isShadow == true
                  ? [
                      BoxShadow(
                        color: widget.shadowColor!,
                        // color: AppColors.skyBorderColor.withOpacity(0.6),
                        blurRadius: 14,
                      ),
                    ]
                  : null,
              image: widget.imageUrl!.isEmpty?const DecorationImage(
                image:
                AssetImage('assets/images/user.jpg'),
                fit: BoxFit.fill,
              )
                  :DecorationImage(
                image:
                NetworkImage(widget.imageUrl!),
                fit: BoxFit.fill,
              ),
            ),
          ),
          widget.isStar == true ? Positioned(
            bottom: 0.0,
            child: SizedBox(
              width: 55,
              child: Center(child: SvgPicture.asset(AppIcons.star3),),
            ),
          ) : const SizedBox(),
        ],
      ),
    );
  }
}
