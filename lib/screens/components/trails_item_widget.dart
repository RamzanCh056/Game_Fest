import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '/constants/exports.dart';

class TrailItemWidget extends StatefulWidget {
  final int index;
  String trait;
  TrailItemWidget({Key? key,required this.trait, required this.index}) : super(key: key);

  @override
  State<TrailItemWidget> createState() => _TrailItemWidgetState();
}

class _TrailItemWidgetState extends State<TrailItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 70,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: AppColors.mainDarkColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: AppColors.whiteColor,
              ),
              child: Center(
                child: SvgPicture.asset(
                  widget.index == 0
                      ? AppIcons.shield
                      : widget.index == 1
                      ? AppIcons.sword
                      : widget.index == 2
                      ? AppIcons.hand
                      : AppIcons.fire,
                ),
              )),
          const SizedBox(width: 10),
          Text(widget.trait,
            style: poppinsSemiBold.copyWith(
              fontSize: 16,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      )
    );
  }
}
