import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:udaya_visitor/data/models/visitor_list_filter_request.dart';
import 'package:udaya_visitor/data/models/visitor_model.dart';
import 'package:udaya_visitor/data/repositories/visitor_repository.dart';
import 'package:udaya_visitor/logic/bloc/visitor_list/visitor_list_bloc.dart';
import 'package:udaya_visitor/logic/bloc/visitor_list/visitor_list_event.dart';
import 'package:udaya_visitor/logic/bloc/visitor_list/visitor_list_state.dart';

class MockVisitorRepository extends Mock implements VisitorRepository {}

void main() {
  late MockVisitorRepository mockRepo;

  setUp(() {
    mockRepo = MockVisitorRepository();
  });

  final testVisitor = VisitorModel(
    id: '1',
    name: 'Jonathan Simmons',
    startTime: DateTime(2025, 5, 10, 9, 30),
    endTime: DateTime(2025, 5, 10, 11, 30),
    room: 'HOGF',
    purpose: 'Meeting',
  );

  group('VisitorListBloc Tests', () {
    blocTest<VisitorListBloc, VisitorListState>(
      'emits [VisitorListLoading, VisitorListSuccess] when FetchVisitorListEvent succeeds',
      build: () {
        when(() => mockRepo.getVisitors(const VisitorListFilterRequest()))
            .thenAnswer((_) async => [testVisitor]);
        return VisitorListBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const FetchVisitorListEvent()),
      expect: () => [
        VisitorListLoading(),
        VisitorListSuccess(
          visitors: [testVisitor],
          filter: const VisitorListFilterRequest(),
          hasMore: false,
        ),
      ],
    );

    blocTest<VisitorListBloc, VisitorListState>(
      'emits [VisitorListLoading, VisitorListFailure] when FetchVisitorListEvent throws Exception',
      build: () {
        when(() => mockRepo.getVisitors(const VisitorListFilterRequest()))
            .thenThrow(const VisitorException('Server error', statusCode: 500));
        return VisitorListBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const FetchVisitorListEvent()),
      expect: () => [
        VisitorListLoading(),
        isA<VisitorListFailure>()
            .having((s) => s.error, 'error', contains('Server error')),
      ],
    );
  });
}
