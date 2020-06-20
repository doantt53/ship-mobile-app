import 'package:flutter/material.dart';
import 'package:ship/data/global.dart';
import 'package:http/http.dart' as http;
import 'package:ship/data/models/ContactShip.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  final ContactShip contactShip;

  FormAddScreen({this.contactShip});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;

  TextEditingController _controllerDeviceID = TextEditingController();
  TextEditingController _controllerCode = TextEditingController();
  TextEditingController _controllerPhone = TextEditingController();
  TextEditingController _controllerName = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Thêm liên lạc",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                _buildTextFielddeviceID(),
                _buildTextFieldcode(),
                _buildTextFieldphone(),
                _buildTextFieldname(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    child: Text(
                      widget.contactShip == null
                          ? "Thêm".toUpperCase()
                          : "Sửa".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      int deviceID =
                          int.parse(_controllerDeviceID.text.toString().trim());
                      int code =
                          int.parse(_controllerCode.text.toString().trim());
                      String phone = _controllerPhone.text.trim();
                      String name = _controllerName.text.trim();

                      // Create object contact ship
                      ContactShip contactShip =
                          ContactShip(0, deviceID, code, phone, "", name);

                      // Call api
                      bool res = await updateAndCreateContactShip(contactShip);
                      if (res) {
                        Navigator.pop(context); // Back list address book
                      } else {
                        Scaffold.of(this.context).showSnackBar(
                            SnackBar(content: Text("Thêm danh bạ lỗi")));
                      }
                    },
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> updateAndCreateContactShip(ContactShip data) async {
    String _url = URL_ADD_ADDRESS_BOOK +
        "deviceID=${data.deviceID}&Code=${data.code}&Phone=${data.phone}&Name=${data.name}";
    print(_url);

    final response = await http.get(_url);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Widget _buildTextFielddeviceID() {
    return TextField(
      controller: _controllerDeviceID,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Mã thiết bị",
//        errorText: _isFielddeviceIDValid == null || _isFielddeviceIDValid
//            ? null
//            : "Vui lòng nhập ID thiết bị",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
//        if (isFieldValid != _isFielddeviceIDValid) {
//          setState(() => _isFielddeviceIDValid = isFieldValid);
//        }
      },
    );
  }

  Widget _buildTextFieldcode() {
    return TextField(
      controller: _controllerCode,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Code",
//        errorText: _isFieldcodeValid == null || _isFieldcodeValid
//            ? null
//            : "Vui lòng nhập Code",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
//        if (isFieldValid != _isFieldcodeValid) {
//          setState(() => _isFieldcodeValid = isFieldValid);
//        }
      },
    );
  }

  Widget _buildTextFieldphone() {
    return TextField(
      controller: _controllerPhone,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Số điện thoại",
//        errorText: _isFieldphoneValid == null || _isFieldphoneValid
//            ? null
//            : "Vui lòng nhập số điện thoại",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
//        if (isFieldValid != _isFieldphoneValid) {
//          setState(() => _isFieldphoneValid = isFieldValid);
//        }
      },
    );
  }

  Widget _buildTextFieldname() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Họ Tên",
//        errorText: _isFieldnameValid == null || _isFieldnameValid
//            ? null
//            : "Vui lòng nhập tên",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
//        if (isFieldValid != _isFieldnameValid) {
//          setState(() => _isFieldnameValid = isFieldValid);
//        }
      },
    );
  }
}
