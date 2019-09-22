import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final List<String> tagsList = [
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

class TagsList extends StatefulWidget {
  final List<bool> indexList;
  TagsList(this.indexList);
  @override
  State<StatefulWidget> createState() {
    return TagsListState(indexList);
  }
}

class TagsListState extends State<TagsList> {
  List<bool> indexList;
  TagsListState(this.indexList);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            RaisedButton(
                onPressed: () {
                  List<String> resultList = List();
                  for(int i = 0; i<indexList.length;++i){
                     if(indexList[i]) resultList.add(tagsList[i]);
                  }
                  Navigator.pop(context, [resultList,indexList]);
                },
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
            itemCount: tagsList.length,
            itemBuilder: (context, index) {
              return InkWell(
                  splashColor:
                      (indexList[index]) ? Colors.white : Colors.deepOrange[600],
                  onTap: () {
                    setState(() {
                      indexList[index] = !indexList[index];
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: (indexList[index]) ? Colors.deepOrange[600]: Colors.white,
                    child: Text(
                      tagsList[index],
                      style: TextStyle(
                          color:
                              (indexList[index]) ? Colors.white : Colors.black),
                    ),
                  ));
            }));
  }
}
