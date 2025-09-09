// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:camera/camera.dart';
// import 'package:face_filter/presentation/screens/preview_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class InstaClone extends StatefulWidget {
//   const InstaClone({super.key});

//   @override
//   State<InstaClone> createState() => _InstaCloneState();
// }

// class _InstaCloneState extends State<InstaClone> {
//   CameraController? _controller;
//   List<CameraDescription>? _cameras;
//   bool _isCameraInitialized = false;
//   int _selectedCameraIndex = 0;

//   Color _selectedColor = Colors.transparent;
//   double _intensity = 0.5;

//   final List<Color> _filters = [
//     Colors.transparent, // No filter
//     Colors.blueAccent,
//     Colors.orangeAccent,
//     Colors.purpleAccent,
//     Colors.grey,
//     Colors.greenAccent,
//     Colors.redAccent,
//   ];

//   final GlobalKey _previewKey = GlobalKey();

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera([int cameraIndex = 0]) async {
//     var status = await Permission.camera.request();
//     if (!status.isGranted) {
//       debugPrint("Camera permission denied");
//       return;
//     }

//     _cameras = await availableCameras();
//     if (_cameras!.isNotEmpty) {
//       _controller = CameraController(
//         _cameras![cameraIndex],
//         ResolutionPreset.high,
//         enableAudio: false,
//       );

//       await _controller?.initialize();
//       if (!mounted) return;

//       setState(() {
//         _isCameraInitialized = true;
//         _selectedCameraIndex = cameraIndex;
//       });
//     }
//   }

//   void _switchCamera() {
//     if (_cameras == null || _cameras!.length < 2) return;
//     final newIndex = _selectedCameraIndex == 0 ? 1 : 0;
//     _initializeCamera(newIndex);
//   }
//   Future<void> _captureFilteredImage() async {
//   try {
//     RenderRepaintBoundary boundary = _previewKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//     Uint8List pngBytes = byteData!.buffer.asUint8List();

//     final directory = await getTemporaryDirectory(); // temporary for preview
//     String filePath = '${directory.path}/filtered_${DateTime.now().millisecondsSinceEpoch}.png';
//     File imgFile = File(filePath);
//     await imgFile.writeAsBytes(pngBytes);

//     debugPrint("✅ Captured image at $filePath");

//     if (!mounted) return;
//     // Navigate to preview page
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => PreviewPage(imageFile: imgFile),
//       ),
//     );
//   } catch (e) {
//     debugPrint("Error capturing image: $e");
//   }
// }


//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isCameraInitialized) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Camera + filters inside a RepaintBoundary (for saving)
//           RepaintBoundary(
//             key: _previewKey,
//             child: Positioned.fill(
//               child: Stack(
//                 children: [
//                   if (_controller != null && _controller!.value.isInitialized)
//                     LayoutBuilder(
//                       builder: (context, constraints) {
//                         return SizedBox(
//                           width: constraints.maxWidth,
//                           height: constraints.maxHeight,
//                           child: AspectRatio(
//                             aspectRatio: _controller!.value.aspectRatio,
//                             child: CameraPreview(_controller!),
//                           ),
//                         );
//                       },
//                     ),
//                   if (_selectedColor != Colors.transparent)
//                     Container(
//                       color: _selectedColor.withOpacity(_intensity),
//                     ),
//                 ],
//               ),
//             ),
//           ),

//           // Switch Camera Button
//           Positioned(
//             top: 50,
//             right: 20,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 2),
//                 ],
//               ),
//               child: IconButton(
//                 icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 28),
//                 onPressed: _switchCamera,
//               ),
//             ),
//           ),

//           // Capture Button
//           Positioned(
//             bottom: 110,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: GestureDetector(
//                 onTap: _captureFilteredImage,
//                 child: Container(
//                   width: 85,
//                   height: 85,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: const LinearGradient(
//                       colors: [Colors.pinkAccent, Colors.orangeAccent],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     boxShadow: [
//                       BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 2),
//                     ],
//                   ),
//                   child: const Icon(Icons.camera_alt, color: Colors.white, size: 40),
//                 ),
//               ),
//             ),
//           ),

//           // Filters row (bottom)
//           Positioned(
//             bottom: 20,
//             left: 0,
//             right: 100, // leave space for right-hand slider
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   height: 90,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _filters.length,
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _selectedColor = _filters[index];
//                           });
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.all(8),
//                           width: 65,
//                           height: 65,
//                           decoration: BoxDecoration(
//                             color: _filters[index],
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: _selectedColor == _filters[index]
//                                   ? Colors.white
//                                   : Colors.transparent,
//                               width: 3,
//                             ),
//                             boxShadow: [
//                               BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 2),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Intensity Slider (Right Side)
//           if (_selectedColor != Colors.transparent)
//             Positioned(
//               top: 150,
//               right: 10,
//               bottom: 150,
//               child: RotatedBox(
//                 quarterTurns: 3, // rotate horizontal slider to vertical
//                 child: SliderTheme(
//                   data: SliderTheme.of(context).copyWith(
//                     activeTrackColor: _selectedColor,
//                     inactiveTrackColor: Colors.white30,
//                     thumbColor: Colors.white,
//                     overlayColor: _selectedColor.withOpacity(0.2),
//                     trackHeight: 4,
//                   ),
//                   child: Slider(
//                     value: _intensity,
//                     min: 0.0,
//                     max: 1.0,
//                     divisions: 10,
//                     label: _intensity.toStringAsFixed(1),
//                     onChanged: (value) {
//                       setState(() => _intensity = value);
//                     },
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FaceFilterApp extends StatelessWidget {
  const FaceFilterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Face Filter',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const FaceFilterPage(),
    );
  }
}

class FaceFilterPage extends StatefulWidget {
  const FaceFilterPage({super.key});

  @override
  State<FaceFilterPage> createState() => _FaceFilterPageState();
}

class _FaceFilterPageState extends State<FaceFilterPage>
    with WidgetsBindingObserver {
  late CameraController _cameraController;
  late final FaceDetector _faceDetector;
  List<Face> _faces = [];
  bool _isCameraInitialized = false;
  bool _isDetecting = false;
  Color _selectedColor = Colors.transparent;
  double _intensity = 0.0;

  final List<Color> _colors = [
    Colors.transparent,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.yellow,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Check Android version before initializing camera
    if (_shouldDisableImpeller()) {
      _initializeCamera();
    } else {
      _initializeCameraWithImpellerCheck();
    }
    
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      enableLandmarks: true,
    );
    _faceDetector = FaceDetector(options: options);
  }

  bool _shouldDisableImpeller() {
    if (Platform.isAndroid) {
      try {
        final androidVersion = Platform.version.split('.').first;
        final version = int.tryParse(androidVersion) ?? 0;
        return version >= 33; // Android 13+
      } catch (e) {
        return false; // Assume older version if parsing fails
      }
    }
    return true; // Not Android, no need to disable
  }

  Future<void> _initializeCameraWithImpellerCheck() async {
    debugPrint("Running on Android < 33, camera might have limited functionality");
    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      _shouldDisableImpeller() ? ResolutionPreset.low : ResolutionPreset.low,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    // Add error listener
    _cameraController.addListener(() {
      if (_cameraController.value.hasError) {
        debugPrint("Camera error: ${_cameraController.value.errorDescription}");
      }
    });

    try {
      await _cameraController.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });

      _cameraController.startImageStream(_processCameraImage);
    } catch (e) {
      debugPrint("Camera initialization error: $e");
      
      // Handle Impeller-specific error
      if (e.toString().contains("can't wait on the fence") || 
          e.toString().contains("ImageTextureEntry")) {
        _showImpellerWarning();
      }
    }
  }

  void _showImpellerWarning() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Camera features limited on this device',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _processCameraImage(CameraImage image) {
    if (_isDetecting || !mounted) return;
    _isDetecting = true;

    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      _isDetecting = false;
      return;
    }

    _faceDetector.processImage(inputImage).then((detectedFaces) {
      if (mounted) {
        setState(() {
          _faces = detectedFaces;
        });
      }
    }).catchError((e) {
      debugPrint("Face detection error: $e");
    }).whenComplete(() {
      if (mounted) {
        _isDetecting = false;
      }
    });
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = _cameraController.description;
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else {
      rotation = InputImageRotation.rotation0deg;
    }

    if (rotation == null) return null;

    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: ui.Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.yuv420,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  Future<void> _capturePhoto() async {
    if (!_isCameraInitialized) return;

    final picture = await _cameraController.takePicture();
    
    // Create a new image with the filter applied
    final image = await _applyFilterToImage(picture);

    // Get a temporary path to save the filtered image
    final directory = await getTemporaryDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);

    await file.writeAsBytes(image);

    // Share the filtered photo using share_plus
    await Share.shareXFiles([XFile(file.path)], text: 'Check out my filtered photo!');
  }

  Future<List<int>> _applyFilterToImage(XFile originalImage) async {
    final originalBytes = await originalImage.readAsBytes();
    
    // Use a Completer to handle the async decodeImageFromList
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(originalBytes, (ui.Image image) {
      completer.complete(image);
    });
    
    final originalUiImage = await completer.future;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint();

    canvas.drawImage(originalUiImage, Offset.zero, paint);

    if (_selectedColor != Colors.transparent) {
      paint.color = _selectedColor.withOpacity(_intensity);
      paint.blendMode = BlendMode.color;
      canvas.drawRect(
        Rect.fromLTRB(0, 0, originalUiImage.width.toDouble(), originalUiImage.height.toDouble()),
        paint,
      );
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(originalUiImage.width, originalUiImage.height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Stop camera when app is inactive
      if (_cameraController.value.isStreamingImages) {
        _cameraController.stopImageStream();
      }
    } else if (state == AppLifecycleState.resumed) {
      // Restart camera when app resumes
      if (!_cameraController.value.isStreamingImages && mounted) {
        _cameraController.startImageStream(_processCameraImage);
      }
    }
  }

  @override
  void dispose() {
    // Important: Clean up in correct order
    WidgetsBinding.instance.removeObserver(this);
    
    // Stop image stream first (if it's running)
    if (_cameraController.value.isStreamingImages) {
      try {
        _cameraController.stopImageStream();
      } catch (e) {
        debugPrint("Error stopping image stream: $e");
      }
    }
    
    // Dispose camera controller
    try {
      _cameraController.dispose();
    } catch (e) {
      debugPrint("Error disposing camera: $e");
    }
    
    // Close face detector
    try {
      _faceDetector.close();
    } catch (e) {
      debugPrint("Error closing face detector: $e");
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Camera Preview
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio,
              child: CameraPreview(_cameraController),
            ),
          ),
          // Filter Overlay
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color: _selectedColor.withOpacity(_intensity),
            ),
          ),
          // Face Bounding Boxes
          Positioned.fill(
            child: CustomPaint(
              painter: FaceBoundsPainter(
                faces: _faces,
                imageSize: _cameraController.value.previewSize!,
              ),
            ),
          ),
          
          // UI Controls
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Color Presets
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _colors.map((color) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: color == Colors.transparent ? Colors.grey[700] : color,
                          child: color == Colors.transparent ? const Icon(Icons.close) : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                // Intensity Slider
                Slider(
                  value: _intensity,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (value) {
                    setState(() {
                      _intensity = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                // Capture Button
                FloatingActionButton(
                  onPressed: _capturePhoto,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.camera_alt, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FaceBoundsPainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;

  FaceBoundsPainter({required this.faces, required this.imageSize});

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / imageSize.height;
    final scaleY = size.height / imageSize.width;

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final face in faces) {
      final rect = face.boundingBox;
      final adjustedRect = Rect.fromLTRB(
        rect.left * scaleX,
        rect.top * scaleY,
        rect.right * scaleX,
        rect.bottom * scaleY,
      );
      canvas.drawRect(adjustedRect, paint);
    }
  }

  @override
  bool shouldRepaint(FaceBoundsPainter oldDelegate) {
    return oldDelegate.faces != faces || oldDelegate.imageSize != imageSize;
  }
}