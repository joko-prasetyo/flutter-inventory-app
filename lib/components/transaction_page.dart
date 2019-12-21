import 'package:flutter/material.dart';

class Transaction extends StatefulWidget {
  final data;
  Transaction(this.data);
  @override
  _TransactionState createState() => _TransactionState(data);
}

class _TransactionState extends State<Transaction> {
  List data;
  List data1;
  _TransactionState(data) {
    this.data1 = data;
    this.data = data1.reversed.toList();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
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
                          data[index]["customer_info"]["nama"],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Roboto',
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Merk: ${data[index]["item_info"]["nama"]} (${data[index]["ukuran"]})',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Nota: ${data[index]["nomor_nota"]}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '${data[index]["created_at"]}',
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
                          SizedBox(width: 30,),
                          Text(
                            'Rp. ${data[index]["total_harga"]}',
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
                            '${data[index]["jumlah_barang"]}',
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
