import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class PhotoTab extends StatefulWidget {
  const PhotoTab({super.key});

  @override
  State<PhotoTab> createState() => _PhotoTabState();
}

class _PhotoTabState extends State<PhotoTab> {
  String? _imageUrl;
  bool _loading = false;
  bool _imageLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  // ⚡ apna cloudinary config
  final String cloudName = "drj4aeuph";
  final String uploadPreset = "my_app";

  @override
  void initState() {
    super.initState();
    _listenImage();
  }

  void _listenImage() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('photos')
        .doc('latest')
        .snapshots()
        .listen((doc) {
          setState(() {
            _imageUrl = doc.data()?['url'] as String?;
            _hasError = false;
            _errorMessage = '';
          });
        });
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 75);
    if (pickedFile == null) return;

    setState(() => _loading = true);

    try {
      final uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      final request = http.MultipartRequest("POST", uri)
        ..fields['upload_preset'] = uploadPreset;

      if (kIsWeb) {
        // ⚡ Web ke liye
        final bytes = await pickedFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: pickedFile.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      } else {
        // ⚡ Mobile ke liye
        request.files.add(
          await http.MultipartFile.fromPath('file', pickedFile.path),
        );
      }

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(resBody);
        final url = data['secure_url'];

        // Add a small delay to let Cloudinary CDN propagate
        await Future.delayed(const Duration(seconds: 1));

        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid == null) throw Exception('Not authenticated');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('photos')
            .doc('latest')
            .set({'url': url, 'uploadedAt': FieldValue.serverTimestamp()});
      } else {
        throw Exception("Cloudinary upload failed: $resBody");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Upload failed: $e';
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildImageWidget() {
    if (_hasError) {
      return Container(
        color: Colors.red[50],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Icon(Icons.error_outline, size: 60, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Upload Failed',
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      _hasError = false;
                      _errorMessage = '';
                      _imageLoading = true;
                    });
                    if (_imageUrl != null) {
                      await NetworkImage(_imageUrl!).evict();
                    }
                    Future.delayed(const Duration(milliseconds: 600), () {
                      if (mounted) {
                        setState(() {
                          _imageLoading = false;
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    }

    if (_imageUrl == null) {
      return Container(
        color: Colors.grey[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No image uploaded yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload a photo to get started',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Show loading overlay if _imageLoading is true
        if (_imageLoading)
          Container(
            color: Colors.grey[100],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF3361c3)),
                  SizedBox(height: 16),
                  Text(
                    'Loading image...',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        else
          Image.network(
            _imageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Container(
                color: Colors.grey[100],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: const Color(0xFF3361c3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading image...',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Container(
                  width: double.infinity,
                  color: Colors.red[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        size: 60,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load image',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please check your internet connection',
                        style: TextStyle(color: Colors.red[500], fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          setState(() {
                            _imageLoading = true;
                          });
                          if (_imageUrl != null) {
                            await NetworkImage(_imageUrl!).evict();
                          }
                          Future.delayed(const Duration(milliseconds: 800), () {
                            if (mounted) {
                              setState(() {
                                _imageLoading = false;
                              });
                            }
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        if (_loading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Photo Tab',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        const SizedBox(height: 60),
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  spreadRadius: 1,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: _buildImageWidget(),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          children: [
            SizedBox(
              width: 120,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  gradient: _loading
                      ? const LinearGradient(
                          colors: [Colors.grey, Colors.grey],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF3361c3), Color(0xffbf4dd6)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: FilledButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                    foregroundColor: MaterialStateProperty.all(
                      _loading ? Colors.grey[400] : Colors.white,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  onPressed: _loading
                      ? null
                      : () => _pickAndUpload(ImageSource.camera),
                  icon: Icon(
                    Icons.photo_camera,
                    color: _loading ? Colors.grey[400] : Colors.white,
                  ),
                  label: Text(
                    'Camera',
                    style: TextStyle(
                      color: _loading ? Colors.grey[400] : Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              width: 120,
              height: 40,
              child: _loading
                  ? OutlinedButton.icon(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                          Colors.grey[400],
                        ),
                        side: MaterialStateProperty.all(
                          BorderSide(color: Colors.grey[400]!),
                        ),
                      ),
                      onPressed: null,
                      icon: Icon(Icons.photo_library, color: Colors.grey[400]),
                      label: Text(
                        'Gallery',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    )
                  : ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF3361c3), Color(0xffbf4dd6)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: OutlinedButton.icon(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          side: MaterialStateProperty.all(
                            const BorderSide(color: Color(0xffbf4dd6)),
                          ),
                        ),
                        onPressed: () => _pickAndUpload(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                      ),
                    ),
            ),
          ],
        ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.only(top: 14),
            child: LinearProgressIndicator(minHeight: 3),
          ),
      ],
    );
  }
}
