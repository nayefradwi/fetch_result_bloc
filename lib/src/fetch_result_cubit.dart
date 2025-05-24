import 'package:bloc/bloc.dart';
import 'package:fetch_result_bloc/src/fetch_result_state.dart';
import 'package:result_flow/result_flow.dart';

/// An abstract Cubit for fetching data, managing common states.
///
/// Handles states like initial, loading, refreshing, loaded, and error.
/// Extend this class to implement specific data fetching logic by overriding
/// [getResult].
///
/// Type parameters:
/// - [T]: The type of the data to be fetched.
/// - [P]: The type of parameters required for fetching the data.
abstract class FetchResultCubit<T, P> extends Cubit<FetchResultState<T>> {
  /// Creates a [FetchResultCubit].
  ///
  /// - [initialState]: The initial state of the Cubit. Defaults to
  ///   [FetchResultState.initial].

  FetchResultCubit({FetchResultState<T>? initialState})
    : super(initialState ?? const FetchResultState.initial());

  /// Abstract method to be implemented by subclasses to perform the actual
  /// data fetching.
  ///
  /// - [param]: The parameters required for fetching data.
  /// Returns a [FutureResult] containing either the fetched data [T] or a
  /// [ResultError].
  FutureResult<T> getResult({required P param});

  /// Initiates a fetch operation.
  ///
  /// Emits [FetchResultState.loading] before fetching.
  /// If the cubit is already in a loading or refreshing state, this method
  /// does nothing.
  Future<void> fetch({required P param}) async {
    if (state.isLoadingOrRefreshing) return;
    emit(const FetchResultState.loading());
    return _fetchResult(param);
  }

  /// Initiates a refresh operation.
  ///
  /// Emits [FetchResultState.refreshing] before fetching.
  /// If the cubit is already in a loading or refreshing state, this method
  /// does nothing.
  Future<void> refresh({required P param}) async {
    if (state.isLoadingOrRefreshing) return;
    emit(const FetchResultState.refreshing());
    return _fetchResult(param);
  }

  /// Common logic to fetch data using [getResult] and emit corresponding
  /// states.
  ///
  /// - [param]: The parameters for [getResult].
  Future<void> _fetchResult(P param) async {
    final result = await getResult(param: param);
    result.on(
      success: (data) => emit(FetchResultState.loaded(data)),
      error: (error) => emit(FetchResultState.error(error)),
    );
  }
}
