import 'package:flutter/material.dart';
import '/screens/components/trails_item_widget.dart';

import '../../constants/exports.dart';

class TraitsBox extends StatefulWidget {
  Map<dynamic,dynamic> traits;
  TraitsBox({required this.traits,Key? key}) : super(key: key);

  @override
  State<TraitsBox> createState() => _TraitsBoxState();
}

class _TraitsBoxState extends State<TraitsBox> {

  List mapKeys=[];
  List mapValues=[];

  convertMapToLists(){
    print("=============> Begin Map to Lists of key values  <=============");
    print("traits length is:${widget.traits.length}");
    print("Convert map  called");
    print(widget.traits.values.length);
    for (int i=0;i< widget.traits.length;i++) {
      print("I am at for loop");
      mapKeys.add(widget.traits.keys);
      print(mapKeys);
      // mapValues.add(element);
      print("Element added");

    }
    for (var element in widget.traits.keys) {
      mapKeys.add(element);
      print("Key added");
    }
    print("=============> End Map to Lists of key values  <=============");
  }
  @override
  void initState() {
    convertMapToLists();
    print("Traitsbox is called");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context),
      height: 100,
      decoration: threeBoxDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Traits',
            style: GoogleFonts.poppins(
              fontSize: 12.0,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 30,
            width: MediaQuery.of(context).size.width*.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:widget.traits.length,
              itemBuilder: (context,index){

                for (var element in widget.traits.values) {
                  mapValues.add(element);
                }
                for (var element in widget.traits.keys) {
                  mapValues.add(element);
                }

                return TrailItemWidget(trait:mapValues[index].toString(),index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}