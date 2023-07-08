import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/screens/Api/get_image_data.dart';
import '/widgets/responsive_widget.dart';

import '../../constants/exports.dart';
import '../../widgets/buttons/action_button_widget.dart';
import '../../widgets/buttons/login_button.dart';
import '../auth screens/login_screen.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context),
      padding: ResponsiveWidget.isWebScreen(context)
          ? const EdgeInsets.symmetric(vertical: 16, horizontal: 20)
          : const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.whiteColor.withOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: ResponsiveWidget.isWebScreen(context)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// menu icon
                IconButton(
                  onPressed: () {},
                  icon: const MenuIcon(),
                ),
                SizedBox(width: height(context) * 0.03),

                /// premium button
                PremiumButton(onTap: () {}),

                const Spacer(),

                /// actions icons
                ActionButtonWidget(onTap: () {}, iconPath: AppIcons.chat),
                const SizedBox(width: 16),
                ActionButtonWidget(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ApiData()));
                    },
                    iconPath: AppIcons.setting),
                const SizedBox(width: 16),
                ActionButtonWidget(
                  onTap: () {},
                  iconPath: AppIcons.bell,
                  isNotify: true,
                ),
                const SizedBox(width: 50),


                ///
                /// 16-May-2023
                /// Requirement # 2a
                /// Log In Button
                ///
                ///
                LoginButton(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                }),
                /// user name and image
                // Text(
                //   'Madeline Goldner',
                //   style: poppinsRegular.copyWith(
                //     fontSize: 16,
                //     color: AppColors.whiteColor,
                //   ),
                // ),
                // const SizedBox(width: 10),
                // const CircleAvatar(
                //   radius: 25,
                //   backgroundImage: AssetImage(AppImages.userImage),
                // ),
                const SizedBox(width: 8.0),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(AppIcons.dotVert),
                ),
              ],
            )
          : ResponsiveWidget.isTabletScreen(context)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// menu icon
                    IconButton(
                      onPressed: () {},
                      icon: const MenuIcon(),
                    ),
                    SizedBox(width: height(context) * 0.016),

                    /// premium button
                    PremiumButton(onTap: () {}),

                    const Spacer(),

                    /// actions icons
                    ActionButtonWidget(onTap: () {}, iconPath: AppIcons.chat),
                    const SizedBox(width: 8),
                    ActionButtonWidget(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ApiData()));
                        },
                        iconPath: AppIcons.setting),
                    const SizedBox(width: 8),
                    ActionButtonWidget(
                      onTap: () {},
                      iconPath: AppIcons.bell,
                      isNotify: true,
                    ),
                    const SizedBox(width: 20),

                    /// user name and image
                    Text(
                      'Madeline Goldner',
                      style: poppinsRegular.copyWith(
                        fontSize: 12,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(AppImages.userImage),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(AppIcons.dotVert),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// menu icon
                      IconButton(
                        onPressed: () {},
                        icon: const MenuIcon(),
                      ),
                      const SizedBox(width: 12.0),

                      /// premium button
                      PremiumButton(onTap: () {}),
                      const SizedBox(width: 8),

                      /// actions icons
                      ActionButtonWidget(onTap: () {}, iconPath: AppIcons.chat),
                      const SizedBox(width: 8),
                      ActionButtonWidget(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ApiData()));
                          },
                          iconPath: AppIcons.setting),
                      const SizedBox(width: 8),
                      ActionButtonWidget(
                        onTap: () {},
                        iconPath: AppIcons.bell,
                        isNotify: true,
                      ),

                      /// user name and image
                      // Text('Madeline Goldner',
                      //   style: poppinsRegular.copyWith(
                      //     fontSize: 16,
                      //     color: AppColors.whiteColor,
                      //   ),
                      // ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage(AppImages.userImage),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(AppIcons.dotVert),
                      ),
                    ],
                  ),
                ),
    );
  }
}
