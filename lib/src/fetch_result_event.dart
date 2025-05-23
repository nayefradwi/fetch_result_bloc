sealed class FetchResultEvent<P> {
  const FetchResultEvent(this.params);
  final P params;
}

class FetchLoadResultEvent<P> extends FetchResultEvent<P> {
  const FetchLoadResultEvent(super.params);
}

class FetchRefreshResultEvent<P> extends FetchResultEvent<P> {
  const FetchRefreshResultEvent(super.params);
}
