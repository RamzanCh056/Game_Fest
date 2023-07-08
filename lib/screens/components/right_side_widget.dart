import 'package:flutter/material.dart';
import '/widgets/responsive_widget.dart';

import '../../constants/exports.dart';

class RightSideWidget extends StatelessWidget {
  const RightSideWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.isWebScreen(context) ? Padding(
      padding: const EdgeInsets.only(top: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: height(context) / 2 ,
              width: width(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage(AppImages.imageOne),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Container(
              height: height(context) / 2 ,
              width: width(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage(AppImages.imageTwo),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    ) : ResponsiveWidget.isTabletScreen(context) ?  Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: height(context) * 0.4,
          width: height(context) * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage(AppImages.imageOne),
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Container(
          height: height(context) * 0.4,
          width: height(context) * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage(AppImages.imageTwo),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height(context) * 0.4,
          width: height(context) * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage(AppImages.imageOne),
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          height: height(context) * 0.4,
          width: height(context) * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage(AppImages.imageTwo),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}
