import 'package:fetch_result_bloc/fetch_result_bloc.dart';

/// Represents events for fetching or refreshing data in a [FetchResultBloc].
///
/// This is a sealed class, meaning all specific event types are defined as
/// subclasses herein. It holds the parameters required for the fetch operation.
///
/// Type parameters:
/// - [P]: The type of parameters required for the fetch operation.
sealed class FetchResultEvent<P> {
  /// Creates a base fetch result event with the given [params].
  const FetchResultEvent(this.params);

  /// Factory constructor to create an event for an initial data load.
  ///
  /// - [params]: The parameters for the load operation.
  factory FetchResultEvent.load(P params) => FetchLoadResultEvent<P>(params);

  /// Factory constructor to create an event for a data refresh.
  ///
  /// - [params]: The parameters for the refresh operation.
  factory FetchResultEvent.refresh(P params) =>
      FetchRefreshResultEvent<P>(params);

  /// The parameters associated with this fetch event.
  final P params;
}

/// An event indicating a request to load data for the first time.
class FetchLoadResultEvent<P> extends FetchResultEvent<P> {
  /// Creates an event to trigger an initial data load with the given [params].
  const FetchLoadResultEvent(super.params);
}

/// An event indicating a request to refresh already loaded data.
class FetchRefreshResultEvent<P> extends FetchResultEvent<P> {
  /// Creates an event to trigger a data refresh with the given [params].
  const FetchRefreshResultEvent(super.params);
}
