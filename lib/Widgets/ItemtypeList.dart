import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final List<String> itemTypeList = [
  'Orphanage',
  'Children',
  'Shelter',
  'Senior citizen',
  'Rural area',
  'Food',
  'Toys',
  'Textbook',
  'Stationary',
  'Clothes',
  'Spring',
  'Winter',
  'Mid-autumn',
  'Children’s day',
  'Environment',
  'Pollution',
  'Community',
  'Donation',
  'Disablers',
  'Jobs'
];

class ItemTypeList extends StatefulWidget {
  final List<bool> indexList;
  ItemTypeList(this.indexList);
  @override
  State<StatefulWidget> createState() {
    return ItemTypeListState(indexList);
  }
}

class ItemTypeListState extends State<ItemTypeList> {
  List<bool> indexList;
  ItemTypeListState(this.indexList);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            RaisedButton(
                textColor: Colors.white,
                onPressed: () {
                  List<String> resultList = List();
                  for(int i = 0; i<indexList.length;++i){
                     if(indexList[i]) resultList.add(itemTypeList[i]);
                  }
                  Navigator.pop(context, [resultList,indexList]);
                },
                color: Colors.blue[400],
                child: Text(
                  "Done",
                  //style: TextStyle(fontSize: 11),
                ))
          ],
          title: Text("Tags",
              style: const TextStyle(
                fontSize: 22,
                fontFamily: 'Manjari',
              )),
        ),
        body: ListView.builder(
            itemCount: itemTypeList.length,
            itemBuilder: (context, index) {
              return InkWell(
                  splashColor:
                      (indexList[index]) ? Colors.white : Colors.blue[400],
                  onTap: () {
                    setState(() {
                      indexList[index] = !indexList[index];
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: (indexList[index]) ? Colors.blue[400] : Colors.white,
                    child: Text(
                      itemTypeList[index],
                      style: TextStyle(
                          color:
                              (indexList[index]) ? Colors.white : Colors.black),
                    ),
                  ));
            }));
  }
}
