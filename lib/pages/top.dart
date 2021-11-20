import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:to_do/pages/top_provider.dart';

import 'home/home.dart';

class Top extends ConsumerWidget {
  const Top({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(topProvider).currentIndex;
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: const [
            Home(listType: ToDoListType.complete),
            Home(listType: ToDoListType.all),
            Home(listType: ToDoListType.incomplete)
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.done), label: "Complete"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive), label: "Incomplete")
        ],
        currentIndex: currentIndex,
        onTap: ref.read(topProvider.notifier).changeCurrentIndex,
      ),
    );
  }
}
