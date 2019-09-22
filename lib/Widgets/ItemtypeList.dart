import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final List<String> itemTypeList = [
  'Books',
  'Clothes',
  'Household goods',
  'Toys',
  'Food',
  'Money',
  'School supplies',
  'Stationary'
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
                onPressed: () {
                  List<String> resultList = List();
                  for (int i = 0; i < indexList.length; ++i) {
                    if (indexList[i]) resultList.add(itemTypeList[i]);
                  }
                  Navigator.pop(context, [resultList, indexList]);
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
            itemCount: itemTypeList.length,
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
                      itemTypeList[index],
                      style: TextStyle(
                          color:
                              (indexList[index]) ? Colors.white : Colors.black),
                    ),
                  ));
            }));
  }
}
