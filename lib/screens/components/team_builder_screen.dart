import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/constants/exports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/providers/basic_provider.dart';
import '/services/firestore%20services/firestore_comp_services.dart';
import 'package:hexagon/hexagon.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as https;
import '../../widgets/buttons/action_button_widget.dart';
import '../../widgets/responsive_widget.dart';
import '../../widgets/small_image_widget.dart';
import '../Admin/Model/api_data_model.dart';
import '../Admin/api_data_to_firestore_screen.dart';
import 'app_bar_widget.dart';
import 'neon_tab_button.dart';
import '/screens/Api/custom_widget_for_combview.dart';

class TeamBuilderScreen extends StatefulWidget {
  const TeamBuilderScreen({super.key});
  @override
  State<TeamBuilderScreen> createState() => _TeamBuilderScreenState();
}

class _TeamBuilderScreenState extends State<TeamBuilderScreen> {
  String baseUrl = 'https://raw.communitydragon.org/latest/game/';
  ///
  ///         16-May-2023
  /// Image path changed
  ///
  String apiImageUrl =  'https://raw.communitydragon.org/pbe/plugins/rcp-be-lol-game-data/global/default/assets/characters/';


  Color caughtColor = Colors.red;



  ///  This work is done by Salih Hayat
  ///
  ///
  /// Following are the variables which I defined for draggable
  ///
  List<ChampModel> chosenTeam= [];  /// Chosen team list is the list of player which were chosen
  List<String> chosenTeamIndexes=[];  /// Here we can store indexes of each player in
  /// order to drag player at any index on the target drag
  ///
  // bool dataFetched = false;
  bool isLoading= true;
  void fetchFirestoreData()async{
    // print("fetching data");
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(champCollection).get();

    if(snapshot.docs.isNotEmpty){

      for(int i=0; i<snapshot.docs.length;i++){
        ChampModel champion = ChampModel.fromJsonFirebase(snapshot.docs[i]);
        champ.add(champion);
      }
      champ.sort((a,b)=>a.champName.compareTo(b.champName));
      Provider.of<BasicProvider>(context,listen: false).updateTeamBuilderChamps(champ);
      Provider.of<BasicProvider>(context,listen: false).updataDataFetched();
      // setState(() {
      //   dataFetched=true;
      // });
    }
  }


  ChampModel? champFromComb;
  bool newLine=false;
  List<ChampModel> champCombList=[];
  List<String> champCombIndexList=[];



  List<ChampModel> champ = [];
  var setData = [];

  String text = "drag here";

  Map<String, dynamic>? limit;

  void initState() {
    super.initState();
    fetchFirestoreData();
    // setState(() {
    //
    // });
    // getNameData();
  }


  bool reverseSorted=false;


  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<BasicProvider>(context);
    var updateProvider=Provider.of<BasicProvider>(context,listen: false);

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/backImage.png',
                  ),
                  fit: BoxFit.fill)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ResponsiveWidget.isWebScreen(context)
                      ? Column(
                    children: [
                      Row(
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
                          const Spacer(),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: const Color(0xffFF2D2D),
                            onPressed: () {},
                            child: const Text(
                              'Back',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),

                          /// Save Button
                          /// By Pressing save button data is saved to firestore
                          /// Comp Collection
                          ///
                          Provider.of<BasicProvider>(context).isLoading?const CircularProgressIndicator():MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: const Color(0xffF48B19),
                            onPressed: () async{

                              Provider.of<BasicProvider>(context,listen: false).startLoading();
                              if(chosenTeam.isNotEmpty){
                                String docId = DateTime.now().microsecondsSinceEpoch.toString();
                                await FirestoreCompServices().addComp(docId, chosenTeam,champ.length.toString(),context);

                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved successfully")));
                                chosenTeam.clear();
                                chosenTeamIndexes.clear();
                                Provider.of<BasicProvider>(context,listen: false).resetChosenTeam();
                                Provider.of<BasicProvider>(context,listen: false).stopLoading();
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("List is empty")));
                                Provider.of<BasicProvider>(context,listen: false).stopLoading();
                              }


                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: Color(0xff00ABDE),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ApiToFirestoreScreen()));

                            },
                            child: Text(
                              'Create Guide',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: Color(0xffF48B19),
                            onPressed: () {},
                            child: Text(
                              'Share',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: const Color(0xffFF2D2D),
                            onPressed: () {},
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const Spacer(),

                          /// actions icons
                          ActionButtonWidget(
                              onTap: () {}, iconPath: AppIcons.chat),
                          const SizedBox(width: 8),
                          ActionButtonWidget(
                              onTap: () {}, iconPath: AppIcons.setting),
                          const SizedBox(width: 8),
                          ActionButtonWidget(
                            onTap: () {},
                            iconPath: AppIcons.bell,
                            isNotify: true,
                          ),
                          const SizedBox(width: 8),

                          /// user name and image
                          // Text('Madeline Goldner',
                          //   style: poppinsRegular.copyWith(
                          //     fontSize: 16,
                          //     color: AppColors.whiteColor,
                          //   ),
                          // ),
                          const CircleAvatar(
                            radius: 22,
                            backgroundImage:
                            AssetImage(AppImages.userImage),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(AppIcons.dotVert),
                          ),
                        ],
                      ),
                      const Text(
                        'Team Builder',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      const Text(
                        'Drag & Drop players to build your best team,',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 15),
                      ),
                      const SizedBox(height: 40,),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              NeonTabButtonWidget(
                                onTap: null,
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xffF48B19),
                                    const Color(0xffF48B19).withOpacity(0.2),
                                    const Color(0xffF48B19).withOpacity(0.0),
                                    const Color(0xffF48B19).withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                btnHeight: 35,
                                btnWidth:
                                ResponsiveWidget.isWebScreen(context)
                                    ? width(context) * 0.11
                                    : ResponsiveWidget.isTabletScreen(
                                    context)
                                    ? width(context) * 0.2
                                    : width(context) * 0.3,
                                btnText: 'Synergy',
                              ),
                              Container(
                                width: 200,
                                // margin: const EdgeInsets.only(0),
                                padding:
                                ResponsiveWidget.isWebScreen(context)
                                    ? const EdgeInsets.symmetric(
                                    horizontal: 20)
                                    : const EdgeInsets.symmetric(
                                    horizontal: 8),
                                decoration:
                                ImagePageBoxDecoration(context),
                                child: Column(
                                  children: const [
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Text(
                                      'Start building your camp',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'to see the synergies.',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 100,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          SizedBox(
                            height: 250,
                            // width: 420,
                            child: Stack(
                              children: [
                                Row(
                                  children: List.generate(7, (index1) =>
                                      SizedBox(
                                        height: 70,
                                        width: 70,
                                        child: DragTarget(
                                            onAccept: (ChampModel data) {
                                              data.champPositionIndex="1$index1";
                                              /// This work is done by Salih Hayat
                                              ///
                                              /// I have created another list for team to be choosed
                                              /// Also  I created another list of integer in which I store indexes of the players
                                              /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                              /// already in the team therefore such a player cannot be added again
                                              if(
                                              Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                              }else{

                                                /// If player is not present in team here we can add
                                                // data.champPositionIndex=index.toString();
                                                chosenTeam.add(data);
                                                String index="1$index1";
                                                Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                chosenTeamIndexes.add(index);

                                                // setState(() {
                                                //
                                                // });
                                              }

                                            }, builder: (
                                            BuildContext context,
                                            List<dynamic> accepted,
                                            List<dynamic> rejected,
                                            ) {
                                          // print(text);
                                          String index="1$index1";
                                          return Center(
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(12),
                                              // child
                                              /// Here I used chosen team indexes for reference if the player exist in team
                                              /// We will show the icon of player else will show blank polygon icon
                                              child: Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                  ?SmallImageWidget(
                                                isBorder: true,
                                                imageUrl: apiImageUrl + Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase(),
                                                borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
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
                                          );
                                        }),
                                      ))
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 55.0,left: 35),
                                  child: Row(
                                      children: List.generate(7, (index2) =>
                                          SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: DragTarget(
                                                onAccept: (ChampModel data) {
                                                  String index="2$index2";
                                                  data.champPositionIndex=index;
                                                  /// This work is done by Salih Hayat
                                                  ///
                                                  /// I have created another list for team to be choosed
                                                  /// Also  I created another list of integer in which I store indexes of the players
                                                  /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                  /// already in the team therefore such a player cannot be added again
                                                  if(
                                                  Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                  }else{

                                                    /// If player is not present in team here we can add
                                                    // data.champPositionIndex=index.toString();
                                                    chosenTeam.add(data);
                                                    Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                    chosenTeamIndexes.add(index);

                                                    // setState(() {
                                                    //
                                                    // });
                                                  }

                                                }, builder: (
                                                BuildContext context,
                                                List<dynamic> accepted,
                                                List<dynamic> rejected,
                                                ) {
                                              // print(text);
                                              String index="2$index2";
                                              return Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  // child
                                                  /// Here I used chosen team indexes for reference if the player exist in team
                                                  /// We will show the icon of player else will show blank polygon icon
                                                  child: Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                      ?SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl: apiImageUrl + Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase(),
                                                    borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                    Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                    Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                    Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                    Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
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
                                              );
                                            }),
                                          ))
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 110.0),
                                  child: Row(
                                      children: List.generate(7, (index3) =>
                                          SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: DragTarget(
                                                onAccept: (ChampModel data) {
                                                  String index="3$index3";
                                                  data.champPositionIndex=index;
                                                  /// This work is done by Salih Hayat
                                                  ///
                                                  /// I have created another list for team to be choosed
                                                  /// Also  I created another list of integer in which I store indexes of the players
                                                  /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                  /// already in the team therefore such a player cannot be added again
                                                  if(
                                                  Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                  }else{

                                                    /// If player is not present in team here we can add
                                                    // data.champPositionIndex=index.toString();
                                                    chosenTeam.add(data);
                                                    Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                    chosenTeamIndexes.add(index);

                                                    // setState(() {
                                                    //
                                                    // });
                                                  }

                                                }, builder: (
                                                BuildContext context,
                                                List<dynamic> accepted,
                                                List<dynamic> rejected,
                                                ) {
                                              // print(text);
                                              String index="3$index3";
                                              return Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  // child
                                                  /// Here I used chosen team indexes for reference if the player exist in team
                                                  /// We will show the icon of player else will show blank polygon icon
                                                  child: Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                      ?SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl: apiImageUrl + Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase(),
                                                    borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                    Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                    Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                    Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                    Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
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
                                              );
                                            }),
                                          ))
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 165.0,left: 35),
                                  child: Row(
                                      children: List.generate(7, (index4) =>
                                          SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: DragTarget(
                                                onAccept: (ChampModel data) {
                                                  data.champPositionIndex="4$index4";
                                                  /// This work is done by Salih Hayat
                                                  ///
                                                  /// I have created another list for team to be choosed
                                                  /// Also  I created another list of integer in which I store indexes of the players
                                                  /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                  /// already in the team therefore such a player cannot be added again
                                                  if(
                                                  Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                  }else{

                                                    /// If player is not present in team here we can add
                                                    // data.champPositionIndex=index.toString();
                                                    chosenTeam.add(data);
                                                    String index="4$index4";
                                                    Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                    chosenTeamIndexes.add(index);

                                                    // setState(() {
                                                    //
                                                    // });
                                                  }

                                                }, builder: (
                                                BuildContext context,
                                                List<dynamic> accepted,
                                                List<dynamic> rejected,
                                                ) {
                                              // print(text);
                                              String index="4$index4";
                                              return Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  // child
                                                  /// Here I used chosen team indexes for reference if the player exist in team
                                                  /// We will show the icon of player else will show blank polygon icon
                                                  child: Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                      ?SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl: apiImageUrl + Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase(),
                                                    borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                    Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                    Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                    Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                    Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
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
                                              );
                                            }),
                                          ))
                                  ),
                                ),

                              ],
                            ),
                          ),
                          Spacer(),
                          Column(
                            children: [
                              NeonTabButtonWidget(
                                onTap: null,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffF48B19),
                                    Color(0x20F48B19),
                                    // Color(0xffF48B19).withOpacity(0.0),
                                    // Color(0xffF48B19).withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                btnHeight: 35,
                                btnWidth:
                                ResponsiveWidget.isWebScreen(context)
                                    ? width(context) * 0.11
                                    : ResponsiveWidget.isTabletScreen(
                                    context)
                                    ? width(context) * 0.2
                                    : width(context) * 0.3,
                                btnText: 'Core Champs',
                              ),
                              Container(
                                width: 200,
                                // margin: const EdgeInsets.only(0),
                                padding:
                                ResponsiveWidget.isWebScreen(context)
                                    ? const EdgeInsets.symmetric(
                                    horizontal: 20)
                                    : const EdgeInsets.symmetric(
                                    horizontal: 8),
                                decoration:
                                ImagePageBoxDecoration(context),
                                child: Column(
                                  children: const [
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Text(
                                      'Double click a champ on',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'field to add them as',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'core champion for the',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'team comp.',
                                      style:
                                      TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 70,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 1, color: Color(0xffF48B19))),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 220,
                                    child: TextField(
                                      onChanged: (value) {
                                        Provider.of<BasicProvider>(context,listen: false).runFilter(value,true);
                                        setState(() {

                                        });
                                      } ,
                                      style: TextStyle(color: Colors.grey),
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.search,
                                            color: Colors.grey),
                                        fillColor: Color(0xff191741),
                                        filled: true,
                                        hintText: 'Search champion',
                                        hintStyle:
                                        TextStyle(color: Colors.grey),
                                        contentPadding:
                                        EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 20.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.mainColor,
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.mainColor,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: (){
                                      provider.sortChampList(true);
                                      reverseSorted=false;
                                      setState(() {

                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff191741),
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          border: reverseSorted?null:Border.all(
                                              width: 1,
                                              color: const Color(0xffF48B19)
                                          )
                                      ),
                                      child: const Text(
                                        'A-Z',
                                        style:
                                        TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: (){
                                      provider.sortChampListZtoA(true);
                                      reverseSorted=true;
                                      setState(() {

                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff191741),
                                        borderRadius:
                                        BorderRadius.circular(12),
                                          border: reverseSorted?Border.all(
                                              width: 1,
                                              color: const Color(0xffF48B19)
                                          ):null
                                      ),
                                      child: Text(
                                        'Z-A',
                                        style: TextStyle(
                                            color: Colors.grey.shade300),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff191741),
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                            "assets/images/Layer 2.png"),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Any Synergy',
                                          style: TextStyle(
                                              color:
                                              Colors.grey.shade300),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Clear Filter",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                  const Spacer(),
                                  Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff191741),
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          MaterialButton(
                                              height: 35,
                                              shape:
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      8)),
                                              color: Color(0xffF48B19),
                                              onPressed: () {

                                              },
                                              child: const Text(
                                                'Champions',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                          MaterialButton(
                                              height: 35,
                                              onPressed: () {},
                                              child: const Text(
                                                'Items',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ))
                                        ],
                                      )),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                ],
                              ),
                              Provider.of<BasicProvider>(context).dataFetched &&
                            provider.visibleSearchData?
                              GridView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 12,
                                          mainAxisExtent: 85,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5),
                                      padding: const EdgeInsets.only(
                                        top: 15,
                                        bottom: 10,
                                      ),
                                      itemCount: provider.foundData.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Expanded(
                                              /*****************************************************************************8
                                               * Draggable  widget
                                               *******************************************************************************/

                                              child: Draggable(
                                                data: provider.foundData[index],
                                                onDraggableCanceled:
                                                    (velocity, offset) {},
                                                feedback: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                    child:SmallImageWidget(
                                                      isBorder: true,
                                                      imageUrl: apiImageUrl + provider.foundData[index].imagePath.toString().toLowerCase(),
                                                      borderColor: provider.foundData[index].champCost=='1'?
                                                      Colors.grey:provider.foundData[index].champCost=='2'?
                                                      Colors.green:provider.foundData[index].champCost=='3'?
                                                      Colors.blue:provider.foundData[index].champCost=='4'?
                                                      Colors.purple:provider.foundData[index].champCost=='5'?
                                                      Colors.yellow:Colors.red
                                                      ,

                                                    )
                                                  // child: Image.network(
                                                  //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                  //     height: 70,
                                                  //     width: 70,
                                                  //     fit: BoxFit.fill),
                                                ),
                                                child: Container(
                                                    child: Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              12),
                                                          child: SmallImageWidget(
                                                            isBorder: true,
                                                            imageUrl: apiImageUrl + provider.foundData[index].imagePath.toString().toLowerCase(),
                                                            borderColor: provider.foundData[index].champCost=='1'?
                                                            Colors.grey:provider.foundData[index].champCost=='2'?
                                                            Colors.green:provider.foundData[index].champCost=='3'?
                                                            Colors.blue:provider.foundData[index].champCost=='4'?
                                                            Colors.purple:provider.foundData[index].champCost=='5'?
                                                            Colors.yellow:Colors.red
                                                            ,

                                                          ),
                                                          // child: Image.network(
                                                          //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                          //     height: 60,
                                                          //     width: 60,
                                                          //     fit: BoxFit
                                                          //         .fill),
                                                        ),
                                                        const SizedBox(height: 5),
                                                        Text(
                                                          provider.foundData[index].champName,
                                                          style: const TextStyle(
                                                              color:
                                                              Colors.blue,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          ],
                                        );
                                      }):
                              Provider.of<BasicProvider>(context).dataFetched &&
                                  provider.visibleSearchData==false?
                              GridView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 12,
                                      mainAxisExtent: 85,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5),
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 10,
                                  ),
                                  itemCount: provider.teamBuilderChamps.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Expanded(
                                          /*****************************************************************************8
                                           * Draggable  widget
                                           *******************************************************************************/

                                          child: Draggable(
                                            data: provider.teamBuilderChamps[index],
                                            onDraggableCanceled:
                                                (velocity, offset) {},
                                            feedback: ClipRRect(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(12),
                                                child:SmallImageWidget(
                                                  isBorder: true,
                                                  imageUrl: apiImageUrl + provider.teamBuilderChamps[index].imagePath.toString().toLowerCase(),
                                                  borderColor: provider.teamBuilderChamps[index].champCost=='1'?
                                                  Colors.grey:provider.teamBuilderChamps[index].champCost=='2'?
                                                  Colors.green:provider.teamBuilderChamps[index].champCost=='3'?
                                                  Colors.blue:provider.teamBuilderChamps[index].champCost=='4'?
                                                  Colors.purple:provider.teamBuilderChamps[index].champCost=='5'?
                                                  Colors.yellow:Colors.red
                                                  ,

                                                )
                                              // child: Image.network(
                                              //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                              //     height: 70,
                                              //     width: 70,
                                              //     fit: BoxFit.fill),
                                            ),
                                            child: Container(
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          12),
                                                      child: SmallImageWidget(
                                                        isBorder: true,
                                                        imageUrl: apiImageUrl + provider.teamBuilderChamps[index].imagePath.toString().toLowerCase(),
                                                        borderColor: provider.teamBuilderChamps[index].champCost=='1'?
                                                        Colors.grey:provider.teamBuilderChamps[index].champCost=='2'?
                                                        Colors.green:provider.teamBuilderChamps[index].champCost=='3'?
                                                        Colors.blue:provider.teamBuilderChamps[index].champCost=='4'?
                                                        Colors.purple:provider.teamBuilderChamps[index].champCost=='5'?
                                                        Colors.yellow:Colors.red
                                                        ,

                                                      ),
                                                      // child: Image.network(
                                                      //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                      //     height: 60,
                                                      //     width: 60,
                                                      //     fit: BoxFit
                                                      //         .fill),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      provider.teamBuilderChamps[index].champName,
                                                      style: const TextStyle(
                                                          color:
                                                          Colors.blue,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ],
                                    );
                                  }):
                                  const Text("No data found",style: TextStyle(color:Color(0xffffffff)),)
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                  ///
                  ///
                  ///  Below code is for Tablet
                  ///
                  ///
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                /// menu icon
                                IconButton(
                                  onPressed: () {
                                    // getNameData();
                                  },
                                  icon: MenuIcon(),
                                ),
                                SizedBox(width: 12.0),

                                /// premium button
                                PremiumButton(onTap: () {}),
                                const SizedBox(
                                  width: 12,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12)),
                                  color: Color(0xffFF2D2D),
                                  onPressed: () {},
                                  child: const Text(
                                    'Back',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12)),
                                  color: const Color(0xffF48B19),
                                  onPressed: () {},
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12)),
                                  color: Color(0xff00ABDE),
                                  onPressed: () {},
                                  child: const Text(
                                    'Create Guide',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12)),
                                  color: Color(0xffF48B19),
                                  onPressed: () {},
                                  child: const Text(
                                    'Share',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12)),
                                  color: Color(0xffFF2D2D),
                                  onPressed: () {},
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),

                                /// actions icons
                                ActionButtonWidget(
                                    onTap: () {}, iconPath: AppIcons.chat),
                                const SizedBox(width: 8),
                                ActionButtonWidget(
                                    onTap: () {},
                                    iconPath: AppIcons.setting),
                                const SizedBox(width: 8),
                                ActionButtonWidget(
                                  onTap: () {},
                                  iconPath: AppIcons.bell,
                                  isNotify: true,
                                ),
                                SizedBox(width: 8),

                                const CircleAvatar(
                                  radius: 22,
                                  backgroundImage:
                                  AssetImage(AppImages.userImage),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(AppIcons.dotVert),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Center(
                            child: Text(
                              'Team Builder',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          ),
                          const Center(
                            child: Text(
                              'Drag & Drop players to build your best team,',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),

                          Center(
                            child: SizedBox(
                              height: 170,
                              width: 300,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Row(
                                      children: List.generate(7, (index1) =>
                                          SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: DragTarget(
                                                onAccept: (ChampModel data) {
                                                  data.champPositionIndex="1$index1";
                                                  /// This work is done by Salih Hayat
                                                  ///
                                                  /// I have created another list for team to be choosed
                                                  /// Also  I created another list of integer in which I store indexes of the players
                                                  /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                  /// already in the team therefore such a player cannot be added again
                                                  if(
                                                  Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                  }else{

                                                    /// If player is not present in team here we can add
                                                    // data.champPositionIndex=index.toString();
                                                    chosenTeam.add(data);
                                                    String index="1$index1";
                                                    Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                    chosenTeamIndexes.add(index);

                                                    // setState(() {
                                                    //
                                                    // });
                                                  }

                                                }, builder: (
                                                BuildContext context,
                                                List<dynamic> accepted,
                                                List<dynamic> rejected,
                                                ) {
                                              // print(text);
                                              String index="1$index1";
                                              return Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  // child
                                                  /// Here I used chosen team indexes for reference if the player exist in team
                                                  /// We will show the icon of player else will show blank polygon icon
                                                  child: Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                      ?SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl: apiImageUrl + Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase(),
                                                    borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                    Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                    Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                    Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                    Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
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
                                              );
                                            }),
                                          ))
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40.0,left: 20),
                                    child: Row(
                                        children: List.generate(7, (index2) =>
                                            SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: DragTarget(
                                                  onAccept: (ChampModel data) {
                                                    String index="2$index2";
                                                    data.champPositionIndex=index;
                                                    /// This work is done by Salih Hayat
                                                    ///
                                                    /// I have created another list for team to be choosed
                                                    /// Also  I created another list of integer in which I store indexes of the players
                                                    /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                    /// already in the team therefore such a player cannot be added again
                                                    if(
                                                    Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                    }else{

                                                      /// If player is not present in team here we can add
                                                      // data.champPositionIndex=index.toString();
                                                      chosenTeam.add(data);
                                                      Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                      chosenTeamIndexes.add(index);

                                                      // setState(() {
                                                      //
                                                      // });
                                                    }

                                                  }, builder: (
                                                  BuildContext context,
                                                  List<dynamic> accepted,
                                                  List<dynamic> rejected,
                                                  ) {
                                                // print(text);
                                                String index="2$index2";
                                                return Center(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(12),
                                                    // child
                                                    /// Here I used chosen team indexes for reference if the player exist in team
                                                    /// We will show the icon of player else will show blank polygon icon
                                                    child: Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                        ?SmallImageWidget(
                                                      isBorder: true,
                                                      imageUrl: apiImageUrl + Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase(),
                                                      borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                      Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                      Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                      Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                      Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
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
                                                );
                                              }),
                                            ))
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 80.0),
                                    child: Row(
                                        children: List.generate(7, (index3) =>
                                            SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: DragTarget(
                                                  onAccept: (ChampModel data) {
                                                    String index="3$index3";
                                                    data.champPositionIndex=index;
                                                    /// This work is done by Salih Hayat
                                                    ///
                                                    /// I have created another list for team to be choosed
                                                    /// Also  I created another list of integer in which I store indexes of the players
                                                    /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                    /// already in the team therefore such a player cannot be added again
                                                    if(
                                                    Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                    }else{

                                                      /// If player is not present in team here we can add
                                                      // data.champPositionIndex=index.toString();
                                                      chosenTeam.add(data);
                                                      Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                      chosenTeamIndexes.add(index);

                                                      // setState(() {
                                                      //
                                                      // });
                                                    }

                                                  }, builder: (
                                                  BuildContext context,
                                                  List<dynamic> accepted,
                                                  List<dynamic> rejected,
                                                  ) {
                                                // print(text);
                                                String index="3$index3";
                                                return Center(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(12),
                                                    // child
                                                    /// Here I used chosen team indexes for reference if the player exist in team
                                                    /// We will show the icon of player else will show blank polygon icon
                                                    child: Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                        ?SmallImageWidget(
                                                      isBorder: true,
                                                      imageUrl: apiImageUrl + Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase(),
                                                      borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                      Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                      Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                      Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                      Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
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
                                                );
                                              }),
                                            ))
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 120.0,left: 20),
                                    child: Row(
                                        children: List.generate(7, (index4) =>
                                            SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: DragTarget(
                                                  onAccept: (ChampModel data) {
                                                    data.champPositionIndex="4$index4";
                                                    /// This work is done by Salih Hayat
                                                    ///
                                                    /// I have created another list for team to be choosed
                                                    /// Also  I created another list of integer in which I store indexes of the players
                                                    /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                    /// already in the team therefore such a player cannot be added again
                                                    if(
                                                    Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                    }else{

                                                      /// If player is not present in team here we can add
                                                      // data.champPositionIndex=index.toString();
                                                      chosenTeam.add(data);
                                                      String index="4$index4";
                                                      Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                      chosenTeamIndexes.add(index);

                                                      // setState(() {
                                                      //
                                                      // });
                                                    }

                                                  }, builder: (
                                                  BuildContext context,
                                                  List<dynamic> accepted,
                                                  List<dynamic> rejected,
                                                  ) {
                                                // print(text);
                                                String index="4$index4";
                                                return Center(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(12),
                                                    // child
                                                    /// Here I used chosen team indexes for reference if the player exist in team
                                                    /// We will show the icon of player else will show blank polygon icon
                                                    child: Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                        ?SmallImageWidget(
                                                      isBorder: true,
                                                      imageUrl: apiImageUrl + Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase(),
                                                      borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                      Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                      Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                      Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                      Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
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
                                                );
                                              }),
                                            ))
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),


                          Container(
                            height: height(context)*.36,
                            // width: width(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    width: 1, color: Color(0xffF48B19))),
                            child: Column(
                              children: [
                                const SizedBox(height: 12),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 220,
                                        child: TextField(
                                          onChanged: (value) {
                                            Provider.of<BasicProvider>(context,listen: false).runFilter(value,true);
                                            setState(() {

                                            });
                                          } ,
                                          style: TextStyle(color: Colors.grey),
                                          decoration: const InputDecoration(
                                            prefixIcon: Icon(Icons.search,
                                                color: Colors.grey),
                                            fillColor: Color(0xff191741),
                                            filled: true,
                                            hintText: 'Search champion',
                                            hintStyle:
                                            TextStyle(color: Colors.grey),
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 20.0),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.mainColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.mainColor,
                                                  width: 2.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: (){
                                          provider.sortChampList(true);
                                          reverseSorted=false;
                                          setState(() {

                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: const Color(0xff191741),
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              border: reverseSorted?null:Border.all(
                                                  width: 1,
                                                  color: const Color(0xffF48B19)
                                              )
                                          ),
                                          child: const Text(
                                            'A-Z',
                                            style:
                                            TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: (){
                                          provider.sortChampListZtoA(true);
                                          reverseSorted=true;
                                          setState(() {

                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: const Color(0xff191741),
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              border: reverseSorted?Border.all(
                                                  width: 1,
                                                  color: const Color(0xffF48B19)
                                              ):null
                                          ),
                                          child: Text(
                                            'Z-A',
                                            style: TextStyle(
                                                color: Colors.grey.shade300),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),

                                Provider.of<BasicProvider>(context).dataFetched &&
                                    provider.visibleSearchData?
                                SizedBox(
                                  height: height(context)*.23,
                                  child: GridView.builder(
                                      physics: ScrollPhysics(),

                                      shrinkWrap: true,
                                      gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 12,
                                          mainAxisExtent: 85,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5),
                                      padding: const EdgeInsets.only(
                                        top: 15,
                                        bottom: 10,
                                      ),
                                      itemCount: provider.foundData.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Expanded(
                                              /*****************************************************************************8
                                               * Draggable  widget
                                               *******************************************************************************/

                                              child: Draggable(
                                                data: provider.foundData[index],
                                                onDraggableCanceled:
                                                    (velocity, offset) {},
                                                feedback: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(12),
                                                    child:SmallImageWidget(
                                                      isBorder: true,
                                                      imageUrl: apiImageUrl + provider.foundData[index].imagePath.toString().toLowerCase(),
                                                      borderColor: provider.foundData[index].champCost=='1'?
                                                      Colors.grey:provider.foundData[index].champCost=='2'?
                                                      Colors.green:provider.foundData[index].champCost=='3'?
                                                      Colors.blue:provider.foundData[index].champCost=='4'?
                                                      Colors.purple:provider.foundData[index].champCost=='5'?
                                                      Colors.yellow:Colors.red
                                                      ,
                                                      imageHeight: 30,
                                                      imageWidth: 30,
                                                    )
                                                  // child: Image.network(
                                                  //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                  //     height: 70,
                                                  //     width: 70,
                                                  //     fit: BoxFit.fill),
                                                ),
                                                child: Container(
                                                    child: Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              12),
                                                          child: SmallImageWidget(
                                                            isBorder: true,
                                                            imageUrl: apiImageUrl + provider.foundData[index].imagePath.toString().toLowerCase(),
                                                            borderColor: provider.foundData[index].champCost=='1'?
                                                            Colors.grey:provider.foundData[index].champCost=='2'?
                                                            Colors.green:provider.foundData[index].champCost=='3'?
                                                            Colors.blue:provider.foundData[index].champCost=='4'?
                                                            Colors.purple:provider.foundData[index].champCost=='5'?
                                                            Colors.yellow:Colors.red
                                                            ,
                                                            imageHeight: 30,
                                                            imageWidth: 30,
                                                          ),
                                                          // child: Image.network(
                                                          //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                          //     height: 60,
                                                          //     width: 60,
                                                          //     fit: BoxFit
                                                          //         .fill),
                                                        ),
                                                        const SizedBox(height: 5),
                                                        Text(
                                                          provider.foundData[index].champName,
                                                          style: const TextStyle(
                                                              color:
                                                              Colors.blue,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ):
                                Provider.of<BasicProvider>(context).dataFetched &&
                                    provider.visibleSearchData==false?
                                SizedBox(
                                  height: height(context)*.23,
                                  child: GridView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 6,
                                          mainAxisExtent: 60,
                                          crossAxisSpacing: 1,
                                          mainAxisSpacing: 1
                                      ),
                                      padding: const EdgeInsets.only(
                                        top: 15,
                                        bottom: 10,
                                      ),
                                      itemCount: provider.teamBuilderChamps.length,
                                      itemBuilder: (context, index) {
                                        return Draggable(
                                          data: provider.teamBuilderChamps[index],
                                          onDraggableCanceled:
                                              (velocity, offset) {},
                                          feedback: SmallImageWidget(
                                            isBorder: true,
                                            imageUrl: apiImageUrl + provider.teamBuilderChamps[index].imagePath.toString().toLowerCase(),
                                            borderColor: provider.teamBuilderChamps[index].champCost=='1'?
                                            Colors.grey:provider.teamBuilderChamps[index].champCost=='2'?
                                            Colors.green:provider.teamBuilderChamps[index].champCost=='3'?
                                            Colors.blue:provider.teamBuilderChamps[index].champCost=='4'?
                                            Colors.purple:provider.teamBuilderChamps[index].champCost=='5'?
                                            Colors.yellow:Colors.red
                                            ,
                                            imageHeight: 30,
                                            imageWidth: 30,
                                          ),
                                          child: SizedBox(
                                            height: 50,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SmallImageWidget(
                                                  boxHeight: 30,
                                                  boxWidth: 30,
                                                  isBorder: true,
                                                  imageUrl: apiImageUrl + provider.teamBuilderChamps[index].imagePath.toString().toLowerCase(),
                                                  borderColor: provider.teamBuilderChamps[index].champCost=='1'?
                                                  Colors.grey:provider.teamBuilderChamps[index].champCost=='2'?
                                                  Colors.green:provider.teamBuilderChamps[index].champCost=='3'?
                                                  Colors.blue:provider.teamBuilderChamps[index].champCost=='4'?
                                                  Colors.purple:provider.teamBuilderChamps[index].champCost=='5'?
                                                  Colors.yellow:Colors.red
                                                  ,
                                                  imageHeight: 30,
                                                  imageWidth: 30,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  provider.teamBuilderChamps[index].champName,
                                                  style: const TextStyle(
                                                      color:
                                                      Colors.blue,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ):
                                const Text("No data found",style: TextStyle(color:Color(0xffffffff)),)
                              ],
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
