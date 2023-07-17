import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tus_client/tus_client.dart';
import 'dart:async';
import 'package:cross_file/cross_file.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'File Upload'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PlatformFile? _pickedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> _uploadFile() async {
    if (_pickedFile != null) {
      XFile file = XFile(_pickedFile!.path!); // Convert PlatformFile to XFile
      var uri = Uri.parse('http://10.0.2.2:1080/files/');
      var client = TusClient(uri, file); // Initialize tus client

      await client.upload(); // Start upload

      print('Upload URL: ${client.uploadUrl}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Pick a file'),
              onPressed: _pickFile,
            ),
            if (_pickedFile != null)
              Text('Selected File: ${_pickedFile!.name}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadFile,
        tooltip: 'Upload',
        child: const Icon(Icons.cloud_upload),
      ),
    );
  }
}

