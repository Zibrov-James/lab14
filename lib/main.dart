import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('laba14_krosp/channel');

  String nativeMessage = "Waiting for native...";
  File? _image;

  Future<void> getNativeMessage() async {
    try {
      final String result = await platform.invokeMethod('getMessage');
      setState(() {
        nativeMessage = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        nativeMessage = "Failed: '${e.message}'.";
      });
    }
  }

  Future<void> takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Native Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: getNativeMessage,
              child: const Text("Get Native Message"),
            ),
            const SizedBox(height: 10),
            Text(nativeMessage, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: takePhoto,
              child: const Text("Take Photo"),
            ),
            const SizedBox(height: 10),
            if (_image != null)
              Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
