import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LaundryDatabase{
  static final LaundryDatabase instance = LaundryDatabase._init();

  static Database? _database;
  LaundryDatabase._init();

  Future<Database> get database async{
      if(_database!=null)
      return _database!;

      _database = await _initDB('laundry.db');
      return _database!;
  }
  Future<Database> _initDB(String filepath) async{
      final dbpath = await getDatabasesPath();
      final path = join(dbpath,filepath);
      return await openDatabase(path, version: 1, onCreate: _createDB);
  }
  Future _createDB(Database db, int version) async{
      await db.execute('''
      CREATE TABLE type(
      type_id INT UNSIGNED NOT NULL PRIMARY KEY,
      price INT UNSIGNED NOT NULL DEFAULT 1000,
      type_name VARCHAR(30) NOT NULL DEFAULT ''
)
''');
      await db.execute('''
      CREATE TABLE customer(
customer_id INT UNSIGNED NOT NULL PRIMARY KEY,
customer_name VARCHAR(15) NOT NULL DEFAULT '',
customer_type VARCHAR(15) NOT NULL DEFAULT 'STUDENT',
number VARCHAR(10) NOT NULL DEFAULT '0000000000',
address VARCHAR(15) NOT NULL DEFAULT 'VYAS'
)
''');
      await db.execute('''
    CREATE TABLE item(
item_id INT UNSIGNED NOT NULL PRIMARY KEY,
customer_id INT UNSIGNED NOT NULL DEFAULT 0,
type_id INT UNSIGNED NOT NULL DEFAULT 0,
FOREIGN KEY (type_id) REFERENCES type(type_id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON UPDATE CASCADE ON DELETE CASCADE
)
''');
      await db.execute('''
    CREATE TABLE laundry_order(
order_id INT UNSIGNED NOT NULL PRIMARY KEY,
customer_id INT UNSIGNED NOT NULL,
order_status INT UNSIGNED NOT NULL DEFAULT 0,
order_date VARCHAR(10) NOT NULL DEFAULT '01-01-2022',
FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON UPDATE CASCADE ON DELETE CASCADE
)
''');
await db.execute('''
   CREATE TABLE contains(
order_id INT UNSIGNED NOT NULL,
item_id INT UNSIGNED NOT NULL,
PRIMARY KEY(order_id,item_id),
FOREIGN KEY (order_id) REFERENCES laundry_order(order_id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (item_id) REFERENCES item(item_id) ON UPDATE CASCADE ON DELETE CASCADE
)
''');
  }
  Future<void> insertData() async{
    final db= await instance.database;
    db.rawInsert('INSERT INTO type VALUES(1,500,\'Upperwear\')');
    db.rawInsert('INSERT INTO type VALUES(2,700,\'Lowerwear\');');
    db.rawInsert('INSERT INTO type VALUES(3,200,\'Underwear\')');
    db.rawInsert('INSERT INTO type VALUES(4,900,\'Woollen\')');

    db.rawInsert('INSERT INTO customer VALUES(1,\'Kshitij\',\'student\',\'1234567890\',\'Vyas\')');
     db.rawInsert('INSERT INTO customer VALUES(2,\'Adarsh\',\'student\',\'1234576890\',\'Vyas\')');
     db.rawInsert('INSERT INTO customer VALUES(3,\'Pratham\',\'student\',\'1224567890\',\'Shankar\')');
      db.rawInsert('INSERT INTO customer VALUES(4,\'Einstein\',\'professor\',\'9999999999\',\'ProfBlocks\')');

    db.rawInsert('INSERT INTO item VALUES(1,1,1);');
    db.rawInsert('INSERT INTO item VALUES(2,1,4);');
    db.rawInsert('INSERT INTO item VALUES(3,2,2);');
   db.rawInsert('INSERT INTO item VALUES(4,2,3);');
   db.rawInsert('INSERT INTO item VALUES(5,3,1);');
    
    db.rawInsert('INSERT INTO laundry_order VALUES(1,1,0,"08-04-2022");');
  db.rawInsert('INSERT INTO laundry_order VALUES(2,2,1,"08-04-2022");');
 db.rawInsert('INSERT INTO laundry_order VALUES(3,3,0,"09-04-2022");');

 db.rawInsert('INSERT INTO contains VALUES(1,1);');
 db.rawInsert('INSERT INTO contains VALUES(1,2);');

 db.rawInsert('INSERT INTO contains VALUES(2,3);');
 db.rawInsert('INSERT INTO contains VALUES(2,4);');
 db.rawInsert('INSERT INTO contains VALUES(3,5);');
 
    
  }
    Future<void> updateStatus(int orderId) async{
    final db= await instance.database;
  await db.rawInsert('UPDATE laundry_order SET order_status=1 WHERE order_id = $orderId;');
  }
  Future<void> addOrder(int customerId,String date, int orderId) async{
    final db= await instance.database;
  // List<Map> id=  await db.rawQuery('SELECT MAX(order_id) FROM laundry_order');
  // print(id.toString());
  await db.rawInsert('INSERT INTO laundry_order VALUES(${orderId},$customerId,0,\'$date\');');
  }
   Future<void> addCustomer() async{
    final db= await instance.database;
  await db.rawInsert('INSERT INTO customer VALUES(5,\'Akshat\',\'student\',\'1212121212\',\'Shankar\');');
  }
  Future<List<Map>> showOrderData() async{
     final db= await instance.database;
    Future<List<Map>> result = db.rawQuery('SELECT * FROM laundry_order');
  //  print(result.first['order_id']);
    return result;
  }
    Future<List<Map>> showCustomerData() async{
     final db= await instance.database;
    Future<List<Map>> result = db.rawQuery('SELECT * FROM customer');
  //  print(result.first['order_id']);
    return result;
  }
  Future<void> updateOrderStatus(int orderId) async{
     final db= await instance.database;
     db.rawUpdate('UPDATE laundry_order SET order_status=1 WHERE order_id = $orderId;');
  }
  Future close() async{
    final db = await instance.database;
    db.close();
  }


}