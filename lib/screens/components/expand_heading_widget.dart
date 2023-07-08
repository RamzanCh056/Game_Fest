import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/widgets/responsive_widget.dart';
import 'package:provider/provider.dart';

import '../../constants/exports.dart';
import '../../providers/basic_provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/small_image_widget.dart';
import '../Admin/Model/api_data_model.dart';

class ExpandHeadingWidget extends StatefulWidget {
  final Widget icon;
  final bool isExpand;
  List<ChampModel> champList=[];
  String? docId;
  ExpandHeadingWidget({
    Key? key,
    this.docId,
    required this.icon,
    required this.isExpand,
    required this.champList
  }) : super(key: key);

  @override
  State<ExpandHeadingWidget> createState() => _ExpandHeadingWidgetState();
}

class _ExpandHeadingWidgetState extends State<ExpandHeadingWidget> {
  String baseUrl = 'https://raw.communitydragon.org/latest/game/';
  ///
  ///         16-May-2023
  /// Image path changed
  ///
  String apiImageUrl =  'https://raw.communitydragon.org/pbe/plugins/rcp-be-lol-game-data/global/default/assets/characters/';

  setChampList(){
    champList=widget.champList;
    dataFetched=true;
    setState(() {

    });
  }

  List<ChampModel> champ=[];
  List compCollectionList=[];
  List<String> docIds=[];
  bool dataFetched=false;

  List<ChampModel> champList = [];

  List<String> traits=[];
  bool traitsFiltered=false;

  final Map traitsMap={};
  // List mapKeys=[];
  // List mapValues=[];

  filterTraits(){
    for(int i=0;i<widget.champList.length;i++){

      for(int j=0;j<widget.champList[i].champTraits.length;j++){
        traits.add(widget.champList[i].champTraits[j]);
        print(widget.champList[i].champTraits[j]);
      }
    }


    traits.map((e) =>
    traitsMap.containsKey(e)?traitsMap[e]++:traitsMap[e]=1).toList();
    // print("Traits Length:${traits.length}");
    // print("Traits map Length:${traitsMap.length}");
    // print(traitsMap);
    traitsFiltered==true;

    setState(() {

    });

  }



  @override
  void initState() {
    super.initState();
    widget.champList.sort((a,b)=>a.champName.compareTo(b.champName));
    // fetchFirestoreData();
    // champList=widget.champList;
    // setChampList();
    filterTraits();
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 3),(){
      // fetchImageData();
    });
    print("Init called");

  }

  @override
  Widget build(BuildContext context) {
    // champList=widget.champList;
    return ResponsiveWidget.isWebScreen(context)
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///
                Expanded(
                  child: Container(
                    width: width(context),
                    padding: const EdgeInsets.only(
                        top: 7.0, bottom: 8.0, left: 15.0, right: 20),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          widget.isExpand == true
                              ? Colors.transparent
                              : AppColors.expandBoxColor,
                          widget.isExpand == true
                              ? Colors.transparent
                              : AppColors.expandBoxColor,
                          widget.isExpand == true
                              ? Colors.transparent
                              : AppColors.expandBoxDarkColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /// image
                        const SmallImageWidget(imageUrl: '',),
                        const SizedBox(width: 10),

                        /// name and desc
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Veronica King V',
                                style: poppinsSemiBold.copyWith(
                                  fontSize: 16,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              const SizedBox(height: 1.0),
                              Text(
                                'Hard',
                                style: poppinsRegular.copyWith(
                                  fontSize: 14,
                                  color: AppColors.whiteColor.withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// image with stars
                        Expanded(
                          flex: 6,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if(widget.champList.length>=5)
                              for (int i = 0; i < 5 ; i++)
                                Provider.of<BasicProvider>(context).isVisibleDataFromFirebase?Padding(
                                    // Provider.of<BasicProvider>(context).isVisibleDataFromFirebase?Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  // child: dataFetched?
                                  child:
                                  SmallImageWidget(
                                    // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                    ///
                                    ///  16-May-2023
                                    /// Fetching new image path
                                    ///
                                    ///
                                    imageUrl: "$apiImageUrl${widget.champList[i].imagePath}",
                                    // isBorder: i == 0 || i == 2 ? true : false,
                                    // isShadow: i == 0 || i == 2 ? true : false,
                                    // isStar: i == 2 || i == 3 ? true : false,
                                    ///
                                    /// Date : 14-May-2023
                                    ///
                                    /// Requirement # 2a, 2b, 2c, 2d, 2e
                                    ///
                                    /// Different border colors of images
                                    /// according to the cost of the champion
                                    ///
                                    /// This color representation is for popular
                                    /// category on main screen
                                    ///
                                    borderColor: widget.champList[i].champCost=='1'?
                                        Colors.grey:widget.champList[i].champCost=='2'?
                                    Colors.green:widget.champList[i].champCost=='3'?
                                    Colors.blue:widget.champList[i].champCost=='4'?
                                    Colors.purple:widget.champList[i].champCost=='5'?
                                    Colors.yellow:Colors.red
                                    ,
                                    shadowColor: widget.champList[i].champCost=='1'?
                                    const Color(0x609E9E9E):widget.champList[i].champCost=='2'?
                                    const Color(0x604CAF50):widget.champList[i].champCost=='3'?
                                    const Color(0x602196F3):widget.champList[i].champCost=='4'?
                                    const Color(0x609C27B0):widget.champList[i].champCost=='5'?
                                    const Color(0x60FFEB3B):const Color(0x60F44336),
                                    isBorder: true ,
                                    isShadow:  true ,
                                    isStar: i == 2 || i == 3 ? true : false,
                                  )
                                  // SmallImageWidget(
                                  //   // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                  //   ///
                                  //   ///  16-May-2023
                                  //   /// Fetching new image path
                                  //   ///
                                  //   ///
                                  //   imageUrl: "$apiImageUrl${widget.champList[i].imagePath}",
                                  //   // isBorder: i == 0 || i == 2 ? true : false,
                                  //   // isShadow: i == 0 || i == 2 ? true : false,
                                  //   // isStar: i == 2 || i == 3 ? true : false,
                                  //   ///
                                  //   /// Date : 14-May-2023
                                  //   ///
                                  //   /// Requirement # 2a, 2b, 2c, 2d, 2e
                                  //   ///
                                  //   /// Different border colors of images
                                  //   /// according to the cost of the champion
                                  //   ///
                                  //   /// This color representation is for popular
                                  //   /// category on main screen
                                  //   ///
                                  //   borderColor: widget.champList[i].champCost=='1'?
                                  //   Colors.grey:widget.champList[i].champCost=='2'?
                                  //   Colors.green:widget.champList[i].champCost=='3'?
                                  //   Colors.blue:widget.champList[i].champCost=='4'?
                                  //   Colors.purple:widget.champList[i].champCost=='5'?
                                  //   Colors.yellow:Colors.red
                                  //   ,
                                  //   isBorder: true ,
                                  //   isShadow: i == 0 || i == 2 ? true : false,
                                  //   isStar: i == 2 || i == 3 ? true : false,
                                  // )
                                  // ):const CircularProgressIndicator(),
                                ):
                                Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    // child: dataFetched?
                                    child:
                                    Provider.of<BasicProvider>(context).foundData.any((element) => element.champName==widget.champList[i].champName)?SmallImageWidget(
                                        // Provider.of<BasicProvider>(context).foundData.any((element) => element.champName==widget.champList[i].champName)?SmallImageWidget(
                                      // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                      ///
                                      ///  16-May-2023
                                      /// Fetching new image path
                                      ///
                                      ///
                                      imageUrl: "$apiImageUrl${Provider.of<BasicProvider>(context).foundData[i].imagePath}",
                                      // isBorder: i == 0 || i == 2 ? true : false,
                                      // isShadow: i == 0 || i == 2 ? true : false,
                                      // isStar: i == 2 || i == 3 ? true : false,
                                      ///
                                      /// Date : 14-May-2023
                                      ///
                                      /// Requirement # 2a, 2b, 2c, 2d, 2e
                                      ///
                                      /// Different border colors of images
                                      /// according to the cost of the champion
                                      ///
                                      /// This color representation is for popular
                                      /// category on main screen
                                      ///
                                      borderColor: Provider.of<BasicProvider>(context).foundData[i].champCost=='1'?
                                      Colors.grey:Provider.of<BasicProvider>(context).foundData[i].champCost=='2'?
                                      Colors.green:Provider.of<BasicProvider>(context).foundData[i].champCost=='3'?
                                      Colors.blue:Provider.of<BasicProvider>(context).foundData[i].champCost=='4'?
                                      Colors.purple:Provider.of<BasicProvider>(context).foundData[i].champCost=='5'?
                                      Colors.yellow:Colors.red
                                      ,
                                      shadowColor: Provider.of<BasicProvider>(context).foundData[i].champCost=='1'?
                                      Colors.grey:Provider.of<BasicProvider>(context).foundData[i].champCost=='2'?
                                      Colors.green:Provider.of<BasicProvider>(context).foundData[i].champCost=='3'?
                                      Colors.blue:Provider.of<BasicProvider>(context).foundData[i].champCost=='4'?
                                      Colors.purple:Provider.of<BasicProvider>(context).foundData[i].champCost=='5'?
                                      Colors.yellow:Colors.red
                                      ,
                                      isBorder: true ,
                                      isShadow:  true ,
                                      isStar: true,
                                      // isStar: i == 2 || i == 3 ? true : false,
                                    ):
                                    null

                                ),
                              if(widget.champList.length<5)
                                for (int i = 0; i < widget.champList.length ; i++)
                                  Provider.of<BasicProvider>(context).isVisibleDataFromFirebase?Padding(
    // Provider.of<BasicProvider>(context).isVisibleDataFromFirebase?Padding(
                                      padding: const EdgeInsets.only(right: 12.0),
                                      // child: dataFetched?
                                      child:
                                      SmallImageWidget(
                                        // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                        ///
                                        ///  16-May-2023
                                        /// Fetching new image path
                                        ///
                                        ///
                                        imageUrl: "$apiImageUrl${widget.champList[i].imagePath}",
                                        // isBorder: i == 0 || i == 2 ? true : false,
                                        // isShadow: i == 0 || i == 2 ? true : false,
                                        // isStar: i == 2 || i == 3 ? true : false,
                                        ///
                                        /// Date : 14-May-2023
                                        ///
                                        /// Requirement # 2a, 2b, 2c, 2d, 2e
                                        ///
                                        /// Different border colors of images
                                        /// according to the cost of the champion
                                        ///
                                        /// This color representation is for popular
                                        /// category on main screen
                                        ///
                                        borderColor: widget.champList[i].champCost=='1'?
                                        Colors.grey:widget.champList[i].champCost=='2'?
                                        Colors.green:widget.champList[i].champCost=='3'?
                                        Colors.blue:widget.champList[i].champCost=='4'?
                                        Colors.purple:widget.champList[i].champCost=='5'?
                                        Colors.yellow:Colors.red
                                        ,
                                        shadowColor: widget.champList[i].champCost=='1'?
                                        const Color(0x609E9E9E):widget.champList[i].champCost=='2'?
                                        const Color(0x604CAF50):widget.champList[i].champCost=='3'?
                                        const Color(0x602196F3):widget.champList[i].champCost=='4'?
                                        const Color(0x609C27B0):widget.champList[i].champCost=='5'?
                                        const Color(0x60FFEB3B):const Color(0x60F44336),
                                        isBorder: true ,
                                        isShadow:  true ,
                                        isStar: i == 2 || i == 3 ? true : false,
                                      )
                                    // SmallImageWidget(
                                    //   // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                    //   ///
                                    //   ///  16-May-2023
                                    //   /// Fetching new image path
                                    //   ///
                                    //   ///
                                    //   imageUrl: "$apiImageUrl${widget.champList[i].imagePath}",
                                    //   // isBorder: i == 0 || i == 2 ? true : false,
                                    //   // isShadow: i == 0 || i == 2 ? true : false,
                                    //   // isStar: i == 2 || i == 3 ? true : false,
                                    //   ///
                                    //   /// Date : 14-May-2023
                                    //   ///
                                    //   /// Requirement # 2a, 2b, 2c, 2d, 2e
                                    //   ///
                                    //   /// Different border colors of images
                                    //   /// according to the cost of the champion
                                    //   ///
                                    //   /// This color representation is for popular
                                    //   /// category on main screen
                                    //   ///
                                    //   borderColor: widget.champList[i].champCost=='1'?
                                    //   Colors.grey:widget.champList[i].champCost=='2'?
                                    //   Colors.green:widget.champList[i].champCost=='3'?
                                    //   Colors.blue:widget.champList[i].champCost=='4'?
                                    //   Colors.purple:widget.champList[i].champCost=='5'?
                                    //   Colors.yellow:Colors.red
                                    //   ,
                                    //   isBorder: true ,
                                    //   isShadow: i == 0 || i == 2 ? true : false,
                                    //   isStar: i == 2 || i == 3 ? true : false,
                                    // )
                                    // ):const CircularProgressIndicator(),
                                  ):
                                  Padding(
                                      padding: const EdgeInsets.only(right: 12.0),
                                      // child: Provider.of<BasicProvider>(context).foundData.any((element) => element.champName==widget.champList[i].champName)?SmallImageWidget(
                                      child: Provider.of<BasicProvider>(context).foundData.any((element) => element.champName==widget.champList[i].champName)?SmallImageWidget(

                                        // child: dataFetched?SmallImageWidget(
                                        imageUrl: "$apiImageUrl${Provider.of<BasicProvider>(context).foundData[i].imagePath}",
                                        borderColor: Provider.of<BasicProvider>(context).foundData[i].champCost=='1'?
                                        Colors.grey:Provider.of<BasicProvider>(context).foundData[i].champCost=='2'?
                                        Colors.green:Provider.of<BasicProvider>(context).foundData[i].champCost=='3'?
                                        Colors.blue:Provider.of<BasicProvider>(context).foundData[i].champCost=='4'?
                                        Colors.purple:Provider.of<BasicProvider>(context).foundData[i].champCost=='5'?
                                        Colors.yellow:Colors.red
                                        ,
                                        shadowColor: Provider.of<BasicProvider>(context).foundData[i].champCost=='1'?
                                        const Color(0x609E9E9E):Provider.of<BasicProvider>(context).foundData[i].champCost=='2'?
                                        const Color(0x604CAF50):Provider.of<BasicProvider>(context).foundData[i].champCost=='3'?
                                        const Color(0x602196F3):Provider.of<BasicProvider>(context).foundData[i].champCost=='4'?
                                        const Color(0x609C27B0):Provider.of<BasicProvider>(context).foundData[i].champCost=='5'?
                                        const Color(0x60FFEB3B):const Color(0x60F44336),
                                        isBorder:  true,
                                        isShadow: true,
                                        isStar: true,
                                      ):
                                      null
                                    // SmallImageWidget(
                                    //   // child: dataFetched?SmallImageWidget(
                                    //   imageUrl: "$apiImageUrl${widget.champList[i].imagePath}",
                                    //   borderColor: widget.champList[i].champCost=='1'?
                                    //   Colors.grey:widget.champList[i].champCost=='2'?
                                    //   Colors.green:widget.champList[i].champCost=='3'?
                                    //   Colors.blue:widget.champList[i].champCost=='4'?
                                    //   Colors.purple:widget.champList[i].champCost=='5'?
                                    //   Colors.yellow:Colors.red
                                    //   ,
                                    //
                                    //   isBorder:  true,
                                    //   isShadow: true,
                                    //   isStar: true,
                                    // )
                                    // :const CircularProgressIndicator(),
                                  ),
                            ],
                          ),
                        ),

                        /// arrow down icon
                        const Icon(Icons.arrow_drop_down,color: Colors.white,size: 30,)
                        // widget.icon,
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                /// pin icon
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SvgPicture.asset(AppIcons.pin, height: 20),
                ),
              ],
            ),
          )
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        height: 60,
        width: width(context),
        padding: const EdgeInsets.only(
            top: 7.0, bottom: 8.0, left: 6.0, right: 6),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              widget.isExpand == true
                  ? Colors.transparent
                  : AppColors.expandBoxColor,
              widget.isExpand == true
                  ? Colors.transparent
                  : AppColors.expandBoxColor,
              widget.isExpand == true
                  ? Colors.transparent
                  : AppColors.expandBoxDarkColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: width(context)>=700?Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            /// image
            const SmallImageWidget(imageUrl: '',imageHeight: 30,imageWidth: 30,),
            // const SizedBox(width: 5),

            /// name and desc
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Veronica King V'.length>8?'Veronica King V'.substring(0,8):'Veronica King V',
                  style: poppinsSemiBold.copyWith(
                    fontSize: 14,
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(height: 1.0),
                Text(
                  'Hard',
                  style: poppinsRegular.copyWith(
                    fontSize: 14,
                    color: AppColors.whiteColor.withOpacity(0.4),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            /// image with stars

            SizedBox(
              width: width(context)*.35,
              child: ListView.builder(
                // padding: EdgeInsets.zero,
                // itemExtent: 33,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.champList.length>=4?4:widget.champList.length,
                  itemBuilder: (context,i)
                  {
                    return Provider.of<BasicProvider>(context).isVisibleDataFromFirebase?SmallImageWidget(
                      // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                      ///
                      ///  16-May-2023
                      /// Fetching new image path
                      ///
                      ///
                      imageUrl: "$apiImageUrl${widget.champList[i].imagePath}",
                      // isBorder: i == 0 || i == 2 ? true : false,
                      // isShadow: i == 0 || i == 2 ? true : false,
                      // isStar: i == 2 || i == 3 ? true : false,
                      ///
                      /// Date : 14-May-2023
                      ///
                      /// Requirement # 2a, 2b, 2c, 2d, 2e
                      ///
                      /// Different border colors of images
                      /// according to the cost of the champion
                      ///
                      /// This color representation is for popular
                      /// category on main screen
                      ///
                      borderColor: widget.champList[i].champCost=='1'?
                      Colors.grey:widget.champList[i].champCost=='2'?
                      Colors.green:widget.champList[i].champCost=='3'?
                      Colors.blue:widget.champList[i].champCost=='4'?
                      Colors.purple:widget.champList[i].champCost=='5'?
                      Colors.yellow:Colors.red
                      ,
                      shadowColor: widget.champList[i].champCost=='1'?
                      const Color(0x609E9E9E):widget.champList[i].champCost=='2'?
                      const Color(0x604CAF50):widget.champList[i].champCost=='3'?
                      const Color(0x602196F3):widget.champList[i].champCost=='4'?
                      const Color(0x609C27B0):widget.champList[i].champCost=='5'?
                      const Color(0x60FFEB3B):const Color(0x60F44336),
                      imageHeight: 30,
                      imageWidth: 30,
                      isBorder: true ,
                      isShadow:  true ,
                      // isStar: i == 2 || i == 3 ? true : false,
                    ):
                    Padding(
                        padding: const EdgeInsets.only(right: 1.0),
                        // child: dataFetched?
                        child:
                        Provider.of<BasicProvider>(context).foundData.any((element) => element.champName==widget.champList[i].champName)?SmallImageWidget(
                          // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                          ///
                          ///  16-May-2023
                          /// Fetching new image path
                          ///
                          ///
                          imageUrl: "$apiImageUrl${Provider.of<BasicProvider>(context).foundData[i].imagePath}",
                          // isBorder: i == 0 || i == 2 ? true : false,
                          // isShadow: i == 0 || i == 2 ? true : false,
                          // isStar: i == 2 || i == 3 ? true : false,
                          ///
                          /// Date : 14-May-2023
                          ///
                          /// Requirement # 2a, 2b, 2c, 2d, 2e
                          ///
                          /// Different border colors of images
                          /// according to the cost of the champion
                          ///
                          /// This color representation is for popular
                          /// category on main screen
                          ///
                          borderColor: Provider.of<BasicProvider>(context).foundData[i].champCost=='1'?
                          Colors.grey:Provider.of<BasicProvider>(context).foundData[i].champCost=='2'?
                          Colors.green:Provider.of<BasicProvider>(context).foundData[i].champCost=='3'?
                          Colors.blue:Provider.of<BasicProvider>(context).foundData[i].champCost=='4'?
                          Colors.purple:Provider.of<BasicProvider>(context).foundData[i].champCost=='5'?
                          Colors.yellow:Colors.red,
                          shadowColor: Provider.of<BasicProvider>(context).foundData[i].champCost=='1'?
                          Colors.grey:Provider.of<BasicProvider>(context).foundData[i].champCost=='2'?
                          Colors.green:Provider.of<BasicProvider>(context).foundData[i].champCost=='3'?
                          Colors.blue:Provider.of<BasicProvider>(context).foundData[i].champCost=='4'?
                          Colors.purple:Provider.of<BasicProvider>(context).foundData[i].champCost=='5'?
                          Colors.yellow:Colors.red,
                          isBorder: true ,
                          isShadow:  true ,
                          // isStar: true,
                          imageHeight: 30,
                          imageWidth: 30,
                          // isStar: i == 2 || i == 3 ? true : false,
                        ):
                        null

                    );
                  }),
            ),

            /// arrow down icon
            Icon(Icons.arrow_drop_down,color: Colors.white,size: 30,)
            // widget.icon,
          ],
        ):
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            /// image
            const SmallImageWidget(imageUrl: '',imageHeight: 30,imageWidth: 30,),
            // const SizedBox(width: 5),

            /// name and desc
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Veronica King V'.length>8?'Veronica King V'.substring(0,8):'Veronica King V',
                  style: poppinsSemiBold.copyWith(
                    fontSize: 14,
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(height: 1.0),
                Text(
                  'Hard',
                  style: poppinsRegular.copyWith(
                    fontSize: 14,
                    color: AppColors.whiteColor.withOpacity(0.4),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            /// image with stars

            SizedBox(
              width: width(context)>320&&width(context)<700?
              width(context)*.32:width(context)<320?width(context)*.25:
              width(context)>700?width(context)*.4:null,
              child: ListView.builder(
                // padding: EdgeInsets.zero,
                itemExtent: width(context)<372?width(context)*.1:null,
                shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.champList.length>=3?3:widget.champList.length,
                  itemBuilder: (context,i)
                  {
                    return Provider.of<BasicProvider>(context).isVisibleDataFromFirebase?SmallImageWidget(
                      // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                      ///
                      ///  16-May-2023
                      /// Fetching new image path
                      ///
                      ///
                      imageUrl: "$apiImageUrl${widget.champList[i].imagePath}",
                      // isBorder: i == 0 || i == 2 ? true : false,
                      // isShadow: i == 0 || i == 2 ? true : false,
                      // isStar: i == 2 || i == 3 ? true : false,
                      ///
                      /// Date : 14-May-2023
                      ///
                      /// Requirement # 2a, 2b, 2c, 2d, 2e
                      ///
                      /// Different border colors of images
                      /// according to the cost of the champion
                      ///
                      /// This color representation is for popular
                      /// category on main screen
                      ///
                      borderColor: widget.champList[i].champCost=='1'?
                      Colors.grey:widget.champList[i].champCost=='2'?
                      Colors.green:widget.champList[i].champCost=='3'?
                      Colors.blue:widget.champList[i].champCost=='4'?
                      Colors.purple:widget.champList[i].champCost=='5'?
                      Colors.yellow:Colors.red
                      ,
                      shadowColor: widget.champList[i].champCost=='1'?
                      const Color(0x609E9E9E):widget.champList[i].champCost=='2'?
                      const Color(0x604CAF50):widget.champList[i].champCost=='3'?
                      const Color(0x602196F3):widget.champList[i].champCost=='4'?
                      const Color(0x609C27B0):widget.champList[i].champCost=='5'?
                      const Color(0x60FFEB3B):const Color(0x60F44336),
                      imageHeight: 30,
                      imageWidth: 30,
                      isBorder: true ,
                      isShadow:  true ,
                      // isStar: i == 2 || i == 3 ? true : false,
                    ):
                    Padding(
                        padding: const EdgeInsets.only(right: 1.0),
                        // child: dataFetched?
                        child:
                        Provider.of<BasicProvider>(context).foundData.any((element) => element.champName==widget.champList[i].champName)?SmallImageWidget(
                          // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                          ///
                          ///  16-May-2023
                          /// Fetching new image path
                          ///
                          ///
                          imageUrl: "$apiImageUrl${Provider.of<BasicProvider>(context).foundData[i].imagePath}",
                          // isBorder: i == 0 || i == 2 ? true : false,
                          // isShadow: i == 0 || i == 2 ? true : false,
                          // isStar: i == 2 || i == 3 ? true : false,
                          ///
                          /// Date : 14-May-2023
                          ///
                          /// Requirement # 2a, 2b, 2c, 2d, 2e
                          ///
                          /// Different border colors of images
                          /// according to the cost of the champion
                          ///
                          /// This color representation is for popular
                          /// category on main screen
                          ///
                          borderColor: Provider.of<BasicProvider>(context).foundData[i].champCost=='1'?
                          Colors.grey:Provider.of<BasicProvider>(context).foundData[i].champCost=='2'?
                          Colors.green:Provider.of<BasicProvider>(context).foundData[i].champCost=='3'?
                          Colors.blue:Provider.of<BasicProvider>(context).foundData[i].champCost=='4'?
                          Colors.purple:Provider.of<BasicProvider>(context).foundData[i].champCost=='5'?
                          Colors.yellow:Colors.red,
                          shadowColor: Provider.of<BasicProvider>(context).foundData[i].champCost=='1'?
                          Colors.grey:Provider.of<BasicProvider>(context).foundData[i].champCost=='2'?
                          Colors.green:Provider.of<BasicProvider>(context).foundData[i].champCost=='3'?
                          Colors.blue:Provider.of<BasicProvider>(context).foundData[i].champCost=='4'?
                          Colors.purple:Provider.of<BasicProvider>(context).foundData[i].champCost=='5'?
                          Colors.yellow:Colors.red,
                          isBorder: true ,
                          isShadow:  true ,
                          // isStar: true,
                          imageHeight: 30,
                          imageWidth: 30,
                          // isStar: i == 2 || i == 3 ? true : false,
                        ):
                        null

                    );
                  }),
            ),

            /// arrow down icon
            const Icon(Icons.arrow_drop_down,color: Colors.white,size: 30,)
            // widget.icon,
          ],
        ),
      ),
    );
  }
}
