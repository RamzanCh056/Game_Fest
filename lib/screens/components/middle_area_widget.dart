import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../providers/basic_provider.dart';
import '/Static/static.dart';
import '/screens/Admin/Model/admin_model.dart';
import '/screens/components/expand_item_widget.dart';
import '/screens/components/small_buttons.dart';
import '/widgets/responsive_widget.dart';
import 'package:provider/provider.dart';

import '../../constants/exports.dart';
import '../../providers/comp_list_provider.dart';
import '../../services/firestore services/firestore_comp_services.dart';
import '../Admin/Model/api_data_model.dart';
import 'team_builder_screen.dart';
import 'neon_tab_button.dart';

class MiddleAreaWidget extends StatefulWidget {
  const MiddleAreaWidget({Key? key}) : super(key: key);

  @override
  State<MiddleAreaWidget> createState() => _MiddleAreaWidgetState();
}

class _MiddleAreaWidgetState extends State<MiddleAreaWidget> {
  List<AddFormData> FormData = [];

  /// Requirement # 4
  ///
  /// These are the Lists used to fetch firestore data in order to show
  /// data in the popular field

  // List<ChampModel> championsList=[];
  List<CompCollectionModel> compCollectionList=[];
  // List<String> docIds=[];
  bool dataFetched=false;

  List<List<ChampModel>> compChampionsList=[];
  List<String> docIds=[];


  List<String> traits=[];
  bool traitsFiltered=false;

  final Map traitsMap={};

  fetchFirestoreData()async{

    FirebaseFirestore instance=FirebaseFirestore.instance;
    QuerySnapshot compQuery=await instance.collection(compCollection).get();
    if(compQuery.docs.isNotEmpty){
      for(int i=0;i<compQuery.docs.length;i++){
        CompCollectionModel singleComp= CompCollectionModel.fromJson(compQuery.docs[i]);
        compCollectionList.add(singleComp);
        docIds.add(compQuery.docs[i].id);
        QuerySnapshot champQuery=await instance.collection(compCollection).doc(compQuery.docs[i].id).collection(champCollection).get();
        List<ChampModel> champListFromQurey=[];
        for(int j=0;j<champQuery.docs.length;j++){
          ChampModel champFromQuery=ChampModel.fromJsonFirebase(champQuery.docs[j]);
          champListFromQurey.add(champFromQuery);
        }
        Provider.of<BasicProvider>(context,listen: false).compChampList.add(champListFromQurey);
      }


      setState(() {

      });


      dataFetched=true;
    }else if(compQuery.docs.isEmpty){
      dataFetched=true;

      setState(() {

      });
    }

  }



  @override
  void initState() {
    // FirestoreCompServices().fetchFirestoreData(context);
    fetchFirestoreData();
    // getFormData();
    super.initState();
  }

  bool one = false;
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.isWebScreen(context)
        ? Stack(
            children: [
              /// top tab and buttons
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// popular btn
                    NeonTabButtonWidget(
                      onTap: () {},
                      gradient: LinearGradient(
                        colors: [
                          AppColors.skyBorderColor,
                          AppColors.skyBorderColor.withOpacity(0.2),
                          AppColors.skyBorderColor.withOpacity(0.0),
                          AppColors.skyBorderColor.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      btnHeight: 55,
                      btnWidth: width(context) * 0.1,
                      btnText: 'Popular',
                    ),
                    const SizedBox(width: 17),

                    /// my team btn
                    NeonTabButtonWidget(
                      onTap: () {},
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.mainDarkColor,
                          AppColors.mainDarkColor,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      btnHeight: 55,
                      btnWidth: width(context) * 0.1,
                      btnText: 'My Teams',
                      btnTextColor: AppColors.whiteColor.withOpacity(0.4),
                    ),

                    const Spacer(),

                    ///
                    /// 16-May-2023
                    /// Requirement #4
                    /// Tier up, Tier down,New Tier buttons are removed
                    /// Team builder button is added
                    ///
                    SmallButtons(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const TeamBuilderScreen()));
                      },
                      iconPath: AppIcons.tierUp,
                      btnText: 'Team Builder',
                      btnColor: AppColors.orangeDarkColor,

                    ),
                    // const SizedBox(width: 10),
                    // SmallButtons(
                    //   onTap: () {},
                    //   iconPath: AppIcons.tierDown,
                    //   btnText: 'Tier Down',
                    //   btnColor: AppColors.redDarkColor,
                    // ),
                    // const SizedBox(width: 10),
                    // SmallButtons(
                    //   onTap: () {},
                    //   iconPath: AppIcons.addIcon,
                    //   btnText: 'New Tier',
                    //   btnColor: AppColors.skyDarkColor,
                    // ),
                  ],
                ),
              ),

              ///
              Container(
                height: height(context),
                width: width(context),
                margin: const EdgeInsets.only(top: 36),
                decoration: middleBoxDecoration(context),
                ///
                ///
                /// Here we are showing the data fetched from firebase
                ///

                // child: compCollectionList.isNotEmpty?
                child:
                dataFetched==true && compCollectionList.isNotEmpty?
    //                 Provider.of<CompListProvider>(context).isDataFetched &&
    //                     Provider.of<CompListProvider>(context).compChampionsList.isNotEmpty ?
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: const Color(0x00ffffff),
                    shadowColor: const Color(0x00ffffff),
                  ),
                  child: ReorderableListView(
                    // itemCount: docIds.length,
                    // itemBuilder: (context,index){
                    //   return
                    buildDefaultDragHandles: false,

                    onReorder: (int oldIndex, int newIndex) {

                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        CompCollectionModel compDrag=compCollectionList.removeAt(oldIndex);
                        List<ChampModel> chamDragList=compChampionsList.removeAt(oldIndex);
                        compCollectionList.insert(newIndex, compDrag);
                        compChampionsList.insert(newIndex, chamDragList);

                        // final String newDocId = docIds.removeAt(oldIndex);
                        // docIds.insert(newIndex, newDocId);
                      });
                    },
                    // itemCount: docIds.length,
                    // itemBuilder: (context,index){
                    //   return
                    children: [
                      for(int i=0; i<compCollectionList.length;i++)
                        Stack(
                          key: Key(compCollectionList[i].docId),
                          children: [
                            ExpandItemWidget(champLengthFromApi:int.parse(compCollectionList[i].champListLength),champList: Provider.of<BasicProvider>(context).compChampList[i],docId: docIds[i],),
                            Padding(
                              padding: EdgeInsets.only(top:40,right: MediaQuery.of(context).size.width*.1),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: ReorderableDragStartListener(key: Key(compCollectionList[i].docId),index: i,
                                    child: const Icon(Icons.drag_handle,color:Colors.white)),
                              ),
                            )
                          ],
                        )

                    ],
                    // children: [
                    //
                    //
                    //   ExpandItemWidget(),
                    // ],
                  ),
                ):dataFetched==true && compCollectionList.isEmpty?
                    const Center(child: Text("No Data found",style: TextStyle(color: Colors.white),)):
                const Center(child: CircularProgressIndicator(color: Colors.white,)),

              )
            ],
          )
        : ResponsiveWidget.isTabletScreen(context)
            ? ListView(
                children: [
                  /// top tab and buttons
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: height(context) * 0.02),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /// popular btn
                        NeonTabButtonWidget(
                          onTap: () {},
                          gradient: LinearGradient(
                            colors: [
                              AppColors.skyBorderColor,
                              AppColors.skyBorderColor.withOpacity(0.2),
                              AppColors.skyBorderColor.withOpacity(0.0),
                              AppColors.skyBorderColor.withOpacity(0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          btnHeight: 50,
                          btnWidth: height(context) * 0.18,
                          btnText: 'Popular',
                        ),
                        const SizedBox(width: 18),

                        /// my team btn
                        NeonTabButtonWidget(
                          onTap: () {},
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.mainDarkColor,
                              AppColors.mainDarkColor,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          btnHeight: 50,
                          btnWidth: height(context) * 0.18,
                          btnText: 'My Teams',
                          btnTextColor: AppColors.whiteColor.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SmallButtons(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const TeamBuilderScreen()));
                    },
                    iconPath: AppIcons.tierUp,
                    btnText: 'Team Builder',
                    btnColor: AppColors.orangeDarkColor,
                  ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     /// btns
                  //     Expanded(
                  //       child: SmallButtons(
                  //         onTap: () {},
                  //         iconPath: AppIcons.tierUp,
                  //         btnText: 'Tier Up',
                  //         btnColor: AppColors.orangeDarkColor,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10),
                  //     Expanded(
                  //       child: SmallButtons(
                  //         onTap: () {},
                  //         iconPath: AppIcons.tierDown,
                  //         btnText: 'Tier Down',
                  //         btnColor: AppColors.redDarkColor,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10),
                  //     Expanded(
                  //       child: SmallButtons(
                  //         onTap: () {},
                  //         iconPath: AppIcons.addIcon,
                  //         btnText: 'New Tier',
                  //         btnColor: AppColors.skyDarkColor,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  ///
                  ///

                  Container(
                    height: height(context),
                    width: width(context),
                    margin: const EdgeInsets.only(top: 36),
                    decoration: middleBoxDecoration(context),
                    ///
                    ///
                    /// Here we are showing the data fetched from firebase
                    ///

                    // child: compCollectionList.isNotEmpty?
                    child:
                    dataFetched==true && compCollectionList.isNotEmpty?
                    //                 Provider.of<CompListProvider>(context).isDataFetched &&
                    //                     Provider.of<CompListProvider>(context).compChampionsList.isNotEmpty ?
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: const Color(0x00ffffff),
                        shadowColor: const Color(0x00ffffff),
                      ),
                      child: ReorderableListView(
                        // itemCount: docIds.length,
                        // itemBuilder: (context,index){
                        //   return
                        buildDefaultDragHandles: false,

                        onReorder: (int oldIndex, int newIndex) {

                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            CompCollectionModel compDrag=compCollectionList.removeAt(oldIndex);
                            List<ChampModel> chamDragList=compChampionsList.removeAt(oldIndex);
                            compCollectionList.insert(newIndex, compDrag);
                            compChampionsList.insert(newIndex, chamDragList);

                            // final String newDocId = docIds.removeAt(oldIndex);
                            // docIds.insert(newIndex, newDocId);
                          });
                        },
                        // itemCount: docIds.length,
                        // itemBuilder: (context,index){
                        //   return
                        children: [
                          for(int i=0; i<compCollectionList.length;i++)
                            Stack(
                              key: Key(compCollectionList[i].docId),
                              children: [
                                ExpandItemWidget(champLengthFromApi:int.parse(compCollectionList[i].champListLength),champList: Provider.of<BasicProvider>(context).compChampList[i],docId: docIds[i],),
                                Padding(
                                  padding: EdgeInsets.only(top:40,right: MediaQuery.of(context).size.width*.1),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: ReorderableDragStartListener(key: Key(compCollectionList[i].docId),index: i,
                                        child: const Icon(Icons.drag_handle,color:Colors.white)),
                                  ),
                                )
                              ],
                            )

                        ],
                        // children: [
                        //
                        //
                        //   ExpandItemWidget(),
                        // ],
                      ),
                    ):dataFetched==true && compCollectionList.isEmpty?
                    const Center(child: Text("No Data found",style: TextStyle(color: Colors.white),)):
                    const Center(child: CircularProgressIndicator(color: Colors.white,)),

                  )

                  // Container(
                  //   height: height(context),
                  //   width: width(context),
                  //   margin: const EdgeInsets.only(top: 36),
                  //   decoration: middleBoxDecoration(context),
                  //   ///
                  //   ///
                  //   /// Here we are showing the data fetched from firebase
                  //   ///
                  //
                  //   child: dataFetched==true && compCollectionList.isNotEmpty?
                  //   Theme(
                  //     data: Theme.of(context).copyWith(
                  //       canvasColor: const Color(0x00ffffff),
                  //       shadowColor: const Color(0x00ffffff),
                  //     ),
                  //     child: ReorderableListView(
                  //       // itemCount: docIds.length,
                  //       // itemBuilder: (context,index){
                  //       //   return
                  //       buildDefaultDragHandles: false,
                  //
                  //       onReorder: (int oldIndex, int newIndex) {
                  //         print("Old index="+oldIndex.toString());
                  //         print("New index="+newIndex.toString());
                  //         setState(() {
                  //           if (oldIndex < newIndex) {
                  //             newIndex -= 1;
                  //           }
                  //           CompCollectionModel compDrag=compCollectionList.removeAt(oldIndex);
                  //           compCollectionList.insert(newIndex, compDrag);
                  //           // final String newDocId = docIds.removeAt(oldIndex);
                  //           // docIds.insert(newIndex, newDocId);
                  //         });
                  //       },
                  //       // itemCount: docIds.length,
                  //       // itemBuilder: (context,index){
                  //       //   return
                  //       children: [
                  //         for(int i=0; i<compCollectionList.length;i++)
                  //           Stack(
                  //             key: Key(i.toString()),
                  //             children: [
                  //               ExpandItemWidget(champLengthFromApi:int.parse(compCollectionList[i].champListLength),champList: compChampionsList[i],docId: docIds[i],),
                  //               Padding(
                  //                 padding: EdgeInsets.only(top:40,right: MediaQuery.of(context).size.width*.1),
                  //                 child: Align(
                  //                   alignment: Alignment.bottomRight,
                  //                   child: ReorderableDragStartListener(index: i,
                  //                       child: const Icon(Icons.drag_handle,color:Colors.white)),
                  //                 ),
                  //               )
                  //             ],
                  //           )
                  //
                  //
                  //       ],
                  //       // children: [
                  //       //
                  //       //
                  //       //   ExpandItemWidget(),
                  //       // ],
                  //     ),
                  //   ):dataFetched==true && compCollectionList.isEmpty?
                  //   const Center(child: Text("No Data found",style: TextStyle(color: Colors.white),)):
                  //   const Center(child: CircularProgressIndicator(color: Colors.white,)),
                  //
                  // )

                  // Container(
                  //   height: height(context),
                  //   width: width(context),
                  //   margin: const EdgeInsets.only(top: 16),
                  //   decoration: middleBoxDecoration(context),
                  //   child: ListView(
                  //     padding: const EdgeInsets.only(bottom: 100),
                  //     children:  [
                  //       ExpandItemWidget(key: Key("x"),),
                  //       ExpandItemWidget(key: Key("y"),),
                  //       ExpandItemWidget(key: Key("z"),),
                  //     ],
                  //   ),
                  // ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// top tab and buttons
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /// popular btn
                        NeonTabButtonWidget(
                          onTap: () {},
                          gradient: LinearGradient(
                            colors: [
                              AppColors.skyBorderColor,
                              AppColors.skyBorderColor.withOpacity(0.2),
                              AppColors.skyBorderColor.withOpacity(0.0),
                              AppColors.skyBorderColor.withOpacity(0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          btnHeight: 50,
                          btnWidth: height(context) * 0.18,
                          btnText: 'Popular',
                        ),
                        const SizedBox(width: 20),
                        /// my team btn
                        NeonTabButtonWidget(
                          onTap: () {},
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.mainDarkColor,
                              AppColors.mainDarkColor,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          btnHeight: 50,
                          btnWidth: height(context) * 0.18,
                          btnText: 'My Teams',
                          btnTextColor: AppColors.whiteColor.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SmallButtons(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const TeamBuilderScreen()));
                    },
                    iconPath: AppIcons.tierUp,
                    isMobile: true,
                    btnText: 'Team Builder',
                    btnColor: AppColors.orangeDarkColor,

                  ),

                  Container(
                    height: height(context),
                    width: width(context),
                    margin: const EdgeInsets.only(top: 36),
                    decoration: middleBoxDecoration(context),
                    ///
                    ///
                    /// Here we are showing the data fetched from firebase
                    ///

                    // child: compCollectionList.isNotEmpty?
                    child:
                    dataFetched==true && compCollectionList.isNotEmpty?
                    //                 Provider.of<CompListProvider>(context).isDataFetched &&
                    //                     Provider.of<CompListProvider>(context).compChampionsList.isNotEmpty ?
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: const Color(0x00ffffff),
                        shadowColor: const Color(0x00ffffff),
                      ),
                      child: ReorderableListView(
                        // itemCount: docIds.length,
                        // itemBuilder: (context,index){
                        //   return
                        buildDefaultDragHandles: false,

                        onReorder: (int oldIndex, int newIndex) {

                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            CompCollectionModel compDrag=compCollectionList.removeAt(oldIndex);
                            List<ChampModel> chamDragList=compChampionsList.removeAt(oldIndex);
                            compCollectionList.insert(newIndex, compDrag);
                            compChampionsList.insert(newIndex, chamDragList);

                            // final String newDocId = docIds.removeAt(oldIndex);
                            // docIds.insert(newIndex, newDocId);
                          });
                        },
                        // itemCount: docIds.length,
                        // itemBuilder: (context,index){
                        //   return
                        children: [
                          for(int i=0; i<compCollectionList.length;i++)
                            Stack(
                              key: Key(compCollectionList[i].docId),
                              children: [
                                ExpandItemWidget(champLengthFromApi:int.parse(compCollectionList[i].champListLength),champList: Provider.of<BasicProvider>(context).compChampList[i],docId: docIds[i],),
                                Padding(
                                  padding: const EdgeInsets.only(top:10,right: 15),

                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: ReorderableDragStartListener(key: Key(compCollectionList[i].docId),index: i,
                                        child: const Icon(Icons.drag_handle,color:Colors.white)),
                                  ),
                                )
                              ],
                            )

                        ],
                        // children: [
                        //
                        //
                        //   ExpandItemWidget(),
                        // ],
                      ),
                    ):dataFetched==true && compCollectionList.isEmpty?
                    const Center(child: Text("No Data found",style: TextStyle(color: Colors.white),)):
                    const Center(child: CircularProgressIndicator(color: Colors.white,)),

                  )

                ],
              );
  }
}
