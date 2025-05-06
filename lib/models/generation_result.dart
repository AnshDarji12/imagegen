class GenerationResult {
  final bool success;
  final String? image;
  final String? modelUsed;
  final String? error;

  GenerationResult({
    required this.success,
    this.image,
    this.modelUsed,
    this.error,
  });

  factory GenerationResult.fromJson(Map<String, dynamic> json) {
    return GenerationResult(
      success: json['success'] ?? false,
      image: json['image'],
      modelUsed: json['model_used'],
      error: json['error'],
    );
  }

  factory GenerationResult.error(String errorMessage) {
    return GenerationResult(success: false, error: errorMessage);
  }
}
