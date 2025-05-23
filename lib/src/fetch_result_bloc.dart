import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fetch_result_bloc/src/fetch_result_event.dart';
import 'package:fetch_result_bloc/src/fetch_result_state.dart';
import 'package:result_flow/result_flow.dart';

/// An abstract BLoC (Business Logic Component) for fetching data.
///
/// It handles common states like
/// - initial
/// - loading
/// - refreshing
/// - loaded
/// - error.
/// Extend this class to implement specific data fetching logic by
/// overriding [getResult].
///
/// Type parameters:
/// - [P]: The type of parameters required for fetching the data.
/// - [T]: The type of the data to be fetched.
abstract class FetchResultBloc<P, T>
    extends Bloc<FetchResultEvent<P>, FetchResultState<T>> {
  /// Creates a [FetchResultBloc].
  ///
  /// - [initialState]: The initial state of the BLoC. Defaults to
  ///   [FetchResultState.initial].
  /// - [onLoadTransformer]: An optional [EventTransformer] for
  ///   [FetchLoadResultEvent]. Can be used to customize event processing,
  ///   e.g., using `bloc_concurrency` transformers.
  /// - [onRefreshTransformer]: An optional [EventTransformer] for
  ///   [FetchRefreshResultEvent]. Can be used to customize event processing.
  FetchResultBloc({
    FetchResultState<T>? initialState,
    this.onLoadTransformer,
    this.onRefreshTransformer,
  }) : super(initialState ?? const FetchResultState.initial()) {
    on<FetchLoadResultEvent<P>>(_onLoad, transformer: onLoadTransformer);
    on<FetchRefreshResultEvent<P>>(
      _onRefresh,
      transformer: onRefreshTransformer,
    );
  }

  /// An optional [EventTransformer] to customize the processing
  /// of [FetchLoadResultEvent]s.
  ///
  /// For example, use `droppable()` or `restartable()` from `bloc_concurrency`.
  final EventTransformer<FetchLoadResultEvent<P>>? onLoadTransformer;

  /// An optional [EventTransformer] to customize the processing
  /// of [FetchRefreshResultEvent]s.
  ///
  /// For example, use `droppable()` or `restartable()` from `bloc_concurrency`.
  final EventTransformer<FetchRefreshResultEvent<P>>? onRefreshTransformer;

  /// Handles the [FetchLoadResultEvent] to initiate data fetching.
  ///
  /// Emits a [FetchResultState.loading] state before fetching.
  /// If already loading or refreshing, this method does nothing.
  Future<void> _onLoad(
    FetchLoadResultEvent<P> event,
    Emitter<FetchResultState<T>> emit,
  ) async {
    if (state.isLoadingOrRefreshing) return;
    emit(const FetchResultState.loading());
    final params = event.params;
    return _fetchResult(params, emit);
  }

  /// Handles the [FetchRefreshResultEvent] to initiate data refreshing.
  ///
  /// Emits a [FetchResultState.refreshing] state before fetching.
  /// If already loading or refreshing, this method does nothing.
  Future<void> _onRefresh(
    FetchRefreshResultEvent<P> event,
    Emitter<FetchResultState<T>> emit,
  ) async {
    if (state.isLoadingOrRefreshing) return;
    emit(const FetchResultState.refreshing());
    final params = event.params;
    return _fetchResult(params, emit);
  }

  /// Abstract method to be implemented by subclasses to perform
  /// the actual data fetching.
  ///
  /// - [params]: The parameters required for fetching data.
  /// Returns a [FutureResult] containing either the fetched data [T] or
  /// a [ResultError].
  FutureResult<T> getResult(P params);

  /// Common logic to fetch data using [getResult] and emit corresponding
  /// states.
  ///
  /// - [params]: The parameters for [getResult].
  /// - [emit]: The emitter to output new states.
  Future<void> _fetchResult(P params, Emitter<FetchResultState<T>> emit) async {
    final result = await getResult(params);
    result.on(
      success: (data) => emit(FetchResultState.loaded(data)),
      error: (error) => emit(FetchResultState.error(error)),
    );
  }
}
