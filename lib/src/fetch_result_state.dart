import 'package:result_flow/result_flow.dart';

sealed class FetchResultState<T> {
  const FetchResultState();

  const factory FetchResultState.initial() = FetchResultStateInitial<T>;
  const factory FetchResultState.loading() = FetchResultStateLoading<T>;
  const factory FetchResultState.refreshing() = FetchResultStateRefreshing<T>;
  const factory FetchResultState.loaded(T data) = FetchResultStateLoaded<T>;
  const factory FetchResultState.error(ResultError error) =
      FetchResultStateError<T>;

  bool get isLoading => this is FetchResultStateLoading<T>;
  bool get isRefreshing => this is FetchResultStateRefreshing<T>;
  bool get isLoaded => this is FetchResultStateLoaded<T>;
  bool get isError => this is FetchResultStateError<T>;
  bool get isInitial => this is FetchResultStateInitial<T>;
  bool get isLoadingOrRefreshing =>
      this is FetchResultStateLoading<T> ||
      this is FetchResultStateRefreshing<T>;
}

class FetchResultStateInitial<T> extends FetchResultState<T> {
  const FetchResultStateInitial();
}

class FetchResultStateLoading<T> extends FetchResultState<T> {
  const FetchResultStateLoading();
}

class FetchResultStateRefreshing<T> extends FetchResultState<T> {
  const FetchResultStateRefreshing();
}

class FetchResultStateLoaded<T> extends FetchResultState<T> {
  const FetchResultStateLoaded(this.data);
  final T data;
}

class FetchResultStateError<T> extends FetchResultState<T> {
  const FetchResultStateError(this.error);
  final ResultError error;
}
