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

class MockFetchResultCubit extends FetchResultCubit<String, bool> {
  MockFetchResultCubit({super.initialState, super.params});

  @override
  FutureResult<String> getResult(bool params) => fetchResult(params);
}

void main() {
  blocTest<MockFetchResultCubit, FetchResultState<String>>(
    'FetchResultCubit - should emit [loading, loaded]',
    build: () => MockFetchResultCubit(params: false),
    act: (cubit) => cubit.fetch(),
    wait: blocTestWait,
    expect: () => [
      isA<FetchResultStateLoading<String>>(),
      isA<FetchResultStateLoaded<String>>(),
    ],
    verify: (cubit) {
      expect(cubit.state, isA<FetchResultStateLoaded<String>>());
      final state = cubit.state as FetchResultStateLoaded<String>;
      expect(state.data, 'success');
    },
  );

  blocTest<MockFetchResultCubit, FetchResultState<String>>(
    'FetchResultCubit - should emit [loading, loaded] with override params',
    build: () => MockFetchResultCubit(params: true),
    act: (cubit) => cubit.fetch(params: false),
    wait: blocTestWait,
    expect: () => [
      isA<FetchResultStateLoading<String>>(),
      isA<FetchResultStateLoaded<String>>(),
    ],
    verify: (cubit) {
      expect(cubit.state, isA<FetchResultStateLoaded<String>>());
      final state = cubit.state as FetchResultStateLoaded<String>;
      expect(state.data, 'success');
    },
  );

  blocTest<MockFetchResultCubit, FetchResultState<String>>(
    'FetchResultCubit - should emit [refreshing, loaded]',
    build: () => MockFetchResultCubit(
      params: false,
      initialState: const FetchResultState.loaded('initial data'),
    ),
    act: (cubit) => cubit.refresh(),
    wait: blocTestWait,
    expect: () => [
      isA<FetchResultStateRefreshing<String>>(),
      isA<FetchResultStateLoaded<String>>(),
    ],
    verify: (cubit) {
      expect(cubit.state, isA<FetchResultStateLoaded<String>>());
      final state = cubit.state as FetchResultStateLoaded<String>;
      expect(state.data, 'success');
    },
  );

  blocTest<MockFetchResultCubit, FetchResultState<String>>(
    '''FetchResultCubit - should emit [loading, loaded] even after calling multiple times''',
    build: () => MockFetchResultCubit(params: false),
    wait: blocTestWait,
    act: (cubit) {
      cubit
        ..fetch()
        ..fetch()
        ..fetch();
    },
    expect: () => [
      isA<FetchResultStateLoading<String>>(),
      isA<FetchResultStateLoaded<String>>(),
    ],
    verify: (cubit) {
      expect(cubit.state, isA<FetchResultStateLoaded<String>>());
      final state = cubit.state as FetchResultStateLoaded<String>;
      expect(state.data, 'success');
    },
  );

  blocTest<MockFetchResultCubit, FetchResultState<String>>(
    '''FetchResultCubit - should emit [refreshing, loaded] even after calling multiple times''',
    build: () => MockFetchResultCubit(
      params: false,
      initialState: const FetchResultState.loaded('initial data'),
    ),
    wait: blocTestWait,
    act: (cubit) {
      cubit
        ..refresh()
        ..refresh()
        ..refresh();
    },
    expect: () => [
      isA<FetchResultStateRefreshing<String>>(),
      isA<FetchResultStateLoaded<String>>(),
    ],
    verify: (cubit) {
      expect(cubit.state, isA<FetchResultStateLoaded<String>>());
      final state = cubit.state as FetchResultStateLoaded<String>;
      expect(state.data, 'success');
    },
  );

  blocTest<MockFetchResultCubit, FetchResultState<String>>(
    'FetchResultCubit - should emit [loading, error] when fetch fails',
    build: () => MockFetchResultCubit(params: true),
    act: (cubit) => cubit.fetch(),
    wait: blocTestWait,
    expect: () => [
      isA<FetchResultStateLoading<String>>(),
      isA<FetchResultStateError<String>>(),
    ],
    verify: (cubit) {
      expect(cubit.state, isA<FetchResultStateError<String>>());
      final state = cubit.state as FetchResultStateError<String>;
      expect(state.error, err);
    },
  );

  blocTest<MockFetchResultCubit, FetchResultState<String>>(
    'FetchResultCubit - should emit [refreshing, error] when refresh fails',
    build: () => MockFetchResultCubit(
      params: true,
      initialState: const FetchResultState.loaded('initial data'),
    ),
    wait: blocTestWait,
    act: (cubit) => cubit.refresh(),
    expect: () => [
      isA<FetchResultStateRefreshing<String>>(),
      isA<FetchResultStateError<String>>(),
    ],
    verify: (cubit) {
      expect(cubit.state, isA<FetchResultStateError<String>>());
      final state = cubit.state as FetchResultStateError<String>;
      expect(state.error, err);
    },
  );

  blocTest<MockFetchResultCubit, FetchResultState<String>>(
    '''FetchResultCubit - should emit [loading, error] when fetch fails with null params''',
    build: MockFetchResultCubit.new,
    act: (cubit) => cubit.fetch(),
    wait: blocTestWait,
    expect: () => [isA<FetchResultStateError<String>>()],
    verify: (cubit) {
      expect(cubit.state, isA<FetchResultStateError<String>>());
      final state = cubit.state as FetchResultStateError<String>;
      expect(
        state.error.message,
        FetchResultErrorOptions.cannotFetchWithNullParams.message,
      );
      expect(
        state.error.code,
        FetchResultErrorOptions.cannotFetchWithNullParams.code,
      );
    },
  );
}
