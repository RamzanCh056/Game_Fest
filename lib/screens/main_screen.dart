import 'package:flutter/material.dart';
import '../constants/exports.dart';
import '../screens/components/app_bar_widget.dart';
import '../screens/components/left_side_widget.dart';
import '../screens/components/middle_area_widget.dart';
import '../screens/components/right_side_widget.dart';
import '../widgets/back_image_widget.dart';
import '../widgets/responsive_widget.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  ///      ================> 28-May-2023 <===================
  ///      ================> Changes Begin <=================
  ///      Changes has been created for composite search
  ///      at left side widget and middle area widget

  ///       ===========> Data of Left Side widget <===========

  ///      ================> Changes Begin <=================





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Stack(
          children: [
            const BackImageWidget(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// appbar
                const AppBarWidget(),

                /// Whole area container
                Expanded(
                  child: Container(
                    padding: ResponsiveWidget.isWebScreen(context)
                        ? const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 25)
                        : ResponsiveWidget.isTabletScreen(context)
                            ? const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 25)
                            : const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 25),
                    child: ResponsiveWidget.isWebScreen(context)
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              /// left side widget
                              ///
                              ///
                              ///
                              /// Requirement # 3
                              ///
                              /// All Changes done for requirement # 3
                              /// in the Left side Widget
                              /// All data stored on firebase was shown
                              /// in the below field
                              Expanded(
                                flex: 3,
                                child: LeftSideWidget(),
                              ),

                              SizedBox(width: 20),

                              /// Middle Area Widget
                              ///
                              /// Requirement # 4
                              ///
                              /// All Changes done for requirement # 4 is
                              /// in the Middle Widget
                              /// All data stored in comp collection in
                              /// firebase was shown here in popular field
                              ///
                              Expanded(
                                flex: 11,
                                child: MiddleAreaWidget(),
                              ),

                              SizedBox(width: 20),

                              /// right side widget
                              Expanded(
                                flex: 2,
                                child: RightSideWidget(),
                              ),
                            ],
                          )
                        : ResponsiveWidget.isTabletScreen(context)
                            ? Row(
                                children: const [
                                  /// left side widget
                                  Expanded(
                                    flex: 3,
                                    child: LeftSideWidget(),
                                  ),

                                  SizedBox(width: 20),

                                  /// middle area widget
                                  Expanded(
                                    flex: 8,
                                    child: MiddleAreaWidget(),
                                  ),

                                  SizedBox(width: 20),
                                ],
                              )
                            : ListView(
                                children: [
                                  /// left side widget
                                  SizedBox(
                                    height: height(context) * 0.5,
                                    child: const LeftSideWidget(),
                                  ),

                                  const SizedBox(height: 20),

                                  /// middle area widget
                                  const MiddleAreaWidget(),

                                  const SizedBox(height: 20),

                                  /// right side widget
                                  const RightSideWidget(),
                                ],
                              ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
