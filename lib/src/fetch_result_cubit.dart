import 'package:bloc/bloc.dart';
import 'package:fetch_result_bloc/src/errors.dart';
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
  /// - [params]: Optional default parameters to be used for fetch/refresh
  ///   operations if no specific parameters are provided to those methods.
  FetchResultCubit({FetchResultState<T>? initialState, this.params})
    : super(initialState ?? const FetchResultState.initial());

  /// Optional default parameters for fetch operations.
  ///
  /// If provided during construction, these parameters will be used by [fetch]
  /// and [refresh] if no parameters are explicitly passed to those methods.
  final P? params;

  /// Abstract method to be implemented by subclasses to perform the actual
  /// data fetching.
  ///
  /// - [params]: The parameters required for fetching data.
  /// Returns a [FutureResult] containing either the fetched data [T] or a
  /// [ResultError].
  FutureResult<T> getResult(P params);

  /// Initiates a fetch operation.
  ///
  /// Emits [FetchResultState.loading] before fetching.
  /// If [params] are not provided to this method, it uses the [this.params]
  /// (if available).
  /// If no parameters are available (neither passed nor stored), it emits
  /// [FetchResultState.error] with
  /// [FetchResultErrorOptions.cannotFetchWithNullParams].
  /// If the cubit is already in a loading or refreshing state, this method
  /// does nothing.
  Future<void> fetch({P? params}) async {
    params ??= this.params;
    if (params == null) {
      final err = FetchResultErrorOptions.cannotFetchWithNullParams;
      return emit(FetchResultState.error(err));
    }

    if (state.isLoadingOrRefreshing) return;
    emit(const FetchResultState.loading());
    return _fetchResult(params);
  }

  /// Initiates a refresh operation.
  ///
  /// Emits [FetchResultState.refreshing] before fetching.
  /// If [params] are not provided to this method, it uses the [this.params]
  /// (if available).
  /// If no parameters are available (neither passed nor stored), it emits
  /// [FetchResultState.error] with
  /// [FetchResultErrorOptions.cannotFetchWithNullParams].
  /// If the cubit is already in a loading or refreshing state, this method
  /// does nothing.
  Future<void> refresh({P? params}) async {
    params ??= this.params;
    if (params == null) {
      final err = FetchResultErrorOptions.cannotFetchWithNullParams;
      return emit(FetchResultState.error(err));
    }

    if (state.isLoadingOrRefreshing) return;
    emit(const FetchResultState.refreshing());
    return _fetchResult(params);
  }

  /// Common logic to fetch data using [getResult] and emit corresponding
  /// states.
  ///
  /// - [params]: The parameters for [getResult].
  Future<void> _fetchResult(P params) async {
    final result = await getResult(params);
    result.on(
      success: (data) => emit(FetchResultState.loaded(data)),
      error: (error) => emit(FetchResultState.error(error)),
    );
  }
}
