import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:udaya_visitor/data/api/visitor_api.dart';
import 'package:udaya_visitor/data/models/visitor_list_filter_request.dart';
import 'package:udaya_visitor/data/models/visitor_model.dart';
import 'package:udaya_visitor/data/repositories/visitor_repository.dart';

class MockVisitorApi extends Mock implements VisitorApi {}

void main() {
  late VisitorRepository repository;
  late MockVisitorApi mockApi;

  setUp(() {
    mockApi = MockVisitorApi();
    repository = VisitorRepository(api: mockApi);
  });

  final testVisitor = VisitorModel(
    id: '1',
    name: 'Jonathan Simmons',
    startTime: DateTime(2025, 5, 10, 9, 30),
    endTime: DateTime(2025, 5, 10, 11, 30),
    room: 'HOGF',
    purpose: 'Meeting',
  );

  group('VisitorRepository Tests', () {
    test('getVisitors returns list of VisitorModel on success', () async {
      const filter = VisitorListFilterRequest();
      when(() => mockApi.getList(filter))
          .thenAnswer((_) async => [testVisitor]);

      final result = await repository.getVisitors(filter);

      expect(result, equals([testVisitor]));
      verify(() => mockApi.getList(filter)).called(1);
    });

    test('addVisitor returns created VisitorModel on success', () async {
      when(() => mockApi.addVisitor(testVisitor.toJson()))
          .thenAnswer((_) async => testVisitor);

      final result = await repository.addVisitor(testVisitor);

      expect(result, equals(testVisitor));
      verify(() => mockApi.addVisitor(testVisitor.toJson())).called(1);
    });

    test('checkIn returns updated VisitorModel on success', () async {
      when(() => mockApi.checkIn('1')).thenAnswer((_) async => testVisitor);

      final result = await repository.checkIn('1');

      expect(result, equals(testVisitor));
      verify(() => mockApi.checkIn('1')).called(1);
    });

    test('handles DioException 401 gracefully', () async {
      const filter = VisitorListFilterRequest();
      when(() => mockApi.getList(filter)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/visitor/list'),
          response: Response(
            requestOptions: RequestOptions(path: '/visitor/list'),
            statusCode: 401,
          ),
        ),
      );

      expect(
        () async => await repository.getVisitors(filter),
        throwsA(isA<VisitorException>()
            .having((e) => e.statusCode, 'statusCode', 401)),
      );
    });
  });
}
