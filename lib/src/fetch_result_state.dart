import 'package:result_flow/result_flow.dart';

/// Represents the different states for a fetch operation.
///
/// This is a sealed class, meaning all possible subtypes are defined within
/// this file. It provides factory constructors for each specific state and
/// utility getters to easily check the current state.
///
/// Type parameters:
/// - [T]: The type of the data being fetched.
sealed class FetchResultState<T> {
  /// Abstract const constructor. Allows subclasses to be const.
  const FetchResultState();

  /// Creates an initial state, representing the state before any fetch
  /// operation has started.
  const factory FetchResultState.initial() = FetchResultStateInitial<T>;

  /// Creates a loading state, representing that a fetch operation is currently
  /// in progress.
  const factory FetchResultState.loading() = FetchResultStateLoading<T>;

  /// Creates a refreshing state, representing that a data refresh operation is
  /// currently in progress.
  const factory FetchResultState.refreshing() = FetchResultStateRefreshing<T>;

  /// Creates a loaded state, representing that a fetch operation has completed
  /// successfully and data is available.
  ///
  /// - [data]: The fetched data of type [T].
  const factory FetchResultState.loaded(T data) = FetchResultStateLoaded<T>;

  /// Creates an error state, representing that a fetch operation has failed.
  ///
  /// - [error]: The [ResultError] that occurred during the fetch operation.
  const factory FetchResultState.error(ResultError error) =
      FetchResultStateError<T>;

  /// Returns `true` if the current state is [FetchResultStateLoading].
  bool get isLoading => this is FetchResultStateLoading<T>;

  /// Returns `true` if the current state is [FetchResultStateRefreshing].
  bool get isRefreshing => this is FetchResultStateRefreshing<T>;

  /// Returns `true` if the current state is [FetchResultStateLoaded].
  bool get isLoaded => this is FetchResultStateLoaded<T>;

  /// Returns `true` if the current state is [FetchResultStateError].
  bool get isError => this is FetchResultStateError<T>;

  /// Returns `true` if the current state is [FetchResultStateInitial].
  bool get isInitial => this is FetchResultStateInitial<T>;

  /// Returns `true` if the current state is either [FetchResultStateLoading] or
  /// [FetchResultStateRefreshing].
  bool get isLoadingOrRefreshing =>
      this is FetchResultStateLoading<T> ||
      this is FetchResultStateRefreshing<T>;
}

/// Represents the initial state before any fetch operation has started.
class FetchResultStateInitial<T> extends FetchResultState<T> {
  /// Creates an initial state.
  const FetchResultStateInitial();
}

/// Represents the state where a fetch operation is currently in progress.
class FetchResultStateLoading<T> extends FetchResultState<T> {
  /// Creates a loading state.
  const FetchResultStateLoading();
}

/// Represents the state where a data refresh operation is currently in progress
class FetchResultStateRefreshing<T> extends FetchResultState<T> {
  /// Creates a refreshing state.
  const FetchResultStateRefreshing();
}

/// Represents the state where a fetch operation has completed successfully.
class FetchResultStateLoaded<T> extends FetchResultState<T> {
  /// Creates a loaded state with the fetched [data].
  const FetchResultStateLoaded(this.data);

  /// The successfully fetched data.
  final T data;
}

/// Represents the state where a fetch operation has failed.
class FetchResultStateError<T> extends FetchResultState<T> {
  /// Creates an error state with the [error] that occurred.
  const FetchResultStateError(this.error);

  /// The error that occurred during the fetch operation.
  final ResultError error;
}
