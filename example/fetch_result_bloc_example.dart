// ignored because its just an example
// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';

import 'package:fetch_result_bloc/fetch_result_bloc.dart';

class Weather {
  Weather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.lastUpdated,
  });
  final String city;
  final String temperature;
  final String condition;
  final DateTime lastUpdated;

  @override
  String toString() {
    final time =
        '${lastUpdated.hour}:'
        '${lastUpdated.minute.toString().padLeft(2, '0')}:'
        '${lastUpdated.second.toString().padLeft(2, '0')}';
    return 'Weather in $city: $temperature°C, $condition (Updated: $time)';
  }
}

class WeatherCubit extends FetchResultCubit<Weather, String> {
  WeatherCubit({String? initialCity}) : super(params: initialCity);

  final Random _random = Random();
  final List<String> _conditions = [
    'Sunny',
    'Cloudy',
    'Rainy',
    'Stormy',
    'Windy',
    'Foggy',
  ];

  @override
  FutureResult<Weather> getResult(String city) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (_random.nextInt(10) < 1) {
      return Result.error(
        DomainError(
          'Simulated API error: Could not fetch weather for $city',
          code: 'WEATHER_API_FAILURE',
        ),
      );
    }

    final temp = 15 + _random.nextInt(20);
    final condition = _conditions[_random.nextInt(_conditions.length)];

    return Result.success(
      Weather(
        city: city,
        temperature: temp.toString(),
        condition: condition,
        lastUpdated: DateTime.now(),
      ),
    );
  }
}

Future<void> main() async {
  const cityToFetch = 'London';
  final weatherCubit = WeatherCubit(initialCity: cityToFetch);

  print('--- Weather Fetch Example --- ');
  print('Observing weather for: $cityToFetch');
  print('An initial fetch will occur, followed by refreshes every 10 seconds.');
  print('Press Ctrl+C to exit.\n');

  weatherCubit.stream.listen((state) {
    if (state.isLoaded) {
      final weather = (state as FetchResultStateLoaded<Weather>).data;
      print('[DATA]: $weather');
    } else if (state.isError) {
      final error = (state as FetchResultStateError<Weather>).error;
      print(
        '[ERROR]: Failed to get weather - ${error.message} '
        '(Code: ${error.code})',
      );
    } else if (state.isLoading) {
      print('[INFO]: Loading weather data...');
    } else if (state.isRefreshing) {
      print('[INFO]: Refreshing weather data...');
    } else if (state.isInitial) {
      print('[INFO]: Cubit initialized, awaiting first fetch command.');
    }
  });

  await weatherCubit.fetch();

  Timer.periodic(const Duration(seconds: 10), (timer) {
    print('\n[TIMER]: Triggering weather refresh for $cityToFetch...');
    weatherCubit.refresh();
  });
}
