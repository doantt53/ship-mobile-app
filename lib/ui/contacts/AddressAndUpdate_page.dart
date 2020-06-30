import 'package:flutter/material.dart';
import 'package:ship/data/global.dart';
import 'package:http/http.dart' as http;
import 'package:ship/data/models/ContactShip.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class PageFull extends StatefulWidget {
  final ContactShip contactShip;

  PageFull({this.contactShip});

  @override
  _PageFullState createState() => _PageFullState();
}

class _PageFullState extends State<PageFull> {
  bool _isLoading = false;
  bool _isFielddeviceIDValid;
  bool _isFieldcodeValid;
  bool _isFieldphoneValid;
  bool _isFieldnameValid;
  TextEditingController _controllerdeviceID = TextEditingController();
  TextEditingController _controllercode = TextEditingController();
  TextEditingController _controllerphone = TextEditingController();
  TextEditingController _controllername = TextEditingController();

  @override
  void initState() {
    if (widget.contactShip != null) {
      _isFielddeviceIDValid = true;
      _controllerdeviceID.text = widget.contactShip.deviceID.toString();
      _isFieldcodeValid = true;
      _controllercode.text = widget.contactShip.code.toString();
      _isFieldphoneValid = true;
      _controllerphone.text = widget.contactShip.phone;
      _isFieldnameValid = true;
      _controllername.text = widget.contactShip.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.contactShip == null ? "Thêm dữ liệu" : "Thay đổi dữ liệu",
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
                      if (_isFielddeviceIDValid == null ||
                          _isFieldcodeValid == null ||
                          _isFieldphoneValid == null ||
                          _isFieldnameValid == null ||
                          !_isFielddeviceIDValid ||
                          !_isFieldcodeValid ||
                          !_isFieldphoneValid ||
                          !_isFieldnameValid) {
                        _scaffoldState.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Vui lòng điền đầy đủ thông tin"),
                          ),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      int deviceID =
                          int.parse(_controllerdeviceID.text.toString().trim());
                      int code =
                          int.parse(_controllercode.text.toString().trim());
                      String phone = _controllerphone.text.trim();
                      String name = _controllername.text.trim();

                      // Create object contact ship
                      ContactShip contactShip =
                          ContactShip(0, deviceID, code, phone, "", name);
                      if (widget.contactShip == null) {
//                        Call api
                        bool res =
                            await UpdateAndCreateContactShip(contactShip);
                        if (res) {
                          Navigator.pop(context); // Back list address book
                        } else {
                          Scaffold.of(this.context).showSnackBar(
                              SnackBar(content: Text("Thêm danh bạ lỗi")));
                        }
                      } else {
                        bool up =
                            await UpdateAndCreateContactShip(contactShip);
                        if (up) {
                          Navigator.pop(context); // Back list address book
                        } else {
                          Scaffold.of(this.context).showSnackBar(
                              SnackBar(content: Text("Sửa danh bạ lỗi")));
                        }
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

  Future<bool> UpdateAndCreateContactShip(ContactShip data) async {
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
      controller: _controllerdeviceID,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Mã thiết bị",
        errorText: _isFielddeviceIDValid == null || _isFielddeviceIDValid
            ? null
            : "Vui lòng nhập mã thiết bị",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFielddeviceIDValid) {
          setState(() => _isFielddeviceIDValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldcode() {
    return TextField(
      controller: _controllercode,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Số thứ tự",
        errorText: _isFieldcodeValid == null || _isFieldcodeValid
            ? null
            : "Vui lòng nhập Code",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldcodeValid) {
          setState(() => _isFieldcodeValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldphone() {
    return TextField(
      controller: _controllerphone,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Số điện thoại",
        errorText: _isFieldphoneValid == null || _isFieldphoneValid
            ? null
            : "Vui lòng nhập số điện thoại",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldphoneValid) {
          setState(() => _isFieldphoneValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldname() {
    return TextField(
      controller: _controllername,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Họ Tên",
        errorText: _isFieldnameValid == null || _isFieldnameValid
            ? null
            : "Vui lòng nhập họ tên",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldnameValid) {
          setState(() => _isFieldnameValid = isFieldValid);
        }
      },
    );
  }
}
