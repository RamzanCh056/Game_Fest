import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '/screens/components/traits_box.dart';
import '/widgets/responsive_widget.dart';
import 'package:hexagon/hexagon.dart';
import 'package:provider/provider.dart';

import '../../constants/exports.dart';
import '../../providers/basic_provider.dart';
import '../../widgets/small_image_widget.dart';
import '../Admin/Model/api_data_model.dart';
import 'carousal_box.dart';
import 'early_camp_box.dart';
import 'expand_heading_widget.dart';
import 'option_box.dart';

class ExpandItemWidget extends StatefulWidget {

  String? docId;
  List<ChampModel> champList=[];
  int champLengthFromApi;
  // Key key;

  ExpandItemWidget({this.docId,required this.champLengthFromApi,required this.champList});


  @override
  State<ExpandItemWidget> createState() => _ExpandItemWidgetState();
}

class _ExpandItemWidgetState extends State<ExpandItemWidget> {

  List<String> traits=[];
  bool traitsFiltered=false;
  List<String?> champPosition=[];
  final Map traitsMap={};
  List mapKeys=[];
  List mapValues=[];
  int k=0;
  int j=6;
  bool newLine=false;

  filterTraits(){

    // print("=============> Begin Filter traits at expanded item widget  <=============");
    // print("Champlist length: ${widget.champList.length}");
    for(int i=0;i<widget.champList.length;i++){
      champPosition.add(widget.champList[i].champPositionIndex);
      for(int j=0;j<widget.champList[i].champTraits.length;j++){
        traits.add(widget.champList[i].champTraits[j]);
      }
    }
    for(int i=0;i<traits.length;i++){

    }
    traits.map((e) =>
        traitsMap.containsKey(e)?traitsMap[e]++:traitsMap[e]=1).toList();

    traitsFiltered==true;
    // print("=============> End Filter traits at expanded item widget  <=============");
    setState(() {

    });

  }

  List<ChampModel?> row1=[null,null,null,null,null,null,null];
  List<ChampModel?> row2=[null,null,null,null,null,null,null];
  List<ChampModel?> row3=[null,null,null,null,null,null,null];
  List<ChampModel?> row4=[null,null,null,null,null,null,null];

  convertList(){
    int fullList=28-widget.champList.length;
    int length=fullList+widget.champList.length;
    for(int i=0;i<length;i++){
      if(i<widget.champList.length){
        print("i < champlength");
        print(widget.champList[i].champPositionIndex.substring(0));
        if(widget.champList[i].champPositionIndex.startsWith('1')) {
          int index=int.parse(widget.champList[i].champPositionIndex.substring(1,2));
          row1.removeAt(index);
          row1.insert(index,
              widget.champList[i]);
        }
      }
      if(i<widget.champList.length){
        if(widget.champList[i].champPositionIndex.startsWith('2')) {
          int index=int.parse(widget.champList[i].champPositionIndex.substring(1,2));
          row2.removeAt(index);
          row2.insert(index,
              widget.champList[i]);

        }
      }
      if(i<widget.champList.length){
        if(widget.champList[i].champPositionIndex.startsWith('3')) {
          int index=int.parse(widget.champList[i].champPositionIndex.substring(1,2));
          row3.removeAt(index);
          row3.insert(index,
              widget.champList[i]);

        }
      }
      if(i<widget.champList.length){
        if(widget.champList[i].champPositionIndex.startsWith('4')) {
          int index=int.parse(widget.champList[i].champPositionIndex.substring(1,2));
          row4.removeAt(index);
          row4.insert(index,
              widget.champList[i]);
        }

      }
    }

    print("Row 1: ${row1.length}");
    print("Row 2: ${row2.length}");
    print("Row 3: ${row3.length}");
    print("Row 4: ${row4.length}");
    for(int i=0;i<7;i++){
      print(row1[i]);
      print(row2[i]);
      print(row3[i]);
      print(row4[i]);
    }

  }


  @override
  void initState() {
    filterTraits();
    convertList();
    print("Expand item widget init");
    // TODO: implement initState
    super.initState();
  }

  final controller = ExpandableController();

  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<BasicProvider>(context);
    var size = MediaQuery.of(context).size;
    return ExpandablePanel(
      controller: controller,
      theme: const ExpandableThemeData(
        useInkWell: false,
        hasIcon: false,
        //iconColor: AppColors.textColor,
        iconPadding: EdgeInsets.only(right: 20.0, top: 24.0),
        tapBodyToCollapse: false,
        tapBodyToExpand: false,
        tapHeaderToExpand: false,

      ),

      ///
      ///       Date 14-May-2023
      ///       Requirement # 1
      ///       Team comp now expands on pressing any where in the
      ///       target Team comp
      ///
      header: InkWell(
        onTap: (){
          controller.toggle();
          setState(() {
            isExpand = !isExpand;
          });
        },
        child: ExpandHeadingWidget(
          champList: widget.champList,
          docId: widget.docId,
          icon: IconButton(
            onPressed: () {
              controller.toggle();
              setState(() {
                isExpand = !isExpand;
              });
            },
            icon: isExpand == true
                ? const Icon(Icons.keyboard_arrow_up, color: AppColors.whiteColor)
                : SvgPicture.asset(AppIcons.arrowDown),
          ),
          isExpand: isExpand,
        ),
      ),
      collapsed: const SizedBox(),
      expanded: ResponsiveWidget.isExtraWebScreen(context)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// 3 boxes
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(left: 22.0, right: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// early camp
                      const Expanded(
                        flex: 5,
                        child: EarlyCampBox(),
                      ),
                      const SizedBox(width: 24),

                      /// trails
                      Expanded(
                        flex: 6,
                        child: TraitsBox(traits: traitsMap,),
                      ),
                      const SizedBox(width: 24),

                      /// caroousel
                      const Expanded(
                        flex: 4,
                        child: CarouselBox(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30.0),

                /// 2 box
                Padding(
                  padding: const EdgeInsets.only(left: 22.0, right: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /// option box
                      Expanded(
                        child: Container(
                          width: width(context),
                          height: height(context) * 0.3,
                          decoration:
                              threeBoxDecoration(context, isBorder: false),
                          child: const OptionsBox(),
                        ),
                      ),
                      const SizedBox(width: 40),

                      /// positioning box
                      Expanded(
                        child: Container(
                          width: width(context),
                          height: height(context) * 0.3,
                          decoration:
                              threeBoxDecoration(context, isBorder: false),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              /// options text
                              const SizedBox(height: 16.0),
                              Text(
                                'Positioning',
                                style: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              ///
                              const SizedBox(height: 10.0),
                              SizedBox(
                                width: width(context),
                                height: height(context) * 0.3,
                                child: Padding(
                                  padding:
                                  ResponsiveWidget.isMobileScreen(context)
                                      ? EdgeInsets.symmetric(
                                      horizontal:
                                      height(context) * 0.18)
                                      : ResponsiveWidget.isTabletScreen(
                                      context)
                                      ? EdgeInsets.symmetric(
                                      horizontal:
                                      height(context) * 0.16)
                                      : EdgeInsets.symmetric(
                                      horizontal:
                                      height(context) * 0.1),
                                  child: Stack(
                                    children: [
                                      Row(
                                          children: List.generate(7, (index1) =>
                                              SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: Center(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(12),
                                                      // child
                                                      /// Here I used chosen team indexes for reference if the player exist in team
                                                      /// We will show the icon of player else will show blank polygon icon
                                                      child: row1[index1]!=null
                                                          ?SmallImageWidget(
                                                        isBorder: true,
                                                        imageUrl: provider.apiImageUrl + row1[index1]!.imagePath,
                                                        borderColor: row1[index1]!.champCost=='1'?
                                                        Colors.grey:row1[index1]!.champCost=='2'?
                                                        Colors.green:row1[index1]!.champCost=='3'?
                                                        Colors.blue:row1[index1]!.champCost=='4'?
                                                        Colors.purple:row1[index1]!.champCost=='5'?
                                                        Colors.yellow:Colors.red
                                                        ,

                                                      ):
                                                      // ?  Image.network(
                                                      // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                      // height: 60,
                                                      // width: 60,
                                                      // fit: BoxFit
                                                      //     .fill):
                                                      Image.asset(
                                                          'assets/images/Polygon 7.png')

                                                      ,
                                                    ),
                                                  )
                                              )
                                          )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 30.0,left: 15),
                                        child: Row(
                                            children: List.generate(7, (index2) =>
                                                SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: Center(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(12),
                                                        // child
                                                        /// Here I used chosen team indexes for reference if the player exist in team
                                                        /// We will show the icon of player else will show blank polygon icon
                                                        child: row2[index2]!=null
                                                            ?SmallImageWidget(
                                                          isBorder: true,
                                                          imageUrl: provider.apiImageUrl + row2[index2]!.imagePath,
                                                          borderColor: row2[index2]!.champCost=='1'?
                                                          Colors.grey:row2[index2]!.champCost=='2'?
                                                          Colors.green:row2[index2]!.champCost=='3'?
                                                          Colors.blue:row2[index2]!.champCost=='4'?
                                                          Colors.purple:row2[index2]!.champCost=='5'?
                                                          Colors.yellow:Colors.red
                                                          ,

                                                        ):
                                                        // ?  Image.network(
                                                        // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                        // height: 60,
                                                        // width: 60,
                                                        // fit: BoxFit
                                                        //     .fill):
                                                        Image.asset(
                                                            'assets/images/Polygon 7.png')

                                                        ,
                                                      ),
                                                    )
                                                ))
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 60.0),
                                        child: Row(
                                            children: List.generate(7, (index3) =>
                                                SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: Center(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(12),
                                                        // child
                                                        /// Here I used chosen team indexes for reference if the player exist in team
                                                        /// We will show the icon of player else will show blank polygon icon
                                                        child: row3[index3]!=null
                                                            ?SmallImageWidget(
                                                          isBorder: true,
                                                          imageUrl: provider.apiImageUrl + row3[index3]!.imagePath,
                                                          borderColor: row3[index3]!.champCost=='1'?
                                                          Colors.grey:row3[index3]!.champCost=='2'?
                                                          Colors.green:row3[index3]!.champCost=='3'?
                                                          Colors.blue:row3[index3]!.champCost=='4'?
                                                          Colors.purple:row3[index3]!.champCost=='5'?
                                                          Colors.yellow:Colors.red
                                                          ,

                                                        ):
                                                        // ?  Image.network(
                                                        // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                        // height: 60,
                                                        // width: 60,
                                                        // fit: BoxFit
                                                        //     .fill):
                                                        Image.asset(
                                                            'assets/images/Polygon 7.png')

                                                        ,
                                                      ),
                                                    )
                                                )
                                            )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 90.0,left: 15),
                                        child: Row(
                                            children: List.generate(7, (index4) =>
                                                SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: Center(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(12),
                                                        // child
                                                        /// Here I used chosen team indexes for reference if the player exist in team
                                                        /// We will show the icon of player else will show blank polygon icon
                                                        child: row4[index4]!=null
                                                            ?SmallImageWidget(
                                                          isBorder: true,
                                                          imageUrl: provider.apiImageUrl + row4[index4]!.imagePath,
                                                          borderColor: row4[index4]!.champCost=='1'?
                                                          Colors.grey:row4[index4]!.champCost=='2'?
                                                          Colors.green:row4[index4]!.champCost=='3'?
                                                          Colors.blue:row4[index4]!.champCost=='4'?
                                                          Colors.purple:row4[index4]!.champCost=='5'?
                                                          Colors.yellow:Colors.red
                                                          ,

                                                        ):
                                                        // ?  Image.network(
                                                        // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                        // height: 60,
                                                        // width: 60,
                                                        // fit: BoxFit
                                                        //     .fill):
                                                        Image.asset(
                                                            'assets/images/Polygon 7.png')

                                                        ,
                                                      ),
                                                    )
                                                )
                                            )
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : ResponsiveWidget.isWebScreen(context)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// 3 boxes
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0, right: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          /// early camp
                          Expanded(
                            child: EarlyCampBox(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0, right: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          /// trails
                          Expanded(
                            child: TraitsBox(traits: traitsMap,),
                          ),
                          SizedBox(width: 24),

                          /// caroousel
                          const Expanded(
                            flex: 1,
                            child: CarouselBox(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    /// 2 box
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0, right: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// option box
                          Expanded(
                            child: Container(
                              width: width(context),
                              height: height(context) * 0.3,
                              decoration:
                                  threeBoxDecoration(context, isBorder: false),
                              child: const OptionsBox(),
                            ),
                          ),
                          const SizedBox(width: 40),

                          /// positioning box
                          Expanded(
                            child: Container(
                              width: width(context),
                              height: height(context) * 0.3,
                              decoration:
                                  threeBoxDecoration(context, isBorder: false),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  /// options text
                                  const SizedBox(height: 16.0),
                                  Text(
                                    'Positioning',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.0,
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  ///
                                  const SizedBox(height: 10.0),
                                  Padding(
                                    padding:
                                    ResponsiveWidget.isMobileScreen(context)
                                        ? EdgeInsets.symmetric(
                                        horizontal:
                                        height(context) * 0.18)
                                        : ResponsiveWidget.isTabletScreen(
                                        context)
                                        ? EdgeInsets.symmetric(
                                        horizontal:
                                        height(context) * 0.16)
                                        : EdgeInsets.symmetric(
                                        horizontal:
                                        height(context) * 0.1),

                                    child:

                                    SizedBox(
                                      height: height(context)*.2,
                                      width: width(context),
                                      // width: 420,
                                      child: Stack(
                                        children: [
                                          Row(
                                              children: List.generate(7, (index1) =>
                                                  SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: Center(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(12),
                                                        // child
                                                        /// Here I used chosen team indexes for reference if the player exist in team
                                                        /// We will show the icon of player else will show blank polygon icon
                                                        child: row1[index1]!=null
                                                            ?SmallImageWidget(
                                                          isBorder: true,
                                                          imageUrl: provider.apiImageUrl + row1[index1]!.imagePath,
                                                          borderColor: row1[index1]!.champCost=='1'?
                                                          Colors.grey:row1[index1]!.champCost=='2'?
                                                          Colors.green:row1[index1]!.champCost=='3'?
                                                          Colors.blue:row1[index1]!.champCost=='4'?
                                                          Colors.purple:row1[index1]!.champCost=='5'?
                                                          Colors.yellow:Colors.red
                                                          ,

                                                        ):
                                                        // ?  Image.network(
                                                        // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                        // height: 60,
                                                        // width: 60,
                                                        // fit: BoxFit
                                                        //     .fill):
                                                        Image.asset(
                                                            'assets/images/Polygon 7.png')

                                                        ,
                                                      ),
                                                    )
                                                  )
                                              )
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 30.0,left: 15),
                                            child: Row(
                                                children: List.generate(7, (index2) =>
                                                    SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Center(
                                                          child: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                            // child
                                                            /// Here I used chosen team indexes for reference if the player exist in team
                                                            /// We will show the icon of player else will show blank polygon icon
                                                            child: row2[index2]!=null
                                                                ?SmallImageWidget(
                                                              isBorder: true,
                                                              imageUrl: provider.apiImageUrl + row2[index2]!.imagePath,
                                                              borderColor: row2[index2]!.champCost=='1'?
                                                              Colors.grey:row2[index2]!.champCost=='2'?
                                                              Colors.green:row2[index2]!.champCost=='3'?
                                                              Colors.blue:row2[index2]!.champCost=='4'?
                                                              Colors.purple:row2[index2]!.champCost=='5'?
                                                              Colors.yellow:Colors.red
                                                              ,

                                                            ):
                                                            // ?  Image.network(
                                                            // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                            // height: 60,
                                                            // width: 60,
                                                            // fit: BoxFit
                                                            //     .fill):
                                                            Image.asset(
                                                                'assets/images/Polygon 7.png')

                                                            ,
                                                          ),
                                                        )
                                                    ))
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 60.0),
                                            child: Row(
                                                children: List.generate(7, (index3) =>
                                                    SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Center(
                                                          child: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                            // child
                                                            /// Here I used chosen team indexes for reference if the player exist in team
                                                            /// We will show the icon of player else will show blank polygon icon
                                                            child: row3[index3]!=null
                                                                ?SmallImageWidget(
                                                              isBorder: true,
                                                              imageUrl: provider.apiImageUrl + row3[index3]!.imagePath,
                                                              borderColor: row3[index3]!.champCost=='1'?
                                                              Colors.grey:row3[index3]!.champCost=='2'?
                                                              Colors.green:row3[index3]!.champCost=='3'?
                                                              Colors.blue:row3[index3]!.champCost=='4'?
                                                              Colors.purple:row3[index3]!.champCost=='5'?
                                                              Colors.yellow:Colors.red
                                                              ,

                                                            ):
                                                            // ?  Image.network(
                                                            // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                            // height: 60,
                                                            // width: 60,
                                                            // fit: BoxFit
                                                            //     .fill):
                                                            Image.asset(
                                                                'assets/images/Polygon 7.png')

                                                            ,
                                                          ),
                                                        )
                                                    )
                                                )
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 90.0,left: 15),
                                            child: Row(
                                                children: List.generate(7, (index4) =>
                                                    SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Center(
                                                          child: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                            // child
                                                            /// Here I used chosen team indexes for reference if the player exist in team
                                                            /// We will show the icon of player else will show blank polygon icon
                                                            child: row4[index4]!=null
                                                                ?SmallImageWidget(
                                                              isBorder: true,
                                                              imageUrl: provider.apiImageUrl + row4[index4]!.imagePath,
                                                              borderColor: row4[index4]!.champCost=='1'?
                                                              Colors.grey:row4[index4]!.champCost=='2'?
                                                              Colors.green:row4[index4]!.champCost=='3'?
                                                              Colors.blue:row4[index4]!.champCost=='4'?
                                                              Colors.purple:row4[index4]!.champCost=='5'?
                                                              Colors.yellow:Colors.red
                                                              ,

                                                            ):
                                                            // ?  Image.network(
                                                            // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                            // height: 60,
                                                            // width: 60,
                                                            // fit: BoxFit
                                                            //     .fill):
                                                            Image.asset(
                                                                'assets/images/Polygon 7.png')

                                                            ,
                                                          ),
                                                        )
                                                    )
                                                )
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),

                                    // SizedBox(
                                    //   width: width(context),
                                    //   height: height(context) * 0.2,
                                    //   child: GridView.builder(
                                    //     // physics: ScrollPhysics(),
                                    //     // shrinkWrap: true,
                                    //     itemCount: widget.champLengthFromApi,
                                    //     // padding: EdgeInsets.zero,
                                    //       gridDelegate:
                                    //       const SliverGridDelegateWithFixedCrossAxisCount(
                                    //           crossAxisCount: 7,
                                    //           mainAxisExtent: 60,
                                    //           crossAxisSpacing: 0,
                                    //           mainAxisSpacing: 0),
                                    //
                                    //       itemBuilder: (context, index) {
                                    //         // print("=========> Gridview build begin <=========");
                                    //         // print("Champ Length = ${widget.champLengthFromApi}");
                                    //         // print(index);
                                    //         // j=6;
                                    //         // k=0;
                                    //         ///
                                    //         /// 16-May-2023
                                    //         /// Requirement # 5
                                    //         ///
                                    //         /// This is the algorithm for the design
                                    //         /// of Team builder shown in Figma
                                    //         if(index/j==1){
                                    //           // print("j = $j");
                                    //           // print("k = $k");
                                    //           // print("k mod = ${k%2}");
                                    //           j=j+6;
                                    //
                                    //           k++;
                                    //           // print("j = $j");
                                    //           // print("k = $k");
                                    //           // print("k mod = ${k%2}");
                                    //
                                    //           // Provider.of<BasicProvider>(context,listen: false).updateModOfK(k%2);
                                    //         }
                                    //         if(j>widget.champLengthFromApi){
                                    //           // print("J is greater than champLength");
                                    //           j=widget.champLengthFromApi;
                                    //           // print(j);
                                    //         }
                                    //         // if(index+1==widget.champLengthFromApi){
                                    //         //   print("index reached to length");
                                    //         //   j=6;
                                    //         //   k=0;
                                    //         // }
                                    //         // print("=========> Gridview build End <=========");
                                    //
                                    //         return Center(
                                    //           child: ClipRRect(
                                    //             borderRadius:
                                    //             BorderRadius
                                    //                 .circular(12),
                                    //             // child
                                    //             /// Here I used chosen team indexes for reference if the player exist in team
                                    //             /// We will show the icon of player else will show blank polygon icon
                                    //             child: champPosition.contains("$index")
                                    //                 ?SmallImageWidget(
                                    //               isBorder: true,
                                    //               imageUrl: Provider.of<BasicProvider>(context,listen: false).apiImageUrl + widget.champList[champPosition.indexOf(index.toString())].imagePath!,
                                    //               borderColor: widget.champList[champPosition.indexOf(index.toString())].champCost=='1'?
                                    //               Colors.grey:widget.champList[champPosition.indexOf(index.toString())].champCost=='2'?
                                    //               Colors.green:widget.champList[champPosition.indexOf(index.toString())].champCost=='3'?
                                    //               Colors.blue:widget.champList[champPosition.indexOf(index.toString())].champCost=='4'?
                                    //               Colors.purple:widget.champList[champPosition.indexOf(index.toString())].champCost=='5'?
                                    //               Colors.yellow:Colors.red
                                    //               ,
                                    //               shadowColor: widget.champList[champPosition.indexOf(index.toString())].champCost=='1'?
                                    //               const Color(0x609E9E9E):widget.champList[champPosition.indexOf(index.toString())].champCost=='2'?
                                    //               const Color(0x604CAF50):widget.champList[champPosition.indexOf(index.toString())].champCost=='3'?
                                    //               const Color(0x602196F3):widget.champList[champPosition.indexOf(index.toString())].champCost=='4'?
                                    //               const Color(0x609C27B0):widget.champList[champPosition.indexOf(index.toString())].champCost=='5'?
                                    //               const Color(0x60FFEB3B):const Color(0x60F44336),
                                    //
                                    //             ):
                                    //             // ?  Image.network(
                                    //             // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                    //             // height: 60,
                                    //             // width: 60,
                                    //             // fit: BoxFit
                                    //             //     .fill):
                                    //             Image.asset(
                                    //                 'assets/images/Polygon 7.png')
                                    //
                                    //             ,
                                    //           ),
                                    //         );
                                    //
                                    //
                                    //       })
                                    //
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// 3 boxes
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          /// early camp
                          Expanded(
                            flex: 5,
                            child: EarlyCampBox(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Row(
                        children: [
                          /// trails
                          Expanded(
                            child: TraitsBox(traits: traitsMap,),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Row(
                        children: const [
                          /// caroousel
                          Expanded(
                            child: CarouselBox(),
                          ),
                        ],
                      ),
                    ),

                    /// 2 box
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// option box
                          Expanded(
                            child: Container(
                              width: width(context),
                              height: height(context) * 0.3,
                              decoration:
                                  threeBoxDecoration(context, isBorder: false),
                              child: const OptionsBox(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// positioning box
                          Expanded(
                            child: Container(
                              width: width(context),
                              height: height(context) * 0.3,
                              decoration:
                                  threeBoxDecoration(context, isBorder: false),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  /// options text
                                  const SizedBox(height: 16.0),
                                  Text(
                                    'Positioning',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.0,
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  ///
                                  const SizedBox(height: 10.0),

                                  SizedBox(
                                    width: width(context),
                                    height: height(context) * 0.3,
                                    child: Padding(
                                      padding:
                                      ResponsiveWidget.isMobileScreen(context)
                                          ? EdgeInsets.symmetric(
                                          horizontal:
                                          height(context) * 0.18)
                                          : ResponsiveWidget.isTabletScreen(
                                          context)
                                          ? EdgeInsets.symmetric(
                                          horizontal:
                                          height(context) * 0.16)
                                          : EdgeInsets.symmetric(
                                          horizontal:
                                          height(context) * 0.1),
                                      child: Stack(
                                        children: [
                                          Row(
                                              children: List.generate(7, (index1) =>
                                                  SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: Center(
                                                        child: ClipRRect(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(12),
                                                          // child
                                                          /// Here I used chosen team indexes for reference if the player exist in team
                                                          /// We will show the icon of player else will show blank polygon icon
                                                          child: row1[index1]!=null
                                                              ?SmallImageWidget(
                                                            isBorder: true,
                                                            imageUrl: provider.apiImageUrl + row1[index1]!.imagePath,
                                                            borderColor: row1[index1]!.champCost=='1'?
                                                            Colors.grey:row1[index1]!.champCost=='2'?
                                                            Colors.green:row1[index1]!.champCost=='3'?
                                                            Colors.blue:row1[index1]!.champCost=='4'?
                                                            Colors.purple:row1[index1]!.champCost=='5'?
                                                            Colors.yellow:Colors.red
                                                            ,

                                                          ):
                                                          // ?  Image.network(
                                                          // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                          // height: 60,
                                                          // width: 60,
                                                          // fit: BoxFit
                                                          //     .fill):
                                                          Image.asset(
                                                              'assets/images/Polygon 7.png')

                                                          ,
                                                        ),
                                                      )
                                                  )
                                              )
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 30.0,left: 15),
                                            child: Row(
                                                children: List.generate(7, (index2) =>
                                                    SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Center(
                                                          child: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                            // child
                                                            /// Here I used chosen team indexes for reference if the player exist in team
                                                            /// We will show the icon of player else will show blank polygon icon
                                                            child: row2[index2]!=null
                                                                ?SmallImageWidget(
                                                              isBorder: true,
                                                              imageUrl: provider.apiImageUrl + row2[index2]!.imagePath,
                                                              borderColor: row2[index2]!.champCost=='1'?
                                                              Colors.grey:row2[index2]!.champCost=='2'?
                                                              Colors.green:row2[index2]!.champCost=='3'?
                                                              Colors.blue:row2[index2]!.champCost=='4'?
                                                              Colors.purple:row2[index2]!.champCost=='5'?
                                                              Colors.yellow:Colors.red
                                                              ,

                                                            ):
                                                            // ?  Image.network(
                                                            // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                            // height: 60,
                                                            // width: 60,
                                                            // fit: BoxFit
                                                            //     .fill):
                                                            Image.asset(
                                                                'assets/images/Polygon 7.png')

                                                            ,
                                                          ),
                                                        )
                                                    ))
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 60.0),
                                            child: Row(
                                                children: List.generate(7, (index3) =>
                                                    SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Center(
                                                          child: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                            // child
                                                            /// Here I used chosen team indexes for reference if the player exist in team
                                                            /// We will show the icon of player else will show blank polygon icon
                                                            child: row3[index3]!=null
                                                                ?SmallImageWidget(
                                                              isBorder: true,
                                                              imageUrl: provider.apiImageUrl + row3[index3]!.imagePath,
                                                              borderColor: row3[index3]!.champCost=='1'?
                                                              Colors.grey:row3[index3]!.champCost=='2'?
                                                              Colors.green:row3[index3]!.champCost=='3'?
                                                              Colors.blue:row3[index3]!.champCost=='4'?
                                                              Colors.purple:row3[index3]!.champCost=='5'?
                                                              Colors.yellow:Colors.red
                                                              ,

                                                            ):
                                                            // ?  Image.network(
                                                            // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                            // height: 60,
                                                            // width: 60,
                                                            // fit: BoxFit
                                                            //     .fill):
                                                            Image.asset(
                                                                'assets/images/Polygon 7.png')

                                                            ,
                                                          ),
                                                        )
                                                    )
                                                )
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 90.0,left: 15),
                                            child: Row(
                                                children: List.generate(7, (index4) =>
                                                    SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Center(
                                                          child: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                            // child
                                                            /// Here I used chosen team indexes for reference if the player exist in team
                                                            /// We will show the icon of player else will show blank polygon icon
                                                            child: row4[index4]!=null
                                                                ?SmallImageWidget(
                                                              isBorder: true,
                                                              imageUrl: provider.apiImageUrl + row4[index4]!.imagePath,
                                                              borderColor: row4[index4]!.champCost=='1'?
                                                              Colors.grey:row4[index4]!.champCost=='2'?
                                                              Colors.green:row4[index4]!.champCost=='3'?
                                                              Colors.blue:row4[index4]!.champCost=='4'?
                                                              Colors.purple:row4[index4]!.champCost=='5'?
                                                              Colors.yellow:Colors.red
                                                              ,

                                                            ):
                                                            // ?  Image.network(
                                                            // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                            // height: 60,
                                                            // width: 60,
                                                            // fit: BoxFit
                                                            //     .fill):
                                                            Image.asset(
                                                                'assets/images/Polygon 7.png')

                                                            ,
                                                          ),
                                                        )
                                                    )
                                                )
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  // Widget _buildHexagon(Size size) {
  //   var w = height(context) * 0.055;
  //   var h = height(context) * 0.055;
  //   return HexagonWidget.pointy(
  //     width: w,
  //     height: h,
  //     child: AspectRatio(
  //       aspectRatio: HexagonType.POINTY.ratio,
  //       child: Image.asset(
  //         AppImages.userImage,
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //   );
  // }
}
