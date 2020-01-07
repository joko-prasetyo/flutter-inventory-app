import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as http;
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class StockDetail extends StatefulWidget {
  final items;
  final stocks;
  final Function renderScreen;
  final String _string;
  StockDetail(this.items, this.stocks, this.renderScreen, this._string);
  @override
  _StockDetailState createState() =>
      _StockDetailState(items, stocks, renderScreen, _string);
}

class Edit extends StatefulWidget {
  final item;
  final Function renderScreen;
  Edit(this.item, this.renderScreen);
  @override
  _EditState createState() => _EditState(item, renderScreen);
}

class _EditState extends State<Edit> {
  var item;
  final _formKey = GlobalKey<FormState>();
  Function renderScreen;
  var _brandBody = {};
  var _itemBody = {};
  var _stockBody = {};
  int quantitySlider;
  int _sizeSlider;
  _EditState(item, renderScreen) {
    this.item = item;
    this.quantitySlider = item["stock_info"]["quantity"];
    this._sizeSlider = item["stock_info"]["size"];
    this.renderScreen = renderScreen;
  }

  File _image;
  Future getImage(item) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Directory dir = await getApplicationDocumentsDirectory();
      String path = dir.path;
      await image.copy('$path/${item["_id"]}.jpg');
      setState(() {
        _image = image;
      });
    }
  }

  void _edit(item) async {
    String url;
    var body;
    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    var responseBrand;
    var responseItem;
    var responseImage;
    var responseStock;
    var dio = http.Dio();
    try {
      if (_stockBody.isNotEmpty) {
        url =
            'https://store-inventory-apis.herokuapp.com/stocks/${item["stock_info"]["_id"]}';
        body = jsonEncode(_stockBody);
        responseStock = await patch(url, body: body, headers: headers);
      }
      if (_image != null) {
        url =
            'https://store-inventory-apis.herokuapp.com/items/${item["_id"]}/image';
        Directory dir = await getApplicationDocumentsDirectory();
        String path = dir.path;
        http.FormData formData = http.FormData.fromMap({
          "image": await http.MultipartFile.fromFile(
              "${path.toString()}/${item["_id"]}.jpg")
        });
        responseImage = await dio.post(url, data: formData);
      }
      if (_brandBody.isNotEmpty) {
        url =
            'https://store-inventory-apis.herokuapp.com/brands/${item["brand_id"]["_id"]}';
        body = jsonEncode(_brandBody);
        responseBrand = await patch(url, body: body, headers: headers);
      }
      if (_itemBody.isNotEmpty) {
        url = 'https://store-inventory-apis.herokuapp.com/items/${item["_id"]}';
        body = jsonEncode(_itemBody);
        responseItem = await patch(url, body: body, headers: headers);
      }
      if ((responseBrand != null && responseBrand.statusCode == 200 ||
          responseItem != null && responseItem.statusCode == 200 ||
          responseImage != null && responseImage.statusCode == 200 ||
          responseStock != null && responseStock.statusCode == 200)) {
        return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Informasi'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[Text("Barang berhasil di ubah")],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  onPressed: () {
                    renderScreen();
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      } else {
        return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Informasi'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        "Gambar terlalu besar atau Kode barang sudah terdaftar")
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }
    } on Exception catch (_) {
      Navigator.of(context).pop();
      renderScreen();
    }
  }

  void _delete(String id) async {
    String url =
        'https://store-inventory-apis.herokuapp.com/items/${id.toString()}';
    try {
      var response = await delete(url);
      if (response.statusCode == 200) {
        return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Informasi'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[Text("Barang berhasil di hapus")],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  onPressed: () {
                    renderScreen();
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }
    } on Exception catch (_) {
      Navigator.of(context).pop();
      renderScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "Info Barang",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.border_color),
                  title: TextFormField(
                    initialValue: item["brand_id"]["name"],
                    validator: (val) {
                      if (val != item["brand_id"]["name"]) {
                        _brandBody["name"] = val.toString();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Nama Brand",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.code),
                  title: TextFormField(
                    validator: (val) {
                      if (val != item["itemCode"]) {
                        _itemBody["itemCode"] = val.toString();
                      }
                      return null;
                    },
                    initialValue: item["itemCode"],
                    decoration: InputDecoration(
                      hintText: "Kode Barang",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.attach_money),
                  title: TextFormField(
                    validator: (val) {
                      if (val != item["price"].toString()) {
                        _itemBody["price"] = val.toString();
                      }
                      return null;
                    },
                    initialValue: item["price"].toString(),
                    decoration: InputDecoration(
                      hintText: "Harga",
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                    subtitle: Slider(
                      divisions: 200,
                      label: 'Stock: ${quantitySlider.toString()}',
                      activeColor: Colors.indigoAccent,
                      min: 0,
                      max: 200,
                      onChanged: (double val) {
                        setState(() {
                          quantitySlider = val.round();
                          _stockBody["quantity"] = val.toString();
                        });
                      },
                      value: quantitySlider.toDouble(),
                    ),
                    leading: Icon(Icons.storage),
                    title: Text('Stock: ${quantitySlider.toString()}')),
                ListTile(
                    subtitle: Slider(
                      divisions: 150,
                      label: 'Size: ${_sizeSlider.toString()}',
                      activeColor: Colors.indigoAccent,
                      min: 0,
                      max: 150,
                      onChanged: (double val) {
                        setState(() {
                          _stockBody["size"] = val.toString();
                          _sizeSlider = val.round();
                        });
                      },
                      value: _sizeSlider.toDouble(),
                    ),
                    leading: Icon(Icons.info),
                    title: Text('Size: ${_sizeSlider.toString()}')),
                Divider(
                  height: 1.0,
                ),
                ListTile(
                  title: Text(
                    'Additional Info',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.branding_watermark),
                  title: Text('Merek'),
                  subtitle: Text('${item["brand_id"]["name"]}'),
                ),
                ListTile(
                  leading: Icon(Icons.location_city),
                  title: Text('Asal Negara'),
                  subtitle: Text('${item["brand_id"]["origin"]}'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          getImage(item);
                        },
                        child: _image == null
                            ? CachedNetworkImage(
                                imageUrl: 'https://via.placeholder.com/100')
                            : Image.file(
                                _image,
                                width: 75.0,
                                height: 75.0,
                                fit: BoxFit.fill,
                              ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate() &&
                              (_itemBody.isNotEmpty ||
                                  _brandBody.isNotEmpty ||
                                  _image != null ||
                                  _stockBody.isNotEmpty)) {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Catatan'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                            "Ingin mengubah informasi barang ?")
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        'Ya',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _edit(item);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        'Tidak',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          } else {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Gagal mengubah'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                            "Silahkan mengubah informasi barang.")
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        'Ok',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          "Ubah",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Catatan'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                            "Ingin menghapus barang beserta stock ?")
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        'Ya',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _delete(item["_id"]);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        'Tidak',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          "Hapus",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StockDetailState extends State<StockDetail> {
  List items;
  int _stockCount = 0;
  // void _stockCounting() {
  //   for (var i = 0; i < items.length; i++) {
  //     _stockCount += items[i]["list"].length;
  //   }
  // }
  dynamic stocks;
  Function renderScreen;
  String _string;
  _StockDetailState(items, stocks, renderScreen, _string) {
    this.items = items;
    this.stocks = stocks;
    this.renderScreen = renderScreen;
    this._string = _string;
    for (int i = 0; i < items.length; i++) {
      for (int j = 0; j < stocks.length; j++) {
        if (this.items[i]["_id"] == this.stocks[j]["item_id"]) {
          this.items[i]["stock_info"] = this.stocks[j];
        }
      }
    }
    _stockCount = items.length;
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _stockCount == 0
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Barang Kosong",
                style: TextStyle(fontSize: 30),
              )
            ],
          ))
        : GridView.builder(
            itemCount: _stockCount,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onLongPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Edit(items[index], renderScreen)));
                },
                child: Card(
                  elevation: 5.0,
                  child: Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl:
                              "https://store-inventory-apis.herokuapp.com/items/${items[index]["_id"]}/image?dummy=${_string.toString()}",
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                  backgroundColor: Colors.blue)),
                          errorWidget: (context, url, error) => Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.not_interested,
                                size: 80,
                                color: Colors.red,
                              ),
                              Text(
                                "Image Not Found",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          )),
                        ),
                        Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            AutoSizeText(
                              items[index]["brand_id"]["name"],
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                    offset: Offset(5, 5),
                                  )
                                ],
                              ),
                            ),
                            // Column(
                            //   children: <Widget>[
                            //     Text(
                            //       "Rp. ${items[index]['price'].toString()}",
                            //       style: TextStyle(
                            //         color: Colors.white,
                            //         fontSize: 30,
                            //         fontWeight: FontWeight.normal,
                            //         shadows: [
                            //           Shadow(
                            //             blurRadius: 10.0,
                            //             color: Colors.black,
                            //             offset: Offset(5, 5),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Text(
                            //       "${items[index]['stock_info']["quantity"]} left",
                            //       style: TextStyle(
                            //         color: Colors.white,
                            //         fontSize: 30,
                            //         fontWeight: FontWeight.normal,
                            //         shadows: [
                            //           Shadow(
                            //             blurRadius: 10.0,
                            //             color: Colors.black,
                            //             offset: Offset(5, 5),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // )
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
                // onTap: () {
                // showDialog(
                //   barrierDismissible: false,
                //   context: context,
                //   child: CupertinoAlertDialog(
                //     title: Column(
                //       children: <Widget>[
                //         Text("GridView"),
                //         Icon(
                //           Icons.favorite,
                //           color: Colors.green,
                //         ),
                //       ],
                //     ),
                //     content: Text("Selected Item $index"),
                //     actions: <Widget>[
                //       FlatButton(
                //           onPressed: () {
                //             Navigator.of(context).pop();
                //           },
                //           child: Text("OK"))
                //     ],
                //   ),
                // );
                // },
              );
            },
          );
  }
}
