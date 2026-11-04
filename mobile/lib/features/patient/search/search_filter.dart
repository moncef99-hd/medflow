import 'package:flutter/foundation.dart';

/// Shared state between Home (specialty chips) and the Recherche tab.
class SearchFilter {
  static final ValueNotifier<String?> specialty = ValueNotifier<String?>(null);

  static const List<String> specialtyLabels = [
    'Cardiologue',
    'Dermatologue',
    'Pédiatre',
    'Généraliste',
    'Ophtalmo',
  ];

  /// Lowercase and remove accents so "pediatre" matches "Pédiatre".
  static String normalize(String input) {
    const from = 'àâäáãçéèêëíìîïñóòôöõúùûüýÿ';
    const to = 'aaaaaceeeeiiiinooooouuuuyy';
    final buffer = StringBuffer();
    for (final ch in input.toLowerCase().split('')) {
      final i = from.indexOf(ch);
      buffer.write(i == -1 ? ch : to[i]);
    }
    return buffer.toString();
  }
}