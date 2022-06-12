import 'package:flutter/material.dart';
import 'dbhelper.dart';
import 'package:flutter/foundation.dart';
import 'dart:ffi';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '20.240.0101 - Tugas 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '20.240.0101 - Tugas 3'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  //ambil data dari database
  List<Map<String, dynamic>> anggota = [];
  void refreshData() async {
    final data = await SQLHelper.ambilData();
    setState(() {
      anggota = data;
    });
  }

  //

  @override
  Widget build(BuildContext context) {
    print(anggota);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: anggota.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text(anggota[index]['nama']),
            subtitle: Text(anggota[index]['alamat']),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => modalForm(anggota[index]['id']),
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () => confHapus(anggota[index]['id']),
                      icon: const Icon(Icons.delete)),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalForm(null);
          //proses
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //fungsi tambah
  Future<Void> tambahDataAnggota() async {
    await SQLHelper.tambahData(namaController.text, alamatController.text);
    refreshData();
  }

  //fungsi ubah
  Future<Void> ubahDataAnggota(int id) async {
    await SQLHelper.ubahData(id, namaController.text, alamatController.text);
    refreshData();
  }

  //fungsi hapus
  Future<Void> hapusDataAnggota(int id) async {
    await SQLHelper.hapusData(id);
    refreshData();
  }

  void confHapus(int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Hapus Data Ini?'),
            actions: <Widget>[
              RaisedButton(
                child: Icon(Icons.cancel),
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
              ),
              RaisedButton(
                child: Icon(Icons.check_circle),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () => hapusDataAnggota(id),
              )
            ],
          );
        });
  }

  //form tambah
  void modalForm(int id) async {
    if (id != null) {
      final dataAnggota = anggota.firstWhere((element) => element['id'] == id);
      namaController.text = dataAnggota['nama'];
      alamatController.text = dataAnggota['alamat'];
    } else {
      namaController.text = '';
      alamatController.text = '';
    }

    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 800,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: namaController,
                      decoration: InputDecoration(
                        hintText: 'Nama',
                        hintStyle: const TextStyle(color: Colors.black),
                        labelText: 'Masukan Nama',
                        labelStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        fillColor: Colors.cyan,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: const BorderSide(color: Colors.cyan)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: const BorderSide(color: Colors.cyanAccent, width: 2.0)),
                        // contentPadding: EdgeInsets.fromLTRB(left, top, right, bottom),
                        contentPadding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: alamatController,
                      decoration: InputDecoration(
                        hintText: 'Alamat',
                        hintStyle: const TextStyle(color: Colors.black),
                        labelText: 'Masukan Alamat',
                        labelStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(
                          Icons.home,
                          color: Colors.black,
                        ),
                        fillColor: Colors.cyan,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: const BorderSide(color: Colors.cyan)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: const BorderSide(color: Colors.cyanAccent, width: 2.0)),
                        // contentPadding: EdgeInsets.fromLTRB(left, top, right, bottom),
                        contentPadding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await tambahDataAnggota();
                        } else {
                          await ubahDataAnggota(id);
                        }
                        namaController.text = '';
                        alamatController.text = '';
                        Navigator.pop(context);
                      },
                      child: Text(id == null ? 'Tambah' : 'Ubah'),
                    )
                  ],
                ),
              ),
            ));
  }
}
