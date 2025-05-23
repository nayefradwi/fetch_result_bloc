import 'package:bloc_test/bloc_test.dart';
import 'package:fetch_result_bloc/fetch_result_bloc.dart';
import 'package:test/test.dart';

final err = DomainError('mock error', code: 'mock_code');
const wait = Duration(milliseconds: 100);
const blocTestWait = Duration(milliseconds: 200);

FutureResult<String> fetchResult(bool shouldFail) async {
  await Future<void>.delayed(wait);
  if (shouldFail) {
    return Result.error(err);
  }
  return Result.success('success');
}

class MockFetchResultBloc extends FetchResultBloc<bool, String> {
  MockFetchResultBloc({
    super.initialState,
    super.onLoadTransformer,
    super.onRefreshTransformer,
  });

  @override
  FutureResult<String> getResult(bool params) => fetchResult(params);
}

void main() {
  group('FetchResultBloc', () {
    blocTest<MockFetchResultBloc, FetchResultState<String>>(
      'should emit [loading, loaded] when FetchLoadResultEvent is added',
      build: MockFetchResultBloc.new,
      act: (bloc) => bloc.add(const FetchLoadResultEvent(false)),
      wait: blocTestWait,
      expect: () => [
        isA<FetchResultStateLoading<String>>(),
        isA<FetchResultStateLoaded<String>>(),
      ],
      verify: (bloc) {
        expect(bloc.state, isA<FetchResultStateLoaded<String>>());
        final state = bloc.state as FetchResultStateLoaded<String>;
        expect(state.data, 'success');
      },
    );

    blocTest<MockFetchResultBloc, FetchResultState<String>>(
      'should emit [refreshing, loaded] when FetchRefreshResultEvent is added',
      build: () => MockFetchResultBloc(
        initialState: const FetchResultState.loaded('initial data'),
      ),
      act: (bloc) => bloc.add(const FetchRefreshResultEvent(false)),
      wait: blocTestWait,
      expect: () => [
        isA<FetchResultStateRefreshing<String>>(),
        isA<FetchResultStateLoaded<String>>(),
      ],
      verify: (bloc) {
        expect(bloc.state, isA<FetchResultStateLoaded<String>>());
        final state = bloc.state as FetchResultStateLoaded<String>;
        expect(state.data, 'success');
      },
    );

    blocTest<MockFetchResultBloc, FetchResultState<String>>(
      '''
should emit [loading, error] when FetchLoadResultEvent is added and getResult fails''',
      build: MockFetchResultBloc.new,
      act: (bloc) => bloc.add(const FetchLoadResultEvent(true)),
      wait: blocTestWait,
      expect: () => [
        isA<FetchResultStateLoading<String>>(),
        isA<FetchResultStateError<String>>(),
      ],
      verify: (bloc) {
        expect(bloc.state, isA<FetchResultStateError<String>>());
        final state = bloc.state as FetchResultStateError<String>;
        expect(state.error, err);
      },
    );

    blocTest<MockFetchResultBloc, FetchResultState<String>>(
      '''
should emit [refreshing, error] when FetchRefreshResultEvent is added and getResult fails''',
      build: () => MockFetchResultBloc(
        initialState: const FetchResultState.loaded('initial data'),
      ),
      act: (bloc) => bloc.add(const FetchRefreshResultEvent(true)),
      wait: blocTestWait,
      expect: () => [
        isA<FetchResultStateRefreshing<String>>(),
        isA<FetchResultStateError<String>>(),
      ],
      verify: (bloc) {
        expect(bloc.state, isA<FetchResultStateError<String>>());
        final state = bloc.state as FetchResultStateError<String>;
        expect(state.error, err);
      },
    );

    blocTest<MockFetchResultBloc, FetchResultState<String>>(
      '''
should emit [loading, loaded] even after adding FetchLoadResultEvent multiple times''',
      build: MockFetchResultBloc.new,
      act: (bloc) {
        bloc
          ..add(const FetchLoadResultEvent(false))
          ..add(const FetchLoadResultEvent(false))
          ..add(const FetchLoadResultEvent(false));
      },
      wait: blocTestWait,
      expect: () => [
        isA<FetchResultStateLoading<String>>(),
        isA<FetchResultStateLoaded<String>>(),
      ],
      verify: (bloc) {
        expect(bloc.state, isA<FetchResultStateLoaded<String>>());
        final state = bloc.state as FetchResultStateLoaded<String>;
        expect(state.data, 'success');
      },
    );

    blocTest<MockFetchResultBloc, FetchResultState<String>>(
      '''
should emit [refreshing, loaded] even after adding FetchRefreshResultEvent multiple times''',
      build: () => MockFetchResultBloc(
        initialState: const FetchResultState.loaded('initial data'),
      ),
      act: (bloc) {
        bloc
          ..add(const FetchRefreshResultEvent(false))
          ..add(const FetchRefreshResultEvent(false))
          ..add(const FetchRefreshResultEvent(false));
      },
      wait: blocTestWait,
      expect: () => [
        isA<FetchResultStateRefreshing<String>>(),
        isA<FetchResultStateLoaded<String>>(),
      ],
      verify: (bloc) {
        expect(bloc.state, isA<FetchResultStateLoaded<String>>());
        final state = bloc.state as FetchResultStateLoaded<String>;
        expect(state.data, 'success');
      },
    );
  });
}
