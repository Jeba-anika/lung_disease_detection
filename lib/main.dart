import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

void main() {
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
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PlatformFile>? _files;
  String stringResponse = "";

  void _uploadFile(List<PlatformFile>? files) async {
    var uri = Uri.parse('http://10.0.2.2:5000/');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath(
        'file', _files!.first.path.toString()));
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Uploaded ...');
    } else {
      print('Something went wrong!');
    }
    _apiCall();
  }

  void _getFile() async {
    _files = (await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    ))!
        .files;

    print('Loaded file path is : ${_files!.first.path}');
    _uploadFile(_files);
  }

  Future _apiCall() async {
    http.Response response;
    response = await http.get(Uri.parse('http://10.0.2.2:5000/'));
    if (response.statusCode == 200) {
      setState(() {
        stringResponse = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: _getFile, child: Text("upload")),
            //ElevatedButton(
            // onPressed: _apiCall,
            //child: Text(
            // "get result",
            //)),
            Text(stringResponse),
          ],
        ),
      ),
    );
  }
}
