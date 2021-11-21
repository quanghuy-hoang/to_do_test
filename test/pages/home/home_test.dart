import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do/model/to_do.dart';
import 'package:to_do/pages/home/home_notifier.dart';
import 'package:to_do/pages/home/home_provider.dart';
import 'package:to_do/pages/home/home_state.dart';
import 'package:to_do/repository/share_preference_util.dart';

class Listener extends Mock {
  void call(HomeState? previous, HomeState value);
}

void main() {
  test('init', () async {
    const state = HomeState();
    final dateTimeNow = DateTime.now();
    final toDo = ToDo(createdAt: dateTimeNow, task: 'add testing');
    final resultState = HomeState(toDoList: [toDo]);

    await SharedPreferencesUtil.instance.setToDoList([toDo]);

    final container = ProviderContainer(overrides: [
      homeProvider.overrideWithValue(HomeNotifier.withInitialState(state))
    ]);
    addTearDown(container.dispose);
    final listener = Listener();

    container.listen<HomeState>(
      homeProvider,
      listener,
      fireImmediately: true,
    );

    verify(listener(null, state)).called(1);
    verifyNoMoreInteractions(listener);

    await container.read(homeProvider.notifier).init();

    verify(listener(state, resultState)).called(1);
    verifyNoMoreInteractions(listener);
  });
  group('adding To Do to list', () {
    test('with new task', () {
      const state = HomeState();
      final dateTimeNow = DateTime.now();
      final newToDo = ToDo(createdAt: dateTimeNow, task: 'add testing');
      final resultState = state.copyWith(toDoList: [newToDo]);

      final container = ProviderContainer();
      addTearDown(container.dispose);
      final listener = Listener();

      container.listen<HomeState>(
        homeProvider,
        listener,
        fireImmediately: true,
      );

      verify(listener(null, state)).called(1);
      verifyNoMoreInteractions(listener);

      container
          .read(homeProvider.notifier)
          .addToDo('add testing', createdAt: dateTimeNow);

      verify(listener(state, resultState)).called(1);
      verifyNoMoreInteractions(listener);
    });

    test('with custom DateTime', () {
      const state = HomeState();
      final dateTime = DateTime(2017, 9, 7, 17, 30);
      final newToDo = ToDo(createdAt: dateTime, task: 'add testing');
      final resultState = state.copyWith(toDoList: [newToDo]);

      final container = ProviderContainer();
      addTearDown(container.dispose);
      final listener = Listener();

      container.listen<HomeState>(
        homeProvider,
        listener,
        fireImmediately: true,
      );

      verify(listener(null, state)).called(1);
      verifyNoMoreInteractions(listener);

      container
          .read(homeProvider.notifier)
          .addToDo('add testing', createdAt: dateTime);

      verify(listener(state, resultState)).called(1);
      verifyNoMoreInteractions(listener);
    });

    test('with custome isDone status', () {
      const state = HomeState();
      final dateTimeNow = DateTime.now();
      final newToDo =
          ToDo(createdAt: dateTimeNow, task: 'add testing', isDone: true);
      final resultState = state.copyWith(toDoList: [newToDo]);

      final container = ProviderContainer();
      addTearDown(container.dispose);
      final listener = Listener();

      container.listen<HomeState>(
        homeProvider,
        listener,
        fireImmediately: true,
      );

      verify(listener(null, state)).called(1);
      verifyNoMoreInteractions(listener);

      container
          .read(homeProvider.notifier)
          .addToDo('add testing', createdAt: dateTimeNow, isDone: true);

      verify(listener(state, resultState)).called(1);
      verifyNoMoreInteractions(listener);
    });
  });

  group('remove To Do from list', () {
    test('with existing date time', () {
      const state = HomeState();
      final dateTimeNow = DateTime.now();
      final newToDo = ToDo(createdAt: dateTimeNow, task: 'add testing');
      final addedState = state.copyWith(toDoList: [newToDo]);

      final container = ProviderContainer(overrides: [
        homeProvider
            .overrideWithValue(HomeNotifier.withInitialState(addedState))
      ]);
      addTearDown(container.dispose);
      final listener = Listener();

      container.listen<HomeState>(
        homeProvider,
        listener,
        fireImmediately: true,
      );

      verify(listener(null, addedState)).called(1);
      verifyNoMoreInteractions(listener);

      container.read(homeProvider.notifier).removeToDo(dateTimeNow);

      verify(listener(addedState, state)).called(1);
      verifyNoMoreInteractions(listener);
    });

    test('with NA date time', () {
      const state = HomeState();
      final dateTimeNow = DateTime.now();
      final newToDo = ToDo(createdAt: dateTimeNow, task: 'add testing');
      final addedState = state.copyWith(toDoList: [newToDo]);

      final container = ProviderContainer(overrides: [
        homeProvider
            .overrideWithValue(HomeNotifier.withInitialState(addedState))
      ]);
      addTearDown(container.dispose);
      final listener = Listener();

      container.listen<HomeState>(
        homeProvider,
        listener,
        fireImmediately: true,
      );

      verify(listener(null, addedState)).called(1);
      verifyNoMoreInteractions(listener);

      container
          .read(homeProvider.notifier)
          .removeToDo(DateTime(2017, 9, 7, 17, 30));

      verify(listener(addedState, addedState)).called(1);
      verifyNoMoreInteractions(listener);
    });
  });

  group('edit To Do', () {
    test('with new task', () {
      final dateTimeNow = DateTime.now();
      final toDo = ToDo(createdAt: dateTimeNow, task: 'add testing');
      final state = HomeState(toDoList: [toDo]);
      final editedToDo = toDo.copyWith(task: 'edited testing');
      final editedState = state.copyWith(toDoList: [editedToDo]);

      final container = ProviderContainer(overrides: [
        homeProvider.overrideWithValue(HomeNotifier.withInitialState(state))
      ]);
      addTearDown(container.dispose);
      final listener = Listener();

      container.listen<HomeState>(
        homeProvider,
        listener,
        fireImmediately: true,
      );

      verify(listener(null, state)).called(1);
      verifyNoMoreInteractions(listener);

      container
          .read(homeProvider.notifier)
          .editToDoTask(toDo, 'edited testing');

      verify(listener(state, editedState)).called(1);
      verifyNoMoreInteractions(listener);
    });

    test('with NA To Do', () {
      final dateTimeNow = DateTime.now();
      final toDo = ToDo(createdAt: dateTimeNow, task: 'add testing');
      final state = HomeState(toDoList: [toDo]);

      final container = ProviderContainer(overrides: [
        homeProvider.overrideWithValue(HomeNotifier.withInitialState(state))
      ]);
      addTearDown(container.dispose);
      final listener = Listener();

      container.listen<HomeState>(
        homeProvider,
        listener,
        fireImmediately: true,
      );

      verify(listener(null, state)).called(1);
      verifyNoMoreInteractions(listener);

      container.read(homeProvider.notifier).editToDoTask(
          ToDo(createdAt: DateTime.now(), task: 'NA todo'), 'edited testing');

      verifyNever(listener(state, state));
      verifyNoMoreInteractions(listener);
    });
  });

  group('toggle To Do status', () {
    test('with existing To Do', () {
      final dateTimeNow = DateTime.now();
      final toDo = ToDo(createdAt: dateTimeNow, task: 'add testing');
      final state = HomeState(toDoList: [toDo]);
      final editedToDo = toDo.copyWith(isDone: true);
      final editedState = state.copyWith(toDoList: [editedToDo]);

      final container = ProviderContainer(overrides: [
        homeProvider.overrideWithValue(HomeNotifier.withInitialState(state))
      ]);
      addTearDown(container.dispose);
      final listener = Listener();

      container.listen<HomeState>(
        homeProvider,
        listener,
        fireImmediately: true,
      );

      verify(listener(null, state)).called(1);
      verifyNoMoreInteractions(listener);

      container.read(homeProvider.notifier).toggleToDoStatus(toDo, true);

      verify(listener(state, editedState)).called(1);
      verifyNoMoreInteractions(listener);
    });

    test('with NA To Do', () {
      final dateTimeNow = DateTime.now();
      final toDo = ToDo(createdAt: dateTimeNow, task: 'add testing');
      final state = HomeState(toDoList: [toDo]);

      final container = ProviderContainer(overrides: [
        homeProvider.overrideWithValue(HomeNotifier.withInitialState(state))
      ]);
      addTearDown(container.dispose);
      final listener = Listener();

      container.listen<HomeState>(
        homeProvider,
        listener,
        fireImmediately: true,
      );

      verify(listener(null, state)).called(1);
      verifyNoMoreInteractions(listener);

      container.read(homeProvider.notifier).toggleToDoStatus(
          ToDo(createdAt: DateTime.now(), task: 'NA todo'), true);

      verifyNever(listener(state, state));
      verifyNoMoreInteractions(listener);
    });
  });
}
