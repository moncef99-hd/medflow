import 'package:flutter/foundation.dart';

/// Shared state between Home specialty shortcuts and the Search screen.
class SearchFilter {
  static final ValueNotifier<String?> specialty = ValueNotifier<String?>(null);

  static const List<String> specialtyLabels = [
    'Cardiologue',
    'Dermatologue',
    'Pédiatre',
    'Généraliste',
    'Ophtalmo',
  ];

  /// Lowercase and remove common French accents for matching.
  static String normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ä', 'a')
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ë', 'e')
        .replaceAll('î', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('í', 'i')
        .replaceAll('ô', 'o')
        .replaceAll('ö', 'o')
        .replaceAll('ó', 'o')
        .replaceAll('ù', 'u')
        .replaceAll('û', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c')
        .replaceAll('œ', 'oe')
        .replaceAll('ÿ', 'y');
  }
}
