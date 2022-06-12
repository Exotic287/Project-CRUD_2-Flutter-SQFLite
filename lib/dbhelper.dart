import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{
  //fungsi persiapan membuat table
  static  Future<void> createTables(sql.Database database) async {
    await database.execute("""
                              CREATE TABLE anggota(
                                id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                                nama TEXT,
                                alamat TEXT
                              )
                              """);
  }//buat table

  static Future<sql.Database> db()async{
    return sql.openDatabase('perpustakaan.dataBase', version: 1, onCreate: (sql.Database database, int version) async{
      await createTables(database);
    }); //async openDataBase
  }//dataBase


  //tambah data
  static Future<int> tambahData(String nama, String alamat) async {
    final dataBase = await SQLHelper.db();
    final data = {'nama' : nama, 'alamat' : alamat};
    return await dataBase.insert('anggota', data);
  }

  //ambil data
  static Future<List<Map<String, dynamic>>> ambilData() async {
    final dataBase = await SQLHelper.db();
    return dataBase.query('anggota');
  }

  //ubah data
  static Future<int> ubahData(int id, String nama, String alamat) async {
    final dataBase = await SQLHelper.db();
    final data = {'nama' : nama, 'alamat' : alamat};
    return await dataBase.update('anggota', data, where: "id = $id");
  }

  //delete data
  static Future<int> hapusData(int id) async {
    final dataBase = await SQLHelper.db();
    return await dataBase.delete('anggota', where: "id = $id");
  }


}