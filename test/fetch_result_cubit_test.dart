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
  MockFetchResultCubit({super.initialState});

  @override
  FutureResult<String> getResult({required bool param}) => fetchResult(param);
}

class VoidMockFetchResultCubit extends FetchResultCubit<String, void> {
  VoidMockFetchResultCubit();

  @override
  Future<void> fetch({void param}) => super.fetch(param: null);

  @override
  Future<void> refresh({void param}) => super.refresh(param: null);

  @override
  FutureResult<String> getResult({void param}) async =>
      Result.success('success');
}

void main() {
  blocTest<MockFetchResultCubit, FetchResultState<String>>(
    'FetchResultCubit - should emit [loading, loaded]',
    build: MockFetchResultCubit.new,
    act: (cubit) => cubit.fetch(param: false),
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
      initialState: const FetchResultState.loaded('initial data'),
    ),
    act: (cubit) => cubit.refresh(param: false),
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
    build: MockFetchResultCubit.new,
    wait: blocTestWait,
    act: (cubit) {
      cubit
        ..fetch(param: false)
        ..fetch(param: true)
        ..fetch(param: false);
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
      initialState: const FetchResultState.loaded('initial data'),
    ),
    wait: blocTestWait,
    act: (cubit) {
      cubit
        ..refresh(param: false)
        ..refresh(param: true)
        ..refresh(param: false);
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
    build: MockFetchResultCubit.new,
    act: (cubit) => cubit.fetch(param: true),
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
      initialState: const FetchResultState.loaded('initial data'),
    ),
    wait: blocTestWait,
    act: (cubit) => cubit.refresh(param: true),
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

  blocTest<VoidMockFetchResultCubit, FetchResultState<String>>(
    'VoidFetchResultCubit - should emit [loading, loaded] with void param',
    build: VoidMockFetchResultCubit.new,
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

  blocTest<VoidMockFetchResultCubit, FetchResultState<String>>(
    'VoidFetchResultCubit - should emit [refreshing, loaded] with void param',
    build: VoidMockFetchResultCubit.new,
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
}
