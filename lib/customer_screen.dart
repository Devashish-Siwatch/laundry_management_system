import 'package:flutter/material.dart';
import 'package:laundry_management_system/laundry_database.dart';
import 'package:laundry_management_system/order_screen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({ Key? key }) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {

  @override
  void initState() {
    // LaundryDatabase.instance.insertData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
       
        title: Text("Customers"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderScreen()));
          }, icon:Icon(Icons.shopping_bag_rounded))
        ],
      ),
      body: Container(child:
          FutureBuilder(
          future: LaundryDatabase.instance.showCustomerData(),
          builder: (context, AsyncSnapshot<List<Map<dynamic, dynamic>>> snapshot){
             if(snapshot.hasData){
               return ListView.builder(
                 itemCount: snapshot.data?.length,
                 itemBuilder: (context, index){
                    return ListTile(
                      onTap: (){
                        LaundryDatabase.instance.addCustomer().then((value) {
                            setState(() {
                          
                        });
                        });
                      
                      },
                leading: Icon(Icons.list),
                trailing: Text("${snapshot.data?[index]['customer_type']}",
                               style: TextStyle(
                                 color: Colors.green,fontSize: 15),),
                title:Text("Customer Id: ${snapshot.data?[index]['customer_id']}   Name: ${snapshot.data?[index]['customer_name']} ")
                );
               });
             }
              return Text("No data available");
          },
          ),
   
              
      ),
        floatingActionButton: FloatingActionButton(
        onPressed: (){
           LaundryDatabase.instance.addCustomer();
                        setState(() {
                          
                        });
        },
        tooltip: 'Add Customer',
        child: const Icon(Icons.add),
      ),
    );
  }
}