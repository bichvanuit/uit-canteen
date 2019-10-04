import 'package:flutter/material.dart';
import 'package:uit_cantin/pages/Payment.dart';
import 'package:uit_cantin/pages/Order.dart';
import 'package:uit_cantin/pages/QRCode.dart';

class OrderListScreen extends StatefulWidget {
  @override
  _OrderList createState() => _OrderList();
}

class _OrderList extends State<OrderListScreen> {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
  }

  List<Step> _mySteps() {
    List<Step> _steps = [
      Step(
        title: Text('Thông tin đơn hàng'),
        content: new GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new OrderScreen()));
          },
          child: new Container(
            child: new Text("Xem đơn hàng của bạn"),
          ),
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('Phương thức thanh toán'),
        content: new GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new PaymentMethodScreen()));
          },
          child: new Container(
            child: new Text("Chọn phương thức thanh toán"),
          ),
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('Vị trí'),
        content: new GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new QRCodeScreen()));
          },
          child: new Container(
            child: new Text("Chọn chỗ ngồi"),
          ),
        ),
        isActive: _currentStep >= 2,
      )
    ];
    return _steps;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Color.fromRGBO(229, 32, 32, 1.0),
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("Đơn hàng của bạn")),
      body: new Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(229, 32, 32, 1.0),
          ),
          child: new Container(
              color: Colors.white,
              child: new Theme(
                data: Theme.of(context).copyWith(
                  // sets the background color of the `BottomNavigationBar`
                    canvasColor: Colors.white,
                    // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                    primaryColor: Color.fromRGBO(229, 32, 32, 1.0),
                    textTheme: Theme
                        .of(context)
                        .textTheme
                        .copyWith(caption: new TextStyle(color: Colors.grey))), // sets the inactive color of the `BottomNavigationBar`
                child: Stepper(
                  controlsBuilder: (BuildContext context,
                          {VoidCallback onStepContinue,
                          VoidCallback onStepCancel}) =>
                      Container(),
                  steps: _mySteps(),
                  currentStep: this._currentStep,
                  onStepTapped: (step) {
                    setState(() {
                      this._currentStep = step;
                    });
                  },
                  onStepContinue: () {
                    setState(() {
                      if (this._currentStep < this._mySteps().length - 1) {
                        this._currentStep = this._currentStep + 1;
                      } else {
                        //Logic to check if everything is completed
                        print('Completed, check fields.');
                      }
                    });
                  },
                  onStepCancel: () {
                    setState(() {
                      if (this._currentStep > 0) {
                        this._currentStep = this._currentStep - 1;
                      } else {
                        this._currentStep = 0;
                      }
                    });
                  },
                ),
              ))),
    );
  }
}
