import 'package:bloc/bloc.dart';
import 'package:fetch_result_bloc/src/errors.dart';
import 'package:fetch_result_bloc/src/fetch_result_state.dart';
import 'package:result_flow/result_flow.dart';

abstract class FetchResultCubit<T, P> extends Cubit<FetchResultState<T>> {
  FetchResultCubit({FetchResultState<T>? initialState, this.params})
    : super(initialState ?? const FetchResultState.initial());
  final P? params;

  FutureResult<T> getResult({P? params});

  Future<void> fetch({P? params}) async {
    params ??= this.params;
    if (params == null) {
      final err = FetchResultErrorOptions.cannotFetchWithNullParams;
      return emit(FetchResultState.error(err));
    }

    emit(const FetchResultState.loading());
    return _fetchResult();
  }

  Future<void> refresh({P? params}) async {
    params ??= this.params;
    if (params == null) {
      final err = FetchResultErrorOptions.cannotFetchWithNullParams;
      return emit(FetchResultState.error(err));
    }

    emit(const FetchResultState.refreshing());
    return _fetchResult();
  }

  Future<void> _fetchResult() async {
    if (state.isLoadingOrRefreshing) return;
    final result = await getResult(params: params);
    result.on(
      success: (data) => emit(FetchResultState.loaded(data)),
      error: (error) => emit(FetchResultState.error(error)),
    );
  }
}
