import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Transaction extends StatefulWidget {
  final data;
  final brands;
  final Function renderScreen;
  Transaction(this.data, this.brands, this.renderScreen);
  @override
  _TransactionState createState() =>
      _TransactionState(data, brands, renderScreen);
}

class _TransactionState extends State<Transaction> {
  List data;
  List data1;
  List brands;
  Function renderScreen;
  _TransactionState(data, brands, renderScreen) {
    this.data1 = data;
    this.brands = brands;
    this.renderScreen = renderScreen;
    this.data = data1.reversed.toList();
  }
  void _deleteTransaction(String id) async {
    var response;
    String url =
        'https://store-inventory-apis.herokuapp.com/sales/${id.toString()}';
    try {
      response = await delete(url);
      if (response.statusCode == 200) {
        return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Informasi'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[Text("Penjualan berhasil di hapus")],
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
                    renderScreen();
                  },
                )
              ],
            );
          },
        );
      }
    } on Exception catch (_) {
      renderScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        for (int i = 0; i < brands.length; i++) {
          if (data[index]["item_id"] != null &&
              data[index]["item_id"]["brand_id"] == brands[i]["_id"]) {
            data[index]["brand_name"] = brands[i]["name"];
            break;
          }
        }
        return Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
            child: Row(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(right: 24.0),
                    child: Icon(Icons.verified_user)),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(right: 13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index]["customer_id"]["name"].toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Roboto',
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Merk: ${data[index]["brand_name"] == null ? '(Not found)' : data[index]["brand_name"]} (${data[index]["item_size"]})',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Nota: ${data[index]["note_number"]}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '${data[index]["createdAt"]}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 30,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            iconSize: 30,
                            onPressed: () {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Informasi'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text("Ingin menghapus penjualan ?")
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'Ya',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _deleteTransaction(
                                              data[index]["_id"]);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text(
                                          'Tidak',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            'Rp. ${data[index]["item_id"] != null ? data[index]["item_id"]["price"] : "None"}',
                            style: TextStyle(
                                fontSize: 17.0,
                                fontFamily: 'Roboto',
                                color: Color(0xFF212121)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Qty:  ',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Roboto',
                                color: Color(0xFF9E9E9E)),
                          ),
                          Text(
                            '${data[index]["item_quantity"]}',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Roboto',
                                color: Color(0xFF9E9E9E)),
                          ),
                        ],
                      ),
                    ]))
              ],
            ),
          ),
        );
      },
    );
  }
}
