import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;

import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final firstCamera = cameras.first;
  runApp(myApp(
    camera: firstCamera,
  ));
}

class myApp extends StatefulWidget {
  final CameraDescription camera;
  const myApp({super.key, required this.camera});

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  late final CameraController _controller;

  late final Future<void> _initController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = CameraController(widget.camera, ResolutionPreset.high);

    _initController = _controller.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            FutureBuilder<void>(
                future: _initController,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Expanded(
                        child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: CameraPreview(_controller),
                      ),
                    ));
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            IconButton(
                onPressed: () {
                  _takePhoto(context);
                },
                icon: Icon(Icons.camera))
          ],
        ),
      ),
    );
  }

  void _takePhoto(BuildContext context) async {
    await _initController;
    final XFile picture = await _controller.takePicture();

    final dir = await getTemporaryDirectory();
    final name = "dali_${DateTime.now}.png";

    final fullPath = path.join(dir.path, name);
    //await _controller.takePicture(fullPath);
    await picture.saveTo(fullPath);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("picture taken"),
      duration: Duration(milliseconds: 600),
    ));
  }
}
