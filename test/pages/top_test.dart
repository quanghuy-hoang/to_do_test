// A Counter implemented and tested with Dart only (no dependency on Flutter)

// We declared a provider globally, and we will use it in two tests, to see
// if the state correctly resets to `0` between tests.
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do/pages/top_provider.dart';
import 'package:to_do/pages/top_state.dart';

// Using mockito to keep track of when a provider notify its listeners
class Listener extends Mock {
  void call(TopState? previous, TopState value);
}

void main() {
  test('change bottom nav index', () {
    const state = TopState();
    final resultState = state.copyWith(currentIndex: 0);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    container.listen<TopState>(
      topProvider,
      listener,
      fireImmediately: true,
    );

    verify(listener(null, state)).called(1);
    verifyNoMoreInteractions(listener);

    container.read(topProvider.notifier).changeCurrentIndex(0);

    verify(listener(state, resultState)).called(1);
    verifyNoMoreInteractions(listener);
  });
}
