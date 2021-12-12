import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) {
    doo();
  }
  doo() async {}

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var token;
  String? reportid;

  Future login() async {
    var url = Uri.parse('');
    var response = await http.post(url,
        body: {'national_id': '8796352879', 'user_password': '12345678'});
    var responsebody = json.decode(response.body);
    print(responsebody);
    token = responsebody['data'];
    print(token);
  }

  Future<File> loadPdf() async {
    Uri url = Uri.parse('pdf download url');
    final respons = await http.get(url);
    final bytes = respons.bodyBytes;
    return _storefile(url, bytes);
  }

  Future<File> _storefile(Uri url, List<int> bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$reportid');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future getUserData() async {
    var url = Uri.parse('');
    var response = await http.post(url, body: {
      'access_token':
          'CqNaUfeZL819zvHArBg58EDvn5dvFWtfFfmQ7oNpKCHQ521yTC1BhmIBcNYvJKYP'
    });

    var responsebody = json.decode(response.body);
    print(responsebody);
    reportid = responsebody['data']['report_id'];
    print(responsebody['data']['dose_date']);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  login();
                },
                child: Text("login")),
            ElevatedButton(
                onPressed: () {
                  getUserData();
                },
                child: Text("Getdata")),
            ElevatedButton(
                onPressed: () async {
                  final file = await loadPdf();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfPage(file: file),
                      ));
                },
                child: Text("get report")),
          ],
        ),
      ),
    );
  }
}

class PdfPage extends StatefulWidget {
  PdfPage({Key? key, required this.file}) : super(key: key);
  File file;

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("report"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xff00A7D221),
              Color(0xff48CDCFE9),
              Color(0xff5DBDD4F7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          )),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await ShareExtend.share(widget.file.path, 'file');
              },
              icon: Icon(Icons.share))
        ],
      ),
      body: PDFView(
        filePath: widget.file.path,
      ),
    );
  }
}
