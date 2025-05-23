import 'package:result_flow/result_flow.dart';

/// A class to manage customizable error messages and codes
/// for fetch operations.
///
/// This allows for centralized configuration of error details, particularly for
/// scenarios like attempting a fetch operation with null parameters.
class FetchResultErrorOptions {
  /// Private constructor to initialize error message and code options.
  ///
  /// - [nullParamsMessage]: The error message for null parameters.
  ///   Defaults to 'Cannot fetch with null params'.
  /// - [nullParamsCode]: The error code for null parameters.
  ///   Defaults to 'fetch_with_null_params'.
  FetchResultErrorOptions._({
    this.nullParamsMessage = 'Cannot fetch with null params',
    this.nullParamsCode = 'fetch_with_null_params',
  });

  /// The singleton instance of [FetchResultErrorOptions],
  /// holding the current error configuration.
  static FetchResultErrorOptions _instance = FetchResultErrorOptions._();

  /// Replaces the default error messages and codes with new values.
  ///
  /// If a parameter is not provided, its current value is retained.
  /// - [nullParamsMessage]: The new error message for null parameters.
  /// - [nullParamsCode]: The new error code for null parameters.
  static void replaceDefaults({
    String? nullParamsMessage,
    String? nullParamsCode,
  }) {
    _instance = FetchResultErrorOptions._(
      nullParamsMessage: nullParamsMessage ?? _instance.nullParamsMessage,
      nullParamsCode: nullParamsCode ?? _instance.nullParamsCode,
    );
  }

  /// The error message displayed when a fetch operation is
  /// attempted with null parameters.
  final String nullParamsMessage;

  /// The error code associated with attempting a fetch operation
  /// with null parameters.
  final String nullParamsCode;

  /// Gets a [DomainError] representing the error for attempting to fetch with
  /// null parameters.
  ///
  /// This uses the currently configured
  /// [nullParamsMessage] and [nullParamsCode] from the [_instance].
  static DomainError get cannotFetchWithNullParams {
    return DomainError(
      _instance.nullParamsMessage,
      code: _instance.nullParamsCode,
    );
  }
}
