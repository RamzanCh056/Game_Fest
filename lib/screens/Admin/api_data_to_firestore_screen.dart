import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widgets/buttons/menu_icon.dart';
import '../../widgets/buttons/premium_button.dart';
import '/constants/exports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import '../../providers/basic_provider.dart';
import '../../widgets/buttons/action_button_widget.dart';
import '../../widgets/responsive_widget.dart';
import '../../widgets/small_image_widget.dart';
import '../components/team_builder_screen.dart';
import '../Landing/landing_page.dart';
import '../components/app_bar_widget.dart';
import '../components/neon_tab_button.dart';
import 'Admin Firestore Services/admin_firestore_Services.dart';
import 'Model/api_data_model.dart';

class ApiToFirestoreScreen extends StatefulWidget {
  const ApiToFirestoreScreen({super.key});
  @override
  State<ApiToFirestoreScreen> createState() => _ApiToFirestoreScreenState();
}

class _ApiToFirestoreScreenState extends State<ApiToFirestoreScreen> {
  String baseUrl = 'https://raw.communitydragon.org/latest/game/';
  Color caughtColor = Colors.red;
  String apiImageUrl =  'https://raw.communitydragon.org/pbe/plugins/rcp-be-lol-game-data/global/default/assets/characters/';



  bool loading = false;
  List<ChampModel> champListFromFirebase =[];
  List<String> docIds =[];

  String currentSetValue='';
  bool setValueFetched= false;
  fetchSetValue()async{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("Sets Value").doc('1').get();
    currentSetValue = snapshot['current set value'];
    setValueFetched=true;
    setState(() {

    });
  }
  fetchFirestoreData()async{
    QuerySnapshot champCollectionFromFirestore = await FirebaseFirestore.instance.collection(champCollection).get();

    if(champCollectionFromFirestore.docs.isNotEmpty){
      champListFromFirebase.clear();
      docIds.clear();
      champList.clear();
      champListIndexes.clear();
      // chosenTeam.clear();
      // chosenTeamIndexes.clear();
      for(int i=0;i<champCollectionFromFirestore.docs.length;i++){
        ChampModel championFromFirestore = ChampModel.fromJsonFirebase(champCollectionFromFirestore.docs[i]);
        champListFromFirebase.add(championFromFirestore);
        docIds.add(champCollectionFromFirestore.docs[i].id);
      }
      setState((){});

    }

  }
  ///  This work is done by Salih Hayat
  ///
  ///
  /// Following are the variables which I defined for draggable
  ///
  // var chosenTeam= [];  /// Chosen team list is the list of player which were chosen
  // List<int> chosenTeamIndexes=[];  /// Here we can store indexes of each player in
  /// order to drag player at any index on the target drag

  List<ChampModel> champList =[];
  List<int> champListIndexes=[];
  bool selectAll=false;




  var apiNamesList = [];
  var champ = [];
  var setData = [];
  bool isLoading = true;
  getNameData() async {
    print("I Api fetching");
    var headers = {
      'Authorization':
      'Bearer KFZe9qt2lNlDOpNNUJnv0r6uV1Q4nBQsK6M2QiZIGtPPi0ckTK5kVntVquiTjOhf'
      // "Access-Control-Allow-Origin: *"
    };

    Response response=await get(
        Uri.parse(
            'https://raw.communitydragon.org/latest/cdragon/tft/en_us.json'
    ));
    print(response.statusCode);


    print("I am before request call");

    print("I am After request call");

    if (response.statusCode == 200) {
      // var res = await response.stream.bytesToString();

      var body = jsonDecode(response.body);

      /// Requirement # 2
      /// Here data from API fetches
      /// When the value in set increases it by default increases here
      ///

      /// fetchSetValue is method used to fetch set value from firebase
      /// than compare previous and new set value if set values are not
      /// same than fetch value of firestore is incremented by default
      await fetchSetValue();
      Future.delayed(const Duration(seconds: 1), () {
        int setValue= int.parse(currentSetValue);

        print("I am before setting  set value");
        var val =body['sets']['${setValue+1}'];
        print(val);
        print("I am After setting  set value");
        if(val !=null ){
          currentSetValue="${setValue+1}";

          print(val);
          setData = body['sets'][currentSetValue]['champions'];
          champ=setData;
          AdminFirestoreServices().addSetValue(currentSetValue);
          setState(() {

          });
        }else{
          print(val);
          setData = body['sets'][currentSetValue]['champions'];
          print(setData.length);
          champ=setData;

          champ.sort((a, b) => a['apiName'].toString().compareTo(b['apiName'].toString()));
          // apiNamesList=body['sets'][currentSetValue]['champions']['apiName'];
        }

        // champ = setData[0]['champions'];
        // for (int i = 0; i < setData.length; i++) {
        //   champ = setData[i]['champions'];
        // }
        // ;
        print("my chap lengt ==${champ.length}");

        //champ = setData['champions'];
        // print('SetData=$setData');  print(

        setState(() {
          champ;
          // chosenTeam = champ;
        });
        setState(() {
          isLoading = false;
        });
        // print("list item=$champ");

      });
    } else {
      print(response.reasonPhrase);
      print('error');
      setState(() {
        isLoading = false;
      });
    }
  }

  String text = "drag here";

  Map<String, dynamic>? limit;

  @override
  void initState() {
    super.initState();
    fetchSetValue();
    fetchFirestoreData();
    getNameData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
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
                                borderRadius: BorderRadius.circular(12)),
                            color: const Color(0xff00ABDE),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const TeamBuilderScreen()));
                            },
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
                                borderRadius: BorderRadius.circular(12)),
                            color: const Color(0xffF48B19),
                            onPressed: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>const LandingPage()));

                            },
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
                                borderRadius: BorderRadius.circular(12)),
                            color: const Color(0xffFF2D2D),
                            onPressed: () {},
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Spacer(),

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

                      /// This visibility widgets are used for selection option
                      Visibility(
                        visible: selectAll,
                        child: champList.length==champ.length?
                        TextButton(
                            onPressed: (){
                              champList.clear();
                              champListIndexes.clear();

                              setState(() {

                              });
                            },
                            child: const Text("Select All",style: TextStyle(color: Colors.white),))
                            :TextButton(
                            onPressed: (){
                              champList.clear();
                              champListIndexes.clear();
                              for(int i=0; i<champ.length;i++){
                                ChampModel champion=ChampModel(
                                    champName: champ[i]['name'],
                                    ///
                                    /// Image path changed to another location
                                    ///
                                    ///
                                  imagePath: "${champ[i]['apiName'].toString().toLowerCase()}/hud/${champ[i]['apiName'].toString().toLowerCase()}_square.tft_set$currentSetValue.png",
                                  champCost: champ[i]['cost'].toString(),
                                  champTraits: champ[i]['traits'],
                                  champPositionIndex: i.toString()
                                );
                                champList.add(champion);
                                print('$champion added at $i');
                                champListIndexes.add(i);
                              }
                              setState(() {

                              });
                            },
                            child: const Text("Select All",style: TextStyle(color: Colors.white))),
                      ),
                      /// This visibility widgets are used for Upload button
                      Visibility(
                          visible: selectAll,
                          child:Provider.of<BasicProvider>(context).isLoading?const CircularProgressIndicator():TextButton(
                            onPressed: ()async{

                              /// Requirement # 1
                              ///
                              /// Whenever new data is submitted to firestore
                              /// previous data is cleared
                              Provider.of<BasicProvider>(context,listen: false).startLoading();
                              print(champListFromFirebase.length);
                              print(champList.length);

                              // submitDataToFirebase(champList, docIds, context);
                              print("Deletion oocurs but I am called");
                              /// The AdminFirestoreServices().deleteChamp
                              /// deletes all previous data in champ collection
                              await AdminFirestoreServices().deleteChamp(champListFromFirebase, docIds, context) ;

                              /// The AdminFirestoreServices().addChamp
                              /// adds new data to firestore
                              await AdminFirestoreServices().addChamp(champList,context) ;


                              Provider.of<BasicProvider>(context,listen: false).firebaseDataAdded?{

                                fetchFirestoreData(),
                                print("fetched data method called"),
                                setState(() {

                                }),
                                Provider.of<BasicProvider>(context,listen: false).stopLoading()
                              }:{};

                              },
                            child: const Text("Submit data to database",style: TextStyle(color: Colors.white)),
                          ) ),
                      Row(
                        children: [
                          Column(
                            children: [
                              NeonTabButtonWidget(
                                onTap: null,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffF48B19),
                                    Color(0x20F48B19),
                                    Color(0x00F48B19),
                                    Color(0x00F48B19),
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
                                      height: 100,
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
                                      height: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [

                              SizedBox(
                                height: 450,
                                width: 400,
                                child: GridView.builder(
                                  // physics: ScrollPhysics(),
                                  // shrinkWrap: true,
                                    gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                        mainAxisExtent: 60,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5),
                                    padding: const EdgeInsets.only(
                                      top: 15,
                                      bottom: 10,
                                    ),
                                    itemCount: champ.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Expanded(
                                            /*****************************************************************************8
                                             * Drag target  widget
                                             *******************************************************************************/

                                            child: GestureDetector(
                                              onTap: (){
                                                ///
                                                ///     Date 14-May-2023
                                                ///
                                                /// Requirement # 2
                                                /// Here we added another
                                                /// attribute "cost" from API
                                                /// to firestore due to which
                                                /// we can define border colors
                                                /// of images of champs
                                                ///
                                                ///
                                                ChampModel champion=ChampModel(
                                                    champName: champ[index]['name'],
                                                  // imagePath: champ[index]['icon'],

                                                    ///
                                                    /// New image path
                                                    ///
                                                    ///
                                                    imagePath: "${champ[index]['apiName'].toString().toLowerCase()}/hud/${champ[index]['apiName'].toString().toLowerCase()}_square.tft_set$currentSetValue.png",
                                                  champCost: champ[index]['cost'].toString(),
                                                  champTraits: champ[index]['traits'],
                                                  champPositionIndex: index.toString()
                                                );
                                                if(champList.contains(champion)){
                                                  champList.remove(champion);
                                                  champListIndexes.removeAt(champList.indexOf(champion));
                                                  print('removed at ${champList.indexOf(champion)} main geture detector');
                                                  setState(() {

                                                  });
                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Player already exist")));
                                                }else{
                                                  champList.add(champion);
                                                  print('added index: $index');
                                                  champListIndexes.add(index);
                                                  print(champList.length);

                                                  selectAll = true;
                                                  setState(() {

                                                  });
                                                }

                                              },
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  // child
                                                  /// Here I used chosen team indexes for reference if the player exist in team
                                                  /// We will show the icon of player else will show blank polygon icon
                                                  child: champListIndexes.contains(index)?
                                                      GestureDetector(
                                                        onTap: (){
                                                          int indexOfObject = champListIndexes.indexOf(index);
                                                          print('${champList[indexOfObject]} removed at $indexOfObject');
                                                          champList.removeAt(indexOfObject);
                                                          champListIndexes.removeAt(indexOfObject);
                                                          print(indexOfObject);

                                                          setState(() {
                                                          });
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              decoration: const BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow()
                                                                ]
                                                              ),
                                                              child: Stack(
                                                                children: [
                                                                  SmallImageWidget(
                                                                    imageWidth: 60,
                                                                    imageHeight: 60,
                                                                    isBorder: true,
                                                                    // imageUrl: baseUrl + champ[index]['icon'].toString().toLowerCase().replaceAll('.dds', '.png'),
                                                                    ///
                                                                    /// 16-May-2023
                                                                    /// Image patch is changed from
                                                                    /// champion to the provided Url
                                                                    ///
                                                                    ///
                                                                    imageUrl: "$apiImageUrl${champ[index]['apiName'].toString().toLowerCase()}/hud/${champ[index]['apiName'].toString().toLowerCase()}_square.tft_set$currentSetValue.png",
                                                                    borderColor: champ[index]['cost'].toString()=='1'?
                                                                    Colors.grey:champ[index]['cost'].toString()=='2'?
                                                                    Colors.green:champ[index]['cost'].toString()=='3'?
                                                                    Colors.blue:champ[index]['cost'].toString()=='4'?
                                                                    Colors.purple:champ[index]['cost'].toString()=='5'?
                                                                    Colors.yellow:Colors.red
                                                                    ,

                                                                  ),
                                                                  // Image.network(
                                                                  //     baseUrl + champ[index]['icon'].toString().toLowerCase().replaceAll('.dds', '.png'),
                                                                  //     height: 60,
                                                                  //     width: 60,
                                                                  //     fit: BoxFit
                                                                  //         .fill),
                                                                  Align(
                                                                      alignment: Alignment.bottomCenter,
                                                                      child: Text(champ[index]['name'],style: const TextStyle(color:Colors.white,fontSize: 10),textAlign: TextAlign.center))
                                                                ],
                                                              ),
                                                            ),

                                                            Row(
                                                              children: [
                                                                Text('${index+1}',style: const TextStyle(fontSize: 20,color: Colors.white),),
                                                                const Icon(Icons.done,color: Colors.white,)
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                      :Stack(
                                                        children: [
                                                          SmallImageWidget(
                                                            imageWidth: 60,
                                                            imageHeight: 60,
                                                            isBorder: true,
                                                            imageUrl: "$apiImageUrl${champ[index]['apiName'].toString().toLowerCase()}/hud/${champ[index]['apiName'].toString().toLowerCase()}_square.tft_set$currentSetValue.png",
                                                            // imageUrl: baseUrl + champ[index]['icon'].toString().toLowerCase().replaceAll('.dds', '.png'),
                                                            borderColor: champ[index]['cost'].toString()=='1'?
                                                            Colors.grey:champ[index]['cost'].toString()=='2'?
                                                            Colors.green:champ[index]['cost'].toString()=='3'?
                                                            Colors.blue:champ[index]['cost'].toString()=='4'?
                                                            Colors.purple:champ[index]['cost'].toString()=='5'?
                                                            Colors.yellow:Colors.red
                                                            ,

                                                          ),
                                                          // Image.network(
                                                          //   baseUrl + champ[index]['icon'].toString().toLowerCase().replaceAll('.dds', '.png'),
                                                          //   height: 60,
                                                          //   width: 60,
                                                          //   fit: BoxFit
                                                          //       .fill),
                                                          Align(
                                                              alignment: Alignment.bottomCenter,
                                                              child: Text(champ[index]['name'],style: const TextStyle(color:Colors.white,fontSize: 10),textAlign: TextAlign.center,))
                                                        ]
                                                      )

                                                  ,
                                                ),
                                              ),
                                            )
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              NeonTabButtonWidget(
                                onTap: null,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffF48B19),
                                    Color(0x20F48B19),
                                    Color(0x00F48B19),
                                    Color(0x00F48B19),
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
                                      height: 80,
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

                    ],
                  )
                      : SingleChildScrollView(
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /// menu icon
                              IconButton(
                                onPressed: () {
                                  getNameData();
                                },
                                icon: const MenuIcon(),
                              ),
                              const SizedBox(width: 12.0),

                              /// premium button
                              PremiumButton(onTap: () {}),
                              const SizedBox(
                                width: 12,
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12)),
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
                                color: const Color(0xff00ABDE),
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
                                color: const Color(0xffF48B19),
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
                              const SizedBox(
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
                              const SizedBox(width: 8),

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

                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
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
