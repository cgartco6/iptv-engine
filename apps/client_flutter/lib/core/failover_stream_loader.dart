import 'dart:async';
import 'package:http/http.dart' as http;

class StreamSource {
  final String id;
  final String url;
  final Map<String, String> headers;

  StreamSource({required this.id, required this.url, required this.headers});
}

class FailoverStreamLoader {
  /// Evaluates and selects the highest-performing operational stream source
  Future<StreamSource?> resolveActiveStream(List<StreamSource> sources) async {
    for (final source in sources) {
      try {
        final request = http.Request('GET', Uri.parse(source.url));
        request.headers.addAll(source.headers);

        final response = await request
            .send()
            .timeout(const Duration(milliseconds: 1500));

        if (response.statusCode >= 200 && response.statusCode < 400) {
          return source;
        }
      } catch (_) {
        // Fallthrough to attempt the next backup stream
        continue;
      }
    }
    return null;
  }
}
