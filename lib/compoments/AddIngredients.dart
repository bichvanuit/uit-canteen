import 'package:flutter/material.dart';
import 'package:uit_cantin/compoments/IngredientWidget.dart';
import 'package:uit_cantin/models/CategoryDetail.dart';
import 'package:uit_cantin/models/FoodInfo.dart';


class AddIngredients extends StatefulWidget {
  _AddIngredients createState() => new _AddIngredients();
}

List<CategoryDetail> listCategory = <CategoryDetail>[
  new CategoryDetail(
      2,
      3,
      "Món mặn",
      "https://img-global.cpcdn.com/005_recipes/de1529327b7fd7f1/751x532cq70/cơm-sườn-nứơng-ướp-sốt-ca-chua-tomato-sauce🍅🍅-recipe-main-photo.jpg",
      5
  ),
  new CategoryDetail(
      2,
      4,
      "Món canh",
      "http://yeunoitro.net/wp-content/uploads/canh-bi-xanh-nau-xuong-300x225.jpg",
      10
  ),
  new CategoryDetail(
      2,
      5,
      "Món xào",
      "http://mevaobep.com/wp-content/uploads/2015/10/thanh-dam-cung-mon-rau-muong-xao-toi-02.jpg",
      10
  )
];
int activeIndex = 0;

class _AddIngredients extends State<AddIngredients> {

  @override
  initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context){
    return new Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: new Column(
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: new Text("Bạn có muốn chọn thêm món",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20))
              ),
              new Container(
                  padding: EdgeInsets.only(top: 15),
                  height: MediaQuery.of(context).size.height*0.2,
                  child: new ListView.builder(
                      itemCount: listCategory.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, position) {
                        return Container(
                            padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                            child: new GestureDetector(
                                onTap: (){
                                  setState(() {
                                    activeIndex = position;
                                  });
                                },
                                child: new Column(
                                    children: <Widget>[
                                      new Container(
                                        width: MediaQuery.of(context).size.height*0.1,
                                        height: MediaQuery.of(context).size.height*0.1,
                                        decoration: new BoxDecoration(
                                          color: const Color(0xff7c94b6),
                                          image: new DecorationImage(
                                            image: new NetworkImage(listCategory[position].image),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                                          border: new Border.all(
                                            color: position == activeIndex ? Colors.red : Colors.transparent,
                                            width: 4.0,
                                          ),
                                        ),
                                      ),
                                      new Center(
                                          child: new Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: new Text(listCategory[position].foodTypeName)))
                                    ]
                                )
                            )
                        );
                      })
              ),
              /*new Container(
                  height: 220,
                  child: new ListView.builder(
                      itemCount: listItem.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, position) {
                        return Container(
                            padding: EdgeInsets.only(right: 10, bottom: 20),
                            child: new IngredientWidget(food: listItem[position])
                        );
                      })
              ),*/
            ]
        )
    );
  }
}