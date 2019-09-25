import 'package:LadyBug/Customize/MultiLanguage.dart';
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
  'Children\'s day',
  'Environment',
  'Pollution',
  'Community',
  'Donation',
  'Handicapped',
  'Jobs'
];
final Map<String, Map<String, String>> itemTagsMap = {
  'vi': {
    'Orphanage': 'Trại mồ côi',
    'Children': 'Trẻ em',
    'Shelter': 'Mái ấm',
    'Senior citizen': 'Người già',
    'Rural area': 'Vùng sâu vùng xa',
    'Food': 'Thức ăn',
    'Toys': 'Đồ chơi',
    'Textbook': 'Sách giáo khoa',
    'Stationary': 'Sách vở, bút,...',
    'Clothes': 'Quần áo',
    'Spring': 'Dịp  mùa xuân',
    'Winter': 'Dịp mùa đông',
    'Mid-autumn': 'Dịp Trung thu',
    'Children\'s day': 'Dịp Quốc tế Thiếu nhi',
    'Environment': 'Môi trường',
    'Pollution': 'Ô nhiễm',
    'Community': 'Cộng đồng',
    'Donation': 'Quyên góp',
    'Handicapped': 'Người tàn tật',
    'Jobs': 'Việc làm'
  },
  'en': {
    'Orphanage': 'Orphanage',
    'Children': 'Children',
    'Shelter': 'Shelter',
    'Senior citizen': 'Senior citizen',
    'Rural area': 'Rural area',
    'Food': 'Food',
    'Toys': 'Toys',
    'Textbook': 'Textbook',
    'Stationary': 'Stationary',
    'Clothes': 'Clothes',
    'Spring': 'Spring',
    'Winter': 'Winter',
    'Mid-autumn': 'Mid-autumn',
    'Children\'s day': 'Children\'s day',
    'Environment': 'Environment',
    'Pollution': 'Pollution',
    'Community': 'Community',
    'Donation': 'Donation',
    'Handicapped': 'Handicapped',
    'Jobs': 'Jobs'
  }
};

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
                  for (int i = 0; i < indexList.length; ++i) {
                    if (indexList[i]) resultList.add(tagsList[i]);
                  }
                  Navigator.pop(context, [resultList, indexList]);
                },
                child: Text(
                   captions['en']["done"],
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
                  splashColor: (indexList[index])
                      ? Colors.white
                      : Colors.deepOrange[600],
                  onTap: () {
                    setState(() {
                      indexList[index] = !indexList[index];
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: (indexList[index])
                        ? Colors.deepOrange[600]
                        : Colors.white,
                    child: Text(
                      itemTagsMap[setLanguage][tagsList[index]],
                      style: TextStyle(
                          color:
                              (indexList[index]) ? Colors.white : Colors.black),
                    ),
                  ));
            }));
  }
}
