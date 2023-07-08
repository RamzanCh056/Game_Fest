import 'package:flutter/material.dart';

import '../../constants/exports.dart';

class PremiumButton extends StatelessWidget {
  final VoidCallback onTap;
  const PremiumButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: height(context) * 0.02, vertical: 7.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.pinkBorderColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.pinkBorderColor.withOpacity(0.5),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AppIcons.premium),
            const SizedBox(width: 5.0),
            Text('Get Premium',
              style: poppinsRegular.copyWith(
                fontSize: 14,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
