import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper
{
       Future<Database> createDataBase()
      async {
            // Get a location using getDatabasesPath
            var databasesPath = await getDatabasesPath();
            String path = join(databasesPath, 'demo.db');

            print(path);
            print(databasesPath);
            Database database = await openDatabase(path, version: 1,
                onCreate: (Database db, int version) async {
                      // When creating the db, create the table
                      await db.execute(
                          'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT,email TEXT,password TEXT, contact TEXT,hobby TEXT,gender TEXT)');
                });
            return database;
      }
}