import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fetch_result_bloc/src/fetch_result_event.dart';
import 'package:fetch_result_bloc/src/fetch_result_state.dart';
import 'package:result_flow/result_flow.dart';

abstract class FetchResultBloc<P, T>
    extends Bloc<FetchResultEvent<P>, FetchResultState<T>> {
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

  final EventTransformer<FetchLoadResultEvent<P>>? onLoadTransformer;
  final EventTransformer<FetchRefreshResultEvent<P>>? onRefreshTransformer;

  Future<void> _onLoad(
    FetchLoadResultEvent<P> event,
    Emitter<FetchResultState<T>> emit,
  ) async {
    if (state.isLoadingOrRefreshing) return;
    emit(const FetchResultState.loading());
    final params = event.params;
    return _fetchResult(params, emit);
  }

  Future<void> _onRefresh(
    FetchRefreshResultEvent<P> event,
    Emitter<FetchResultState<T>> emit,
  ) async {
    if (state.isLoadingOrRefreshing) return;
    emit(const FetchResultState.refreshing());
    final params = event.params;
    return _fetchResult(params, emit);
  }

  FutureResult<T> getResult(P params);

  Future<void> _fetchResult(P params, Emitter<FetchResultState<T>> emit) async {
    final result = await getResult(params);
    result.on(
      success: (data) => emit(FetchResultState.loaded(data)),
      error: (error) => emit(FetchResultState.error(error)),
    );
  }
}
