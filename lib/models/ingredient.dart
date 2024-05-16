import 'dart:ui';

class Ingredient {
  final String label;
  final double confidence;
  final Rect boundingBox;

  const Ingredient(this.label, this.confidence, this.boundingBox);

    Ingredient.fromMap(Map<String, dynamic> map)
        : label = map['label'],
          confidence = 100.0,
          boundingBox = Rect.zero;

  @override
  String toString() {
    return 'Ingredient{label: $label, confidence: $confidence, boundingBox: $boundingBox}';
  }
}
