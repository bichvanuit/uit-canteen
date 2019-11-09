import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uit_cantin/pages/WalletInfo.dart';

class InfoBankScreen extends StatefulWidget {
  @override
  _InfoBankState createState() => _InfoBankState();
}

class _InfoBankState extends State<InfoBankScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
          //  title: appBarTitle,
          iconTheme: new IconThemeData(color: Colors.white),
          //  leading: _isSearching ? const BackButton() : null,
          title: Text("Liên kết"),
        ),
        body: SingleChildScrollView(
          child: new Container(
            margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: new Column(
              children: <Widget>[
                new Container(
                  child: Image.asset('assets/atm.png'),
                ),
                new Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: new TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color:
                          Colors.grey),
                      decoration:
                      InputDecoration(
                        labelText:
                        "Nhập số thẻ",
                        labelStyle: TextStyle(
                            color:
                            Colors.grey),
                        enabledBorder:
                        const UnderlineInputBorder(
                          borderSide:
                          const BorderSide(
                              color: Colors
                                  .grey,
                              width: 0.0),
                        ),
                      ),
                      validator:
                          (String value) {
                        if (value.isEmpty)
                          return "Bạn chưa nhập số thẻ";
                        return null;
                      }),
                ),
                new Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: new TextFormField(
                      style: TextStyle(
                          color:
                          Colors.grey),
                      decoration:
                      InputDecoration(
                        labelText:
                        "Nhập mã PIN thẻ ATM",
                        labelStyle: TextStyle(
                            color:
                            Colors.grey),
                        enabledBorder:
                        const UnderlineInputBorder(
                          borderSide:
                          const BorderSide(
                              color: Colors
                                  .grey,
                              width: 0.0),
                        ),
                      ),
                      validator:
                          (String value) {
                        if (value.isEmpty)
                          return "Bạn chưa nhập mã pin ATM";
                        return null;
                      }),
                ),
                new GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WalletInfoScreen()));
                    });
                  },
                  child: new Container(
                    margin: const EdgeInsets.only(top: 100.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.white),
                    child: new Container(
                        height: 45.0,
                        alignment: FractionalOffset.center,
                        decoration: new BoxDecoration(
                            color: const Color.fromRGBO(
                                229, 32, 32, 1.0),
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(5.0))),
                        child: new Text("Tiếp tục",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ))),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
