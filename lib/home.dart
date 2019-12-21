import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'components/stock.dart';
import 'components/transaction_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class AddTransaction extends StatefulWidget {
  final Function _renderScreen;
  AddTransaction(this._renderScreen);
  @override
  _AddTransactionState createState() => _AddTransactionState(_renderScreen);
}

class _AddTransactionState extends State<AddTransaction> {
  Map<Object, String> _body = {};
  final Function _renderScreen;
  _AddTransactionState(this._renderScreen);
  String dropdownValue = 'One';
  String _totalHarga = "-";
  _addTransactionHandler() async {
    String url = 'http://10.0.2.2:8000/api/sale';
    Map<String, String> bodies = {
      "nomor_nota": "${_body['nota']}",
      "customer_id": "${_body['customer_id']}",
      "item_id": "${_body['barang_id']}",
      "ukuran": "${_body['ukuran']}",
      "jumlah_barang": "${_body['jumlah']}",
      "total_harga": "${_totalHarga}"
    };
    var response = await post(url, body: bodies);
    // print(response.body);
    Navigator.of(context).pop();
    _renderScreen;
    // return showDialog<void>(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text('Informasi'),
    //       content: SingleChildScrollView(
    //         child: ListBody(
    //           children: <Widget>[Text("Transaksi telah di tambah")],
    //         ),
    //       ),
    //       actions: <Widget>[
    //         FlatButton(
    //           child: Text(
    //             'Ok',
    //             style: TextStyle(color: Colors.black, fontSize: 15),
    //           ),
    //           onPressed: () {
    //             // _renderScreen();
    //           },
    //         )
    //       ],
    //     );
    //   },
    // );
  }

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Tambah Transaksi"),
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
                    validator: (val) {
                      if (val.isEmpty) return "Form should not be empty";
                      _body["nama"] = val;
                    },
                    decoration: InputDecoration(
                      hintText: "Nama Barang",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.people),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Form should not be empty";
                      _body["customer_id"] = val;
                    },
                    decoration: InputDecoration(
                      hintText: "Customer Id",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.code),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Form should not be empty";
                      _body["nota"] = val;
                    },
                    decoration: InputDecoration(
                      hintText: "Nomor Nota",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.format_list_numbered),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Form should not be empty";
                      _body["ukuran"] = val;
                    },
                    decoration: InputDecoration(
                      hintText: "Ukuran",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.label),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Form should not be empty";
                      _body["barang_id"] = val;
                    },
                    decoration: InputDecoration(
                      hintText: "Barang id",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.code),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Form should not be empty";
                      _body["kode_barang"] = val;
                    },
                    decoration: InputDecoration(
                      hintText: "Kode Barang",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.code),
                  title: TextField(
                    onChanged: (val) {
                      _body["harga"] = val;
                    },
                    decoration: InputDecoration(
                      hintText: "Harga",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.add_shopping_cart),
                  title: TextField(
                    onChanged: (String val) {
                      _body["jumlah"] = val;
                      setState(() {
                        val == ""
                            ? _totalHarga = "-"
                            : _totalHarga =
                                (int.parse(val) * int.parse(_body["harga"]))
                                    .toString();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Jumlah",
                    ),
                  ),
                ),
                ListTile(
                  title: Row(
                    children: [
                      Text("Total Harga: Rp. $_totalHarga"),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                ),
                Divider(
                  height: 1.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _addTransactionHandler();
                          }
                        },
                        child: Text(
                          "Tambah",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Colors.blue,
                      ),
                    ),
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

class AddBarang extends StatefulWidget {
  List brands;
  List items;
  AddBarang(this.brands, this.items);
  @override
  _AddBarangState createState() => _AddBarangState(brands, items);
}

class _AddBarangState extends State<AddBarang> {
  String dropDownValue = 'Nike';
  String _dropDownValue = '1';
  Map<Object, String> _body = {};
  List brands;
  List items;
  _AddBarangState(brands, items) {
    this.brands = brands;
    this.items = items;
  }
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _formValidator(String val) {
    if (val.isEmpty) {
      return "Field should not be empty";
    }
    return null;
  }

  void _addBarang(context) async {
    String url = 'http://10.0.2.2:8000/api/item';
    Map<String, String> bodies = {
      "kode_barang": "${_body['kode_barang']}",
      "brand_id": "${_body['brand_id']}",
      "supplier_id": "${_body['supplier_id']}",
      "harga": "${_body['harga']}"
    };
    var response = await post(url, body: bodies);
    String url1 = 'http://10.0.2.2:8000/api/stock';
    var item_id = jsonDecode(response.body);
    Map<String, String> bodies1 = {
      "item_id": "${item_id['data']['id'].toString()}",
      "ukuran": "${_body['ukuran'].toString()}",
      "jumlah": "${_body['jumlah'].toString()}"
    };
    var response1 = await post(url1, body: bodies1);
    if (response.statusCode == 201 && response1.statusCode == 201) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Informasi'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text('Barang Berhasil di Tambah')],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Tambah Barang"),
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
                  leading: Icon(Icons.label),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Field should not be empty";
                      _body["supplier_id"] = val.toString();
                    },
                    decoration: InputDecoration(
                      hintText: "Supplier id",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.branding_watermark),
                  title: DropdownButton(
                    isExpanded: true,
                    hint: Text('Pilih Merek'),
                    value: dropDownValue,
                    onChanged: (newValue) {
                      setState(() {
                        dropDownValue = newValue;
                        for (int i = 0; i < brands.length; i++) {
                          if (brands[i]["nama"] == newValue) {
                            _body["brand_id"] = brands[i]["id"].toString();
                          }
                        }
                      });
                    },
                    items: brands.map((item) {
                      return DropdownMenuItem(
                        child: new Text(item["nama"]),
                        value: item["nama"],
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.branding_watermark),
                  title: DropdownButton(
                    isExpanded: true,
                    hint: Text('Pilih Item id'),
                    value: _dropDownValue,
                    onChanged: (newValue) {
                      setState(() {
                        _dropDownValue = newValue.toString();
                        _body["item_id"] = newValue.toString();
                      });
                    },
                    items: items.map((item) {
                      return DropdownMenuItem(
                        child: new Text(item["id"].toString()),
                        value: item["id"].toString(),
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.label),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Field should not be empty";
                      _body["ukuran"] = val.toString();
                    },
                    decoration: InputDecoration(
                      hintText: "Ukuran",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.label),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Field should not be empty";
                      _body["jumlah"] = val.toString();
                    },
                    decoration: InputDecoration(
                      hintText: "Jumlah",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.label),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Field should not be empty";
                      _body["harga"] = val.toString();
                    },
                    decoration: InputDecoration(
                      hintText: "Harga",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.code),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Field should not be empty";
                      _body["kode_barang"] = val.toString();
                    },
                    decoration: InputDecoration(
                      hintText: "Kode Barang",
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _addBarang(context);
                          }
                        },
                        child: Text(
                          "Tambah",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Colors.blue,
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

class AddCustomer extends StatelessWidget {
  Map<Object, String> _body = {};
  final formKey1 = new GlobalKey<FormState>();
  void _addCustomer(context) async {
    String url = 'http://10.0.2.2:8000/api/customer';
    Map<String, String> bodies = {
      "nama": "${_body['nama']}",
      "nomor_telepon": "${_body['nomor_telepon']}",
      "alamat": "${_body['alamat']}",
      "total_kunjungan": "1"
    };
    var response = await post(url, body: bodies);

    if (response.statusCode == 201) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Informasi'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text('Pelanggan Berhasil di Tambah')],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Tambah Pelanggan"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey1,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.border_color),
                      title: TextFormField(
                        validator: (val) {
                          if (val.isEmpty) return "Field should not be empty";
                          _body["nama"] = val;
                        },
                        decoration: InputDecoration(
                          hintText: "Nama Pelanggan",
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.label),
                      title: TextFormField(
                        validator: (val) {
                          if (val.isEmpty) return "Field should not be empty";
                          _body["nomor_telepon"] = val;
                        },
                        decoration: InputDecoration(
                          hintText: "Nomor Telp",
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.label),
                      title: TextFormField(
                        validator: (val) {
                          if (val.isEmpty) return "Field should not be empty";
                          _body["alamat"] = val;
                        },
                        decoration: InputDecoration(
                          hintText: "Alamat",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              if (formKey1.currentState.validate()) {
                                // _addCustomer(context);
                              }
                            },
                            child: Text(
                              "Tambah Pelanggan",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddBrand extends StatelessWidget {
  Map<Object, String> _body = {};
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  void _addBrand(context) async {
    String url = 'http://10.0.2.2:8000/api/brand';
    Map<String, String> bodies = {
      "nama": "${_body['nama']}",
      "asal_negara": "${_body['asal_negara']}",
    };
    var response = await post(url, body: bodies);

    if (response.statusCode == 201) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Informasi'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text('Brand Berhasil di Tambah')],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Merek"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.border_color),
                      title: TextFormField(
                        validator: (val) {
                          if (val.isEmpty) return "Field should not be empty";
                          _body["nama"] = val;
                        },
                        decoration: InputDecoration(
                          hintText: "Nama Merek",
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.label),
                      title: TextFormField(
                        validator: (val) {
                          if (val.isEmpty) return "Field should not be empty";
                          _body["asal_negara"] = val;
                        },
                        decoration: InputDecoration(
                          hintText: "Asal Negara",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _addBrand(context);
                              }
                            },
                            child: Text(
                              "Tambah Merek",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeState extends State<Home> {
  List data;
  List brands;
  List items;

  void _fetchData() async {
    String url = 'http://10.0.2.2:8000/api/sale';
    var response = await http.get(url);
    String url1 = 'http://10.0.2.2:8000/api/customer';
    var response1 = await http.get(url1);
    String url2 = 'http://10.0.2.2:8000/api/item';
    var response2 = await http.get(url2);
    String url3 = 'http://10.0.2.2:8000/api/brand';
    var response3 = await http.get(url3);
    String url4 = 'http://10.0.2.2:8000/api/stock';
    var response4 = await http.get(url4);
    data = jsonDecode(response.body)["data"];
    List customers = jsonDecode(response1.body)["data"];
    items = jsonDecode(response2.body)["data"];
    brands = jsonDecode(response3.body)["data"];
    List stocks = jsonDecode(response4.body)["data"];

    for (var i = 0; i < items.length; i++) {
      for (var j = 0; j < brands.length; j++) {
        if (items[i]["brand_id"] == brands[j]["id"]) {
          items[i]["nama"] = brands[j]["nama"];
          items[i]["asal_negara"] = brands[j]["asal_negara"];
        }
      }
      items[i]["list"] = <dynamic>[];
      bool flags = false;
      for (var j = 0; j < stocks.length; j++) {
        if (items[i]["id"] == stocks[j]["item_id"]) {
          for (var k = 0; k < items[i]["list"].length; k++) {
            if (items[i]["list"][k]["ukuran"].toString() ==
                stocks[j]["ukuran"].toString()) {
              flags = true;
            }
          }
          if (!flags) {
            items[i]["list"].add(json.decode(
                '{ "ukuran" : "${stocks[j]['ukuran']}", "jumlah" : "${stocks[j]['jumlah']}"  }'));
            flags = false;
          }
        }
      }
    }
    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < items.length; j++) {
        if (data[i]["item_id"] == items[j]["id"]) {
          data[i]["item_info"] = items[j];
        }
      }
      for (var j = 0; j < customers.length; j++) {
        if (data[i]["customer_id"] == customers[j]["id"]) {
          data[i]["customer_info"] = customers[j];
        }
      }
    }
  }

  void _renderScreen() {
    setState(() {
      _fetchData();
    });
  }

  void initState() {
    super.initState();
    _fetchData();
  }

  int _pageIndex = 0;
  List<String> _titles = ["Penjualan Toko", "Stock Barang"];
  bool _isHistory = true;
  String _title = "Penjualan Toko";
  final List<Widget> headerComponents = [];
  @override
  Widget build(BuildContext context) {
    _fetchData();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          onTap: (int i) {
            setState(() {
              i == 0 ? _isHistory = true : _isHistory = false;
              _title = _titles[i];
              _pageIndex = i;
            });
          },
          tabs: <Widget>[
            Tab(icon: Icon(Icons.history)),
            Tab(icon: Icon(Icons.storage)),
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          _isHistory
              ? IconButton(
                  icon: Icon(
                    Icons.supervised_user_circle,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AddCustomer(),
                      ),
                    );
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AddBrand(),
                      ),
                    );
                  },
                ),
        ],
        backgroundColor: Colors.green,
        title: Text(
          "$_title",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          Transaction(data),
          StockDetail(items),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => _pageIndex == 0
                    ? AddTransaction(_renderScreen)
                    : AddBarang(brands, items)),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
