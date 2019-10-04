/*
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:uit_cantin/models/Order.dart';

class CartOnePage extends StatelessWidget {
  static final String path = "lib/src/pages/ecommerce/cart1.dart";
  List<Order> listOrder = <Order>[
    new Order(
        1,
        1,
        1,
        'Bánh mì ốp la',
        '10000',
        '80000',
        'https://banhmro.com.vn/wp-content/uploads/2017/02/cach-lam-trung-op-la-ngon-dep-va-don-gian-an-voi-banh-mi.jpg',
        1,
        3),
    new Order(
        1,
        1,
        1,
        'Bánh mì ốp la',
        '10000',
        '80000',
        'https://banhmro.com.vn/wp-content/uploads/2017/02/cach-lam-trung-op-la-ngon-dep-va-don-gian-an-voi-banh-mi.jpg',
        1,
        3),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal:16.0, vertical: 30.0),
                child: Text("ĐƠN HÀNG CỦA BẠN", style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700
                ),)),
            Expanded(child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: listOrder.length,
              itemBuilder: (BuildContext context, int index){
                return Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(right: 30.0, bottom: 10.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(5.0),
                        elevation: 3.0,
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 80,
                                child: Image.network(listOrder[index].image),
                              ),
                              SizedBox(width: 10.0,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(listOrder[index].foodName, style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold
                                    ),),
                                    SizedBox(height: 20.0,),
                                    Text(listOrder[index].discountPrice, style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0
                                    ),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 15,
                      child: Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                          padding: EdgeInsets.all(0.0),
                          color:  Color.fromRGBO(229, 32, 32, 1.0),
                          child: Icon(Icons.clear, color: Colors.white,),
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
                );
              },

            ),),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("Tổng cộng     50000", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                  ),),
                  SizedBox(height: 20.0,),
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      height: 50.0,
                      color: Color.fromRGBO(229, 32, 32, 1.0),
                      child: Text("Thanh toán".toUpperCase(), style: TextStyle(
                          color: Colors.white
                      ),),
                      onPressed: (){},
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
