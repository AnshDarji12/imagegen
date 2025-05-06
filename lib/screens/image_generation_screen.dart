import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/generation_result.dart';

class ImageGenerationScreen extends StatefulWidget {
  const ImageGenerationScreen({Key? key}) : super(key: key);

  @override
  _ImageGenerationScreenState createState() => _ImageGenerationScreenState();
}

class _ImageGenerationScreenState extends State<ImageGenerationScreen> {
  final TextEditingController _promptController = TextEditingController();
  String? _selectedModel = 'stable_diffusion_v1_5';
  bool _isLoading = false;
  String? _generatedImage;
  String? _error;

  final List<String> _models = [
    'stable_diffusion_v1_5',
    'openjourney',
    'dreamshaper',
    'dreamlike_photoreal',
    'waifu_diffusion',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Generator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'Enter your prompt',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedModel,
              decoration: const InputDecoration(
                labelText: 'Select Model',
                border: OutlineInputBorder(),
              ),
              items:
                  _models.map((String model) {
                    return DropdownMenuItem(value: model, child: Text(model));
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedModel = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _generateImage,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Generate Image'),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_generatedImage != null)
              Image.memory(base64Decode(_generatedImage!), fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }

  Future<void> _generateImage() async {
    if (_promptController.text.isEmpty) {
      setState(() {
        _error = 'Please enter a prompt';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _generatedImage = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final result = await apiService.generateImage(
        _promptController.text,
        _selectedModel!,
      );

      setState(() {
        _isLoading = false;
        if (result.success && result.image != null) {
          _generatedImage = result.image;
          _error = null;
        } else {
          _error = result.error ?? 'Failed to generate image';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error: $e';
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }
}
