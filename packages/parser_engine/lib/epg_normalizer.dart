class EpgNormalizer {
  static final RegExp _cleanPattern = RegExp(
    r'(\b(US|UK|CA|ZA|RAW|4K|FHD|HD|SD|HEVC|H265|BACKUP|VIP)\b|[|\[\]()\-:])',
    caseSensitive: false,
  );

  /// Strips formatting clutter from raw M3U stream channels
  /// Example: "US| HBO FHD RAW [BACKUP]" -> "HBO"
  static String normalizeChannelName(String rawName) {
    String cleaned = rawName.replaceAll(_cleanPattern, ' ');
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    return cleaned.toUpperCase();
  }

  /// Calculates Bigram Similarity ratio between 0.0 and 1.0
  static double similarity(String s1, String s2) {
    String str1 = normalizeChannelName(s1);
    String str2 = normalizeChannelName(s2);

    if (str1 == str2) return 1.0;
    if (str1.isEmpty || str2.isEmpty) return 0.0;

    final pairs1 = _getBigrams(str1);
    final pairs2 = _getBigrams(str2);

    int intersection = 0;
    final total = pairs1.length + pairs2.length;

    for (var pair in pairs1) {
      if (pairs2.contains(pair)) {
        intersection++;
        pairs2.remove(pair);
      }
    }

    return (2.0 * intersection) / total;
  }

  static List<String> _getBigrams(String input) {
    final list = <String>[];
    for (int i = 0; i < input.length - 1; i++) {
      list.add(input.substring(i, i + 2));
    }
    return list;
  }
}
