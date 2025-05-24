A Dart package providing `FetchResultBloc` and `FetchResultCubit` to simplify
managing states for asynchronous data fetching operations.

## Features

- ✨ Simplifies state management for asynchronous data fetching operations.
- 🧱 Provides `FetchResultBloc` for event-driven state management.
- 🧊 Offers `FetchResultCubit` for simpler, direct state management.
- 🚦 Clearly defines states for loading, success (with data), and error (with details).

## Getting started

1. **Add dependency**: Add `fetch_result_bloc` to your `pubspec.yaml`:
   ```yaml
   dependencies:
     fetch_result_bloc: ^1.0.0 # Replace with the latest version
   ```
2. **Install**: Run `dart pub get` or `flutter pub get`.
3. **Import**: Import the package in your Dart code:
   ```dart
   import 'package:fetch_result_bloc/fetch_result_bloc.dart';
   ```

## Usage

Here's a basic example of using `FetchResultCubit` to fetch a value:

```dart
import 'package:fetch_result_bloc/fetch_result_bloc.dart';
import 'package:result_flow/result_flow.dart';

// Define your Cubit
class CounterCubit extends FetchResultCubit<int, void> {
  CounterCubit() : super(const FetchResultStateInitial());

  @override
  Future<void> fetch({void param}) => super.fetch(param: null);

  @override
  FutureResult<int> getResult({void param}) async {
    await Future.delayed(const Duration(seconds: 1));
    return Result.success(42);
  }
}

void main() async {
  final cubit = CounterCubit();
  cubit.stream.listen(print);

  // call fetch when required
  await cubit.fetch();
  await Future.delayed(const Duration(seconds: 2));
  cubit.close();
}
```

For more detailed examples, including `FetchResultBloc` usage please see the `/example` folder.

## Related Packages

`fetch_result_bloc` is built on top of `result_flow` to simplify asynchronous fetch operations ins a safe way

| Package             | Pub.dev Link                                                                                                     |
| :------------------ | :--------------------------------------------------------------------------------------------------------------- |
| `fetch_result_bloc` | [![pub package](https://img.shields.io/pub/v/fetch_result_bloc.svg)](https://pub.dev/packages/fetch_result_bloc) |
| `result_flow`       | [![pub package](https://img.shields.io/pub/v/result_flow.svg)](https://pub.dev/packages/result_flow)             |
| `result_flow_dio`   | [![pub package](https://img.shields.io/pub/v/result_flow_dio.svg)](https://pub.dev/packages/result_flow_dio)     |
