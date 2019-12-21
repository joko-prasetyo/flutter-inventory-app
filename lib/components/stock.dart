import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class StockDetail extends StatefulWidget {
  final items;
  StockDetail(this.items);
  @override
  _StockDetailState createState() => _StockDetailState(items);
}

class Edit extends StatefulWidget {
  final item;
  Edit(this.item);
  @override
  _EditState createState() => _EditState(item);
}

class _EditState extends State<Edit> {
  String harga;
  String nama;
  String jumlah;
  String stock;
  String kode;
  String asal_negara;
  int _value = 12;
  var item;
  final _formKey = GlobalKey<FormState>();
  _EditState(item) {
    this.item = item;
    harga = item["harga"].toString();
    nama = item["nama"].toString();
    stock = item["list"][0]["jumlah"];
    kode = item["kode_barang"];
    asal_negara = item["asal_negara"];
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.border_color),
                title: TextFormField(
                  initialValue: nama,
                  decoration: InputDecoration(
                    hintText: "Nama Brand",
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.code),
                title: TextFormField(
                  initialValue: kode,
                  decoration: InputDecoration(
                    hintText: "Kode Barang",
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.attach_money),
                title: TextFormField(
                  initialValue: harga.toString(),
                  decoration: InputDecoration(
                    hintText: "Harga",
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.storage),
                title: Text("Stock: ${stock}"),
              ),
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
                subtitle: Text('${nama}'),
              ),
              ListTile(
                leading: Icon(Icons.location_city),
                title: Text('Asal Negara'),
                subtitle: Text('${asal_negara}'),
              ),
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: RaisedButton(
              //         onPressed: () {
              //           if (_formKey.currentState.validate()) {
              //             print("Ubah");
              //           }
              //         },
              //         child: Text(
              //           "Ubah",
              //           style: TextStyle(color: Colors.white, fontSize: 20),
              //         ),
              //         color: Colors.blue,
              //       ),
              //     ),
              //     SizedBox(
              //       width: 10,
              //     ),
                  // Expanded(
                  //   child: RaisedButton(
                  //     onPressed: () {
                  //       if (_formKey.currentState.validate()) {
                  //         print("Ubah");
                  //       }
                  //     },
                  //     child: Text(
                  //       "Hapus",
                  //       style: TextStyle(color: Colors.white, fontSize: 20),
                  //     ),
                  //     color: Colors.red,
                  //   ),
                  // )
                // ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StockDetailState extends State<StockDetail> {
  List items;
  int _stockCount = 0;
  void _stockCounting() {
    for (var i = 0; i < items.length; i++) {
      _stockCount += items[i]["list"].length;
    }
  }

  _StockDetailState(items) {
    this.items = items;
    _stockCount = items.length;
    // _stockCounting();
  }
  @override
  Widget build(BuildContext context) {
    return _stockCount == 0
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Empty Stock",
                style: TextStyle(fontSize: 20),
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
                          builder: (context) => Edit(items[index])));
                },
                child: Card(
                  elevation: 5.0,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/pexels-photo.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AutoSizeText(
                          "Nike",
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
                        Text(
                          "Stock: ${items[index]['list'][0]['jumlah']} left",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
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
                      ],
                    ),
                  ),
                ),
                onTap: () {
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
                },
              );
            },
          );
  }
}
