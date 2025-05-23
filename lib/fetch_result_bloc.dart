/// A Dart package providing abstract BLoC and Cubit components for simplifying
/// common data fetching and state management patterns.
///
/// This library offers base classes ([FetchResultBloc], [FetchResultCubit])
/// that handle typical states (initial, loading, refreshing, loaded, error)
/// and events, allowing developers to focus on the specific data retrieval
/// logic. It also includes helper classes for events ([FetchResultEvent]),
/// states ([FetchResultState]), and error customization
/// ([FetchResultErrorOptions]).
library;

import 'package:fetch_result_bloc/fetch_result_bloc.dart';

export 'package:result_flow/result_flow.dart';

export 'src/errors.dart';
export 'src/fetch_result_bloc.dart';
export 'src/fetch_result_cubit.dart';
export 'src/fetch_result_event.dart';
export 'src/fetch_result_state.dart';
