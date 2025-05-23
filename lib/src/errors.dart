import 'package:result_flow/result_flow.dart';

class FetchResultErrorOptions {
  FetchResultErrorOptions._({
    this.nullParamsMessage = 'Cannot fetch with null params',
    this.nullParamsCode = 'fetch_with_null_params',
  });

  static FetchResultErrorOptions _instance = FetchResultErrorOptions._();

  static void replaceDefaults({
    String? nullParamsMessage,
    String? nullParamsCode,
  }) {
    _instance = FetchResultErrorOptions._(
      nullParamsMessage: nullParamsMessage ?? _instance.nullParamsMessage,
      nullParamsCode: nullParamsCode ?? _instance.nullParamsCode,
    );
  }

  final String nullParamsMessage;
  final String nullParamsCode;

  static DomainError get cannotFetchWithNullParams {
    return DomainError(
      _instance.nullParamsMessage,
      code: _instance.nullParamsCode,
    );
  }
}
