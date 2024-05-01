import 'dart:ui';

class Ingredient {
  final String label;
  final double confidence;
  final Rect boundingBox;

  const Ingredient(this.label, this.confidence, this.boundingBox);

  @override
  String toString() {
    return 'Ingredient{label: $label, confidence: $confidence, boundingBox: $boundingBox}';
  }
}
