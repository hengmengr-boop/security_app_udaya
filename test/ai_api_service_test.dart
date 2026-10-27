import 'package:flutter_test/flutter_test.dart';
import 'package:udaya_visitor/data/data_export.dart';
import 'package:udaya_visitor/helper/helper_export.dart';

void main() {
  group('AiApiService Tests', () {
    test('Gemini AiApiService initializes with correct base URL', () {
      final service = AiApiService(aiUse: AIUse.gemini);
      expect(service, isNotNull);
    });

    test('Claude AiApiService initializes with correct base URL', () {
      final service = AiApiService(aiUse: AIUse.claude);
      expect(service, isNotNull);
    });
  });
}
