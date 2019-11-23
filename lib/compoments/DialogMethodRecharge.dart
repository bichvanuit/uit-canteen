import 'package:flutter/material.dart';
import 'package:uit_cantin/canteenAppTheme.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:uit_cantin/models/History.dart';
import 'package:uit_cantin/services/Token.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uit_cantin/config.dart';

class DialogRating extends StatefulWidget {
  final FoodInfo foodInfo;

  DialogRating({
    @required this.foodInfo,
  });
  _DialogRating createState() => _DialogRating();
}

class _DialogRating extends State<DialogRating> {
  double ratingResult = 5;
  int starCount = 5;
  TextEditingController _textFieldController = TextEditingController();

  _rating() async {
    var url = '$SERVER_NAME/food/rating';
    Token token = new Token();
    final tokenValue = await token.getMobileToken();
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + tokenValue,
    };

    var requestBody = new Map<String, dynamic>();
    requestBody["food_id"] = widget.foodInfo.foodId;
    requestBody["rating_comment"] = _textFieldController.text;
    requestBody["star"] = ratingResult;

    var response =
    await http.post(url, body: requestBody, headers: requestHeaders);
    var statusCode = response.statusCode;
    if (statusCode == STATUS_CODE_SUCCESS) {
      var responseBody = json.decode(response.body);
      var status = responseBody["status"];
      print(status);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    _textFieldController.text = "";
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.only(top: 66.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Đánh giá sản phẩm",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  child: new Text(
                    widget.foodInfo.foodName,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                new StarRating(
                  size: 25.0,
                  rating: ratingResult,
                  color: Colors.orange,
                  borderColor: Colors.grey,
                  starCount: starCount,
                  onRatingChanged: (rating) => setState(
                        () {
                          ratingResult = rating;
                    },
                  ),
                ),
                new Container(
                    padding: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(color: Colors.white),
                    child: new TextField(
                      controller: _textFieldController,
                      autofocus: false,
                      decoration: const InputDecoration(
                        hintText: 'Ngon lắm',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      style:
                      const TextStyle(color: Colors.black, fontSize: 16.0),
                    )),
                new GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _rating();
                  },
                  child: new Container(
                    margin: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.white),
                    child: new Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 45.0,
                        alignment: FractionalOffset.center,
                        decoration: new BoxDecoration(
                            color: CanteenAppTheme.main,
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(5.0))),
                        child: new Text("GỬI NHẬN XÉT",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
