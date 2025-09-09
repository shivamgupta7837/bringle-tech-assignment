import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:face_filter/presentation/screens/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ColorFilter extends StatefulWidget {
  const ColorFilter({super.key});

  @override
  State<ColorFilter> createState() => _ColorFilterState();
}

class _ColorFilterState extends State<ColorFilter> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  int _selectedCameraIndex = 0;

  Color _selectedColor = Colors.transparent;
  double _intensity = 0.5;

  final List<Color> _filters = [
    Colors.transparent, // No filter
    Colors.blueAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.grey,
    Colors.greenAccent,
    Colors.redAccent,
  ];

  final GlobalKey _previewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera([int cameraIndex = 0]) async {
    var status = await Permission.camera.request();
    if (!status.isGranted) {
      debugPrint("Camera permission denied");
      return;
    }

    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![cameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller?.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
        _selectedCameraIndex = cameraIndex;
      });
    }
  }

  void _switchCamera() {
    if (_cameras == null || _cameras!.length < 2) return;
    final newIndex = _selectedCameraIndex == 0 ? 1 : 0;
    _initializeCamera(newIndex);
  }
  Future<void> _captureFilteredImage() async {
  try {
    RenderRepaintBoundary boundary = _previewKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final directory = await getTemporaryDirectory(); // temporary for preview
    String filePath = '${directory.path}/filtered_${DateTime.now().millisecondsSinceEpoch}.png';
    File imgFile = File(filePath);
    await imgFile.writeAsBytes(pngBytes);

    debugPrint("✅ Captured image at $filePath");

    if (!mounted) return;
    // Navigate to preview page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreviewPage(imageFile: imgFile),
      ),
    );
  } catch (e) {
    debugPrint("Error capturing image: $e");
  }
}


  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          // Camera + filters inside a RepaintBoundary (for saving)
          RepaintBoundary(
            key: _previewKey,
            child: Positioned.fill(
              child: Stack(
                children: [
                  if (_controller != null && _controller!.value.isInitialized)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: CameraPreview(_controller!),
                          ),
                        );
                      },
                    ),
                  if (_selectedColor != Colors.transparent)
                    Container(
                      color: _selectedColor.withOpacity(_intensity),
                    ),
                ],
              ),
            ),
          ),

          // Switch Camera Button
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 2),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 28),
                onPressed: _switchCamera,
              ),
            ),
          ),

          // Capture Button
          Positioned(
            bottom: 110,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _captureFilteredImage,
                child: Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Colors.pinkAccent, Colors.orangeAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 2),
                    ],
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 40),
                ),
              ),
            ),
          ),

          // Filters row (bottom)
          Positioned(
            bottom: 20,
            left: 0,
            right: 100, // leave space for right-hand slider
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = _filters[index];
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: _filters[index],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == _filters[index]
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 2),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Intensity Slider (Right Side)
          if (_selectedColor != Colors.transparent)
            Positioned(
              top: 150,
              right: 10,
              bottom: 150,
              child: RotatedBox(
                quarterTurns: 3, // rotate horizontal slider to vertical
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: _selectedColor,
                    inactiveTrackColor: Colors.white30,
                    thumbColor: Colors.white,
                    overlayColor: _selectedColor.withOpacity(0.2),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _intensity,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: _intensity.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() => _intensity = value);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
