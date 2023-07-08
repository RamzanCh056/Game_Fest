import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/providers/basic_provider.dart';
import '/screens/components/search_bar.dart';
import '/widgets/responsive_widget.dart';
import 'package:provider/provider.dart';

import '../../constants/exports.dart';
import '../../providers/search_provider.dart';
import '../Admin/Model/api_data_model.dart';
import 'neon_tab_button.dart';

class LeftSideWidget extends StatefulWidget {
  const LeftSideWidget({Key? key}) : super(key: key);

  @override
  State<LeftSideWidget> createState() => _LeftSideWidgetState();
}

class _LeftSideWidgetState extends State<LeftSideWidget> {
  String baseUrl = 'https://raw.communitydragon.org/latest/game/';
  ///
  ///         16-May-2023
  /// Image path changed
  ///
  String apiImageUrl =  'https://raw.communitydragon.org/pbe/plugins/rcp-be-lol-game-data/global/default/assets/characters/';

  List<ChampModel> champListFromFirebase =[];
  // List<String?> champNamesList = [];
  // List<String> docIds =[];

  /// Date 14-May-2023
  ///
  /// Requirement # 3
  /// Filter or Search champion in Main screen
  ///
  /// Search Functionality, Logic/Algorithm
  /// is written below
  ///
  TextEditingController searchController = TextEditingController();

  List<ChampModel> foundData=[];
  bool visibleSearchData = false;
  bool isVisibleDataFromFirebase=false;
  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    setState(() {
      visibleSearchData=true;
      isVisibleDataFromFirebase=false;
    });
    List<ChampModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = champListFromFirebase;
      setState(() {
        isVisibleDataFromFirebase=true;
      });
    } else {
      isVisibleDataFromFirebase=false;
      // print(enteredKeyword);
      results = champListFromFirebase.where((user) =>
          user.champName.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      
      // print(results);
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      foundData = results;
    });
  }



  // List<String> sortedChampList=[];

  fetchFirestoreData()async{
    QuerySnapshot champCollectionFromFirestore = await FirebaseFirestore.instance.collection(champCollection).get();

    print("I am fetch from firestore");
    if(champCollectionFromFirestore.docs.isNotEmpty){
      print(champCollectionFromFirestore.size);
      champListFromFirebase.clear();
      // docIds.clear();

      // chosenTeam.clear();
      // chosenTeamIndexes.clear();
      for(int i=0;i<champCollectionFromFirestore.docs.length;i++){
        ChampModel championFromFirestore = ChampModel.fromJsonFirebase(champCollectionFromFirestore.docs[i]);
        champListFromFirebase.add(championFromFirestore);
        // champNamesList.add(championFromFirestore.champName);
        // docIds.add(champCollectionFromFirestore.docs[i].id);
      }

      champListFromFirebase.sort((a,b)=>"${a.champName.length>4?a.champName.substring(0,4):a.champName}${a.champCost}".compareTo("${b.champName.length>4?b.champName.substring(0,4):b.champName}${b.champCost}"));

      // foundData = champListFromFirebase;
      Provider.of<BasicProvider>(context,listen: false).updateFirebaseDataFetchedLeftSideWidget(champListFromFirebase);
      // Provider.of<SearchProvider>(context,listen: false).updateFirebaseDataFetchedLeftSideWidget(champListFromFirebase);

      // champListFromFirebase.sort((a,b)=>a.champCost!.compareTo(b.champCost!));
      isVisibleDataFromFirebase=true;
      setState((){});
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFirestoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// champoins and traits widget
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeonTabButtonWidget(
              onTap: null,
              gradient: LinearGradient(
                colors: [
                  AppColors.pinkBorderColor,
                  AppColors.pinkBorderColor.withOpacity(0.2),
                  AppColors.pinkBorderColor.withOpacity(0.0),
                  AppColors.pinkBorderColor.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              btnHeight: 55,
              btnWidth: ResponsiveWidget.isWebScreen(context)
                  ? width(context) * 0.15
                  : ResponsiveWidget.isTabletScreen(context)
                      ? width(context) * 0.2
                      : width(context) * 0.3,
              btnText: 'Champions/Traits',
            ),
          ],
        ),

        /// box
        Container(
          height: height(context),
          width: width(context),
          margin: const EdgeInsets.only(top: 36),
          padding: ResponsiveWidget.isWebScreen(context)
              ? const EdgeInsets.symmetric(horizontal: 20)
              : const EdgeInsets.symmetric(horizontal: 8),
          decoration: leftSideBoxDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// search field and filter btn
              SizedBox(height: height(context) * 0.03),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    // child: CustomSearchBar(champs: champListFromFirebase,),
                    child: TextFormField(
                      // onChanged: (value) => _runFilter(value),
                      // onChanged: (value) => Provider.of<BasicProvider>(context,listen: false).runFilter(value),
                      onChanged: (value) {
                        Provider.of<BasicProvider>(context,listen: false).runFilter(value,false);
                        setState(() {

                        });
                      } ,
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      style: poppinsRegular.copyWith(
                        fontSize: 14,
                        color: AppColors.whiteColor,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Search',
                        hintStyle: poppinsRegular.copyWith(
                          fontSize: 14,
                          color: AppColors.whiteColor.withOpacity(0.4),
                        ),
                        fillColor: AppColors.fieldColor.withOpacity(0.4),
                        contentPadding: const EdgeInsets.only(top: 8.0),
                        prefixIcon: SvgPicture.asset(AppIcons.search, fit: BoxFit.scaleDown),
                        constraints: const BoxConstraints(
                          minHeight: 36,
                          maxHeight: 36,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.fieldColor.withOpacity(0.4),
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.fieldColor.withOpacity(0.4),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.fieldColor.withOpacity(0.4),
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: height(context) * 0.01),
                  Material(
                    color: Colors.transparent,
                    child: PopupMenuButton(
                      onSelected: (value){
                        if(value=="A-Z"){
                          Provider.of<BasicProvider>(context,listen: false).sortChampList(false);
                          // Provider.of<BasicProvider>(context,listen: false).sortCompChampListByAtoZ();
                          // sortByName();
                        }else if(value=="Z-A"){
                          Provider.of<BasicProvider>(context,listen: false).sortChampListZtoA(false);
                          // Provider.of<BasicProvider>(context,listen: false).sortCompChampListByAtoZ();
                          // sortByNameReversed();
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            value: "A-Z",
                            child: Text("A-Z / Z-A"),

                          ),
                          // const PopupMenuItem(
                          //   value: "Z-A",
                          //   child: Text("Z-A"),
                          //
                          // ),
                          // const PopupMenuItem(
                          //   value:"By Traits",
                          //   child: Text("By Traits"),
                          //
                          // ),
                        ];
                      },
                      child: Center(
                        child: SvgPicture.asset(AppIcons.filter),
                      ),
                    ),
                  ),
                ],
              ),

              /// images
              ///
              /// Date 14-May-2023
              ///
              /// Here We are showing two features
              /// 1) If search field is empty, than we are showing data
              ///    from firebase
              ///
              /// 2) If search field is active and is not empty we are
              ///    showing found data in the search
              ///
              Expanded(
                child: Provider.of<BasicProvider>(context).isVisibleDataFromFirebase?
                // child: Provider.of<SearchProvider>(context).isVisibleDataFromFirebase?
                ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        // for (int i = 0; i < champListFromFirebase.length; i++)
                          for (int i = 0; i < Provider.of<BasicProvider>(context).champListFromFirebase.length; i++)
                            // for (int i = 0; i < Provider.of<SearchProvider>(context).champListFromFirebase.length; i++)
                          Container(
                            height: height(context) * 0.07,
                            width: height(context) * 0.07,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17),
                              border: Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='1'
                                // border: Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='1'
                                  ? Border.all(
                                      // color: AppColors.skyBorderColor,
                                color: Colors.grey,
                                      width: 2.27,
                                    )
                                  : Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='2'?
                                  // : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='2'?
                              Border.all(
                                // color: AppColors.skyBorderColor,
                                color: Colors.green,
                                width: 2.27,
                              )
                                  :Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='3'?
                                  // :Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='3'?
                              Border.all(
                                // color: AppColors.skyBorderColor,
                                color: Colors.blue,
                                width: 2.27,

                              ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='4'?
                                 // ):Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='4'?
                              Border.all(
                                // color: AppColors.skyBorderColor,
                                color: Colors.purple,
                                width: 2.27,
                              ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='5'?
                              Border.all(
                                // color: AppColors.skyBorderColor,
                                color: Colors.yellow,
                                width: 2.27,
                              ):
                              Border.all(
                                // color: AppColors.skyBorderColor,
                                color: Colors.red,
                                width: 2.27,
                              ),
                              boxShadow: [
                                Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='1'
                                    ? BoxShadow(
                                        color: Colors.grey
                                            .withOpacity(0.6),
                                        blurRadius: 10,
                                      ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='2'
                                    ? BoxShadow(
                                  color: Colors.green
                                      .withOpacity(0.6),
                                  blurRadius: 10,
                                ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='3'
                                    ? BoxShadow(
                                  color: Colors.blue
                                      .withOpacity(0.6),
                                  blurRadius: 10,
                                ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='4'
                                    ? BoxShadow(
                                  color: Colors.purple
                                      .withOpacity(0.6),
                                  blurRadius: 10,
                                ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='5'
                                    ? BoxShadow(
                                  color: Colors.yellow
                                      .withOpacity(0.6),
                                  blurRadius: 10,
                                ):BoxShadow(
                                  color: Colors.red
                                      .withOpacity(0.6),
                                  blurRadius: 10,
                                )

                              ]
    ,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                  // image: NetworkImage('${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}'))
                                  ///
                                  ///  16-May-2023
                                  ///  New Image path fetched from firebase
                                  ///  and shown
                                  ///
                                  image: NetworkImage(apiImageUrl + Provider.of<BasicProvider>(context).champListFromFirebase[i].imagePath.toString().toLowerCase()))


                            ),
                            // child: Text(Provider.of<BasicProvider>(context).champListFromFirebase[i].champName,style: const TextStyle(color: Colors.white),),
                            // child: Image.network(
                            //     '${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                            //     height: 60,
                            //     width: 60,
                            //
                            //     fit: BoxFit
                            //         .fill),
                          )
                      ],
                    ),
                  ],
                ):
                ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        for (int i = 0; i < Provider.of<BasicProvider>(context).foundData.length; i++)...[
                          Container(
                            height: height(context) * 0.07,
                            width: height(context) * 0.07,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17),
                                border: Provider.of<BasicProvider>(context).foundData[i].champCost=='1'
                                    ? Border.all(
                                  // color: AppColors.skyBorderColor,
                                  color: Colors.grey,
                                  width: 2.27,
                                )
                                    : Provider.of<BasicProvider>(context).foundData[i].champCost=='2'?
                                Border.all(
                                  // color: AppColors.skyBorderColor,
                                  color: Colors.green,
                                  width: 2.27,
                                )
                                    :Provider.of<BasicProvider>(context).foundData[i].champCost=='3'?
                                Border.all(
                                  // color: AppColors.skyBorderColor,
                                  color: Colors.blue,
                                  width: 2.27,
                                ):Provider.of<BasicProvider>(context).foundData[i].champCost=='4'?
                                Border.all(
                                  // color: AppColors.skyBorderColor,
                                  color: Colors.purple,
                                  width: 2.27,
                                ):Provider.of<BasicProvider>(context).foundData[i].champCost=='5'?
                                Border.all(
                                  // color: AppColors.skyBorderColor,
                                  color: Colors.yellow,
                                  width: 2.27,
                                ):
                                Border.all(
                                  // color: AppColors.skyBorderColor,
                                  color: Colors.red,
                                  width: 2.27,
                                ),
                                boxShadow: [
                                  Provider.of<BasicProvider>(context).foundData[i].champCost=='1'
                                      ? BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.6),
                                    blurRadius: 10,
                                  ):Provider.of<BasicProvider>(context).foundData[i].champCost=='2'
                                      ? BoxShadow(
                                    color: Colors.green
                                        .withOpacity(0.6),
                                    blurRadius: 10,
                                  ):Provider.of<BasicProvider>(context).foundData[i].champCost=='3'
                                      ? BoxShadow(
                                    color: Colors.blue
                                        .withOpacity(0.6),
                                    blurRadius: 10,
                                  ):Provider.of<BasicProvider>(context).foundData[i].champCost=='4'
                                      ? BoxShadow(
                                    color: Colors.purple
                                        .withOpacity(0.6),
                                    blurRadius: 10,
                                  ):Provider.of<BasicProvider>(context).foundData[i].champCost=='5'
                                      ? BoxShadow(
                                    color: Colors.yellow
                                        .withOpacity(0.6),
                                    blurRadius: 10,
                                  ):BoxShadow(
                                    color: Colors.red
                                        .withOpacity(0.6),
                                    blurRadius: 10,
                                  )

                                ]
                                    ,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    // image: NetworkImage('${baseUrl + foundData[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}'))
                                    ///
                                    ///  16-May-2023
                                    ///  New Image path fetched from firebase
                                    ///  and shown
                                    ///
                                    image: NetworkImage(apiImageUrl + Provider.of<BasicProvider>(context).foundData[i].imagePath.toString().toLowerCase()))

                            ),
                            // child: Image.network(
                            //     '${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                            //     height: 60,
                            //     width: 60,
                            //
                            //     fit: BoxFit
                            //         .fill),
                          ),
                          // Text("Champ Name: ${Provider.of<BasicProvider>(context).foundData[i].champName}",style: const TextStyle(color: Colors.white),)
                        ]
                          
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
