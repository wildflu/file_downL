

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {

  double? _progress;

  TextEditingController ed = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("DownLoad files"),
        centerTitle: true,
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 50,),
          const Center(child: Text("Post The Link And DownLoad the file")),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: ed,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                )
              ),
            ),
          ),
          _progress != null
          ? CircularProgressIndicator()
          :Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              onPressed: (){
                FileDownloader.downloadFile(
                  url: ed.text.trim(),
                  onProgress: (name, progress) {
                    // print(name);
                    setState(() {
                      _progress = progress;
                    });
                  },
                  onDownloadCompleted: (value) {
                    setState(() {
                      _progress = null;
                    });
                    // Get.snackbar("title", "Image is downLoaded");
                  },
                );
              },
              child: const Text("DownLoad And Read")
            ),
          ),
        ],
      ),
    );
  }
  
}




Future openfile({required String url, String? n}) async{
    print("nnnnnnnnnnnnn");
    final file = await downloadfile(url, n!);
    if(file == null) return ;
    print("${file.path}");

    OpenFile.open(file.path);

  }
  Future<File?> downloadfile(String url, String n) async {
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    final file = File('${appDocumentsDir.path}/$n');
    print('${appDocumentsDir.path}');

    try {

      final respo = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          // receiveTimeout: const Duration(seconds: 5),
        ),
      );

      final ra = file.openSync(mode: FileMode.write);
      ra.writeByteSync(respo.data);
      await ra.close();
      return file;
    }catch (x) {
      print(x);
      return null;
    }
  }