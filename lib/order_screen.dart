import 'package:flutter/material.dart';
import 'package:laundry_management_system/customer_screen.dart';
import 'package:laundry_management_system/laundry_database.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({ Key? key }) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
final tc = TextEditingController();
final tc2 = TextEditingController();
String? customerId, orderId;
  @override
  void initState() {
    // LaundryDatabase.instance.insertData();
    super.initState();
  }
   Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Order Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      orderId = value;
                    });
                  },
                  controller: tc,
                  decoration: InputDecoration(hintText: "Enter Order Id"),
                ),
                 TextField(
                  onChanged: (value) {
                    setState(() {
                      customerId = value;
                    });
                  },
                  controller: tc2,
                  decoration: InputDecoration(hintText: "Enter Customer Id"),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    DateTime now = new DateTime.now();
                    DateTime date = new DateTime(now.year, now.month, now.day);
                      LaundryDatabase.instance.addOrder(int.parse(customerId!),date.toString().split(' ').first, int.parse(orderId!));
                        setState(() {
                          
                        });
                  });
                },
              ),
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
   
        title: Text("Orders"),
         actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerScreen()));
          }, icon:Icon(Icons.person))
        ],
      ),
      body: Container(child: 
          FutureBuilder(
          future: LaundryDatabase.instance.showOrderData(),
          builder: (context, AsyncSnapshot<List<Map<dynamic, dynamic>>> snapshot){
             if(snapshot.hasData){
               return ListView.builder(
                 itemCount: snapshot.data?.length,
                 itemBuilder: (context, index){
                    return ListTile(
                      onTap: (){
                         LaundryDatabase.instance.updateOrderStatus(snapshot.data?[index]['order_id']);
                        setState(() {
                          
                        });
                      },
                leading: (snapshot.data?[index]['order_status']==1)?Icon(Icons.check,
                color: Colors.green,):Icon(Icons.watch_outlined,color: Colors.amber,),
                trailing: Text("${snapshot.data?[index]['order_date']}",
                               style: TextStyle(
                                 color: Colors.green,fontSize: 15),),
                title:Text("Order Id: ${snapshot.data?[index]['order_id']}   Customer id: ${snapshot.data?[index]['customer_id']} ")
                );
               });
             }
              return Text("No data available");
          },
          ),
      
              
     
      ),
         floatingActionButton: FloatingActionButton(
        onPressed: (){
           _displayTextInputDialog(context);
          //  LaundryDatabase.instance.addOrder();
          //               setState(() {
                          
          //               });
        },
        tooltip: 'Add Order',
        child: const Icon(Icons.add),
      ),
    );
  }
}