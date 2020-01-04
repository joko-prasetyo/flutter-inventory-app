import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'components/stock.dart';
import 'components/transaction_page.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class AddTransaction extends StatefulWidget {
  final Function renderScreen;
  final items;
  final customers;
  final stocks;
  AddTransaction(this.renderScreen, this.items, this.customers, this.stocks);
  @override
  _AddTransactionState createState() =>
      _AddTransactionState(renderScreen, items, customers, stocks);
}

class _AddTransactionState extends State<AddTransaction> {
  Map<Object, String> _body = {};
  String dropDownItem;
  String dropDownCustomer;
  String dropDownSize;
  final Function renderScreen;
  final List items;
  final List customers;
  List stocksTemp;
  List stocks = [];
  String itemId;

  _AddTransactionState(
      this.renderScreen, this.items, this.customers, this.stocksTemp);
  _addTransactionHandler() async {
    String url = 'https://store-inventory-apis.herokuapp.com/sales';
    var body = jsonEncode({
      "note_number": "${_body['nota'].toString()}",
      "customer_id": "${dropDownCustomer.toString()}",
      "item_id": "${itemId.toString()}",
      "item_size": "${dropDownSize.toString()}",
      "item_quantity": "${_body['jumlah'].toString()}"
    });
    try {
      var response = await post(url, body: body, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      });
      if (response.statusCode == 201) {
        return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Informasi'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[Text("Transaksi telah di tambah")],
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

  void _stocksArrange(String name) {
    stocks = [];
    for (int i = 0; i < items.length; i++) {
      for (int j = 0; j < stocksTemp.length; j++) {
        if (items[i]["brand_id"] != null &&
            items[i]["brand_id"]["name"] == name) {
          if (items[i]["_id"] == stocksTemp[j]["item_id"]) {
            stocks.add(stocksTemp[j]);
          }
        }
      }
    }
    dropDownSize = stocks[0]["size"].toString();
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
                  leading: Icon(Icons.code),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Form should not be empty";
                      _body["nota"] = val;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Nomor Nota",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.local_mall),
                  title: DropdownButton(
                    isExpanded: true,
                    hint: Text('Barang'),
                    value: dropDownItem,
                    onChanged: (newValue) {
                      setState(() {
                        newValue = newValue.split(" ");
                        dropDownItem = newValue[0] + " " + newValue[1];
                        itemId = newValue[0];
                        _stocksArrange(newValue[1]);
                      });
                    },
                    items: items.map((item) {
                      return DropdownMenuItem(
                        child: new Text(item["brand_id"]["name"] +
                            ' (${item["itemCode"]})'),
                        value: item["_id"] + " ${item["brand_id"]["name"]}",
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.face),
                  title: DropdownButton(
                    isExpanded: true,
                    hint: Text('Customer'),
                    value: dropDownCustomer,
                    onChanged: (newValue) {
                      setState(() {
                        dropDownCustomer = newValue;
                      });
                    },
                    items: customers.map((customer) {
                      return DropdownMenuItem(
                        child: new Text(customer["name"]),
                        value: customer["_id"],
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.format_list_numbered),
                  title: DropdownButton(
                    isExpanded: true,
                    hint: Text('Ukuran'),
                    value: dropDownSize,
                    onChanged: (newValue) {
                      setState(() {
                        dropDownSize = newValue;
                      });
                    },
                    items: stocks.map((stock) {
                      return DropdownMenuItem(
                        child: new Text(stock["size"].toString()),
                        value: stock["size"].toString(),
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.plus_one),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Form should not be empty";
                      _body["jumlah"] = val;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Jumlah",
                    ),
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
  final List brands;
  final List items;
  final List suppliers;
  final Function renderScreen;
  AddBarang(this.brands, this.items, this.suppliers, this.renderScreen);
  @override
  _AddBarangState createState() =>
      _AddBarangState(brands, items, suppliers, renderScreen);
}

class _AddBarangState extends State<AddBarang> {
  String dropDownBrand;
  String dropDownSupplier;
  Map<Object, String> _body = {};
  List brands;
  List items;
  List suppliers;
  Function renderScreen;
  _AddBarangState(brands, items, suppliers, renderScreen) {
    this.brands = brands;
    this.items = items;
    this.suppliers = suppliers;
    this.renderScreen = renderScreen;
  }
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  void _addBarang(context) async {
    String url = 'https://store-inventory-apis.herokuapp.com/items';

    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    var body = jsonEncode({
      "itemCode": "${_body['kode_barang']}",
      "brand_id": "${dropDownBrand.toString()}",
      "supplier_id": "${dropDownSupplier.toString()}",
      "price": "${_body['harga']}"
    });

    try {
      var response = await post(url, body: body, headers: headers);

      url = 'https://store-inventory-apis.herokuapp.com/stocks';

      var itemId = jsonDecode(response.body);

      body = jsonEncode({
        "item_id": "${itemId['_id'].toString()}",
        "size": "${_body['ukuran'].toString()}",
        "quantity": "${_body['jumlah'].toString()}"
      });

      var response1 = await post(url, body: body, headers: headers);

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
                    renderScreen();
                    Navigator.of(context).pop();
                  },
                ),
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
                  leading: Icon(Icons.face),
                  title: DropdownButton(
                    isExpanded: true,
                    hint: Text('Pilih Supplier'),
                    value: dropDownSupplier,
                    onChanged: (newValue) {
                      setState(() {
                        dropDownSupplier = newValue;
                      });
                    },
                    items: suppliers.map((supplier) {
                      return DropdownMenuItem(
                        child: new Text(supplier["name"]),
                        value: supplier["_id"],
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.branding_watermark),
                  title: DropdownButton(
                    isExpanded: true,
                    hint: Text('Pilih Merek'),
                    value: dropDownBrand,
                    onChanged: (newValue) {
                      setState(() {
                        dropDownBrand = newValue;
                      });
                    },
                    items: brands.map((brand) {
                      return DropdownMenuItem(
                        child: new Text(brand["name"]),
                        value: brand["_id"],
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.format_size),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Field should not be empty";
                      _body["ukuran"] = val.toString();
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Ukuran",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.plus_one),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Field should not be empty";
                      _body["jumlah"] = val.toString();
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Jumlah",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.monetization_on),
                  title: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "Field should not be empty";
                      _body["harga"] = val.toString();
                      return null;
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
                      return null;
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
  final Function renderScreen;
  AddCustomer(this.renderScreen);
  void _addCustomer(context) async {
    String url = 'https://store-inventory-apis.herokuapp.com/customers/';
    var msg = jsonEncode({
      "name": _body["nama"].toString(),
      "phone_number": _body["nomor_telepon"].toString(),
      "address": _body["alamat"].toString()
    });
    try {
      var response = await post(url, body: msg, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      });
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
                    renderScreen();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Informasi'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[Text('Gagal menambah pelanggan')],
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
                          return null;
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
                          return null;
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
                          return null;
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
                            onPressed: () async {
                              if (formKey1.currentState.validate()) {
                                _addCustomer(context);
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
  final Function renderScreen;
  AddBrand(this.renderScreen);
  void _addBrand(context) async {
    String url = 'https://store-inventory-apis.herokuapp.com/brands';
    var body = jsonEncode({
      "name": "${_body['nama']}",
      "origin": "${_body['asal_negara']}",
    });

    try {
      var response = await post(url, body: body, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      });

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
                    renderScreen();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Informasi'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[Text('Gagal menambah brand')],
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
    } on Exception catch (_) {
      Navigator.of(context).pop();
      renderScreen();
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
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Nama Merek",
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_city),
                      title: TextFormField(
                        validator: (val) {
                          if (val.isEmpty) return "Field should not be empty";
                          _body["asal_negara"] = val;
                          return null;
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
  dynamic data;
  dynamic brands;
  dynamic items;
  dynamic customers;
  dynamic stocks;
  dynamic suppliers;
  bool connection = true;
  void _fetchData() async {
    try {
      String url = 'https://store-inventory-apis.herokuapp.com/sales';
      var response = await http.get(url);
      String brandUrl = 'https://store-inventory-apis.herokuapp.com/brands';
      var response1 = await http.get(brandUrl);
      String itemUrl = 'https://store-inventory-apis.herokuapp.com/items';
      var response2 = await http.get(itemUrl);
      String customerUrl =
          'https://store-inventory-apis.herokuapp.com/customers';
      var response3 = await http.get(customerUrl);
      String stockUrl = 'https://store-inventory-apis.herokuapp.com/stocks';
      var response4 = await http.get(stockUrl);
      String supplierUrl =
          'https://store-inventory-apis.herokuapp.com/suppliers';
      var response5 = await http.get(supplierUrl);

      brands = jsonDecode(response1.body);
      data = jsonDecode(response.body);
      items = jsonDecode(response2.body);
      customers = jsonDecode(response3.body);
      stocks = jsonDecode(response4.body);
      suppliers = jsonDecode(response5.body);

      if (data is Map) {
        setState(() {
          data = [];
        });
      }
      if (brands is Map) {
        setState(() {
          brands = [];
        });
      }
      if (items is Map) {
        setState(() {
          brands = [];
        });
      }
      if (customers is Map) {
        setState(() {
          items = [];
        });
      }
      if (stocks is Map) {
        setState(() {
          stocks = [];
        });
      }
      if (suppliers is Map) {
        setState(() {
          suppliers = [];
        });
      }
      setState(() {});
    } on Exception catch (_) {
      renderScreen();
    }
  }

  void renderScreen() {
    setState(() {
      data = null;
      brands = null;
    });
    _checkConnection();
    // _fetchData();
  }

  void _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connection = true;
        _fetchData();
      }
    } on SocketException catch (_) {
      setState(() {
        connection = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  int _pageIndex = 0;
  List<String> _titles = ["Penjualan Toko", "Stock Barang"];
  bool _isHistory = true;
  String _title = "Penjualan Toko";
  final List<Widget> headerComponents = [];
  @override
  Widget build(BuildContext context) {
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
                        builder: (BuildContext context) =>
                            AddCustomer(renderScreen),
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
                        builder: (BuildContext context) =>
                            AddBrand(renderScreen),
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
          connection
              ? data == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Loading...",
                            style: TextStyle(
                                fontSize: 30,
                                color: Color.fromRGBO(147, 137, 183, 1)),
                          ),
                        ],
                      ),
                    )
                  : data.length == 0
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.shopping_cart,
                                size: 70,
                                color: Colors.green,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Penjualan Kosong",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Transaction(data, brands, renderScreen)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "No Internet Connection",
                        style: TextStyle(fontSize: 30),
                      ),
                      FlatButton(
                        child: Text(
                          'Try again',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        onPressed: () {
                          _checkConnection();
                        },
                      ),
                    ],
                  ),
                ),
          connection
              ? data == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Loading...",
                            style: TextStyle(
                                fontSize: 30,
                                color: Color.fromRGBO(147, 137, 183, 1)),
                          ),
                        ],
                      ),
                    )
                  : StockDetail(items, stocks, renderScreen)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "No Internet Connection",
                        style: TextStyle(fontSize: 30),
                      ),
                      FlatButton(
                        child: Text(
                          'Try again',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        onPressed: () {
                          _checkConnection();
                        },
                      ),
                    ],
                  ),
                ),
        ],
      ),
      floatingActionButton: data != null
          ? FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _pageIndex == 0
                        ? AddTransaction(renderScreen, items, customers, stocks)
                        : AddBarang(brands, items, suppliers, renderScreen),
                  ),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            )
          : Text(''),
    );
  }
}
