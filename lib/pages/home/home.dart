import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:to_do/config/custom_colors.dart';
import 'package:to_do/config/messanges.dart';
import 'package:to_do/pages/home/home_provider.dart';
import 'package:intl/intl.dart';

enum ToDoListType { all, complete, incomplete }

class Home extends ConsumerWidget {
  final ToDoListType listType;
  const Home({Key? key, this.listType = ToDoListType.all}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var toDoList = ref.watch(homeProvider).toDoList;

    switch (listType) {
      case ToDoListType.complete:
        toDoList = toDoList.where((element) => element.isDone).toList();
        break;
      case ToDoListType.incomplete:
        toDoList = toDoList.where((element) => !element.isDone).toList();
        break;
      default:
        break;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(Messages.appNameTitle),
      ),
      floatingActionButton: listType != ToDoListType.complete
          ? FloatingActionButton(
              onPressed: () async {
                final result = await showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return const _AddForm();
                    });
                if (result != null && result is String) {
                  ref.read(homeProvider.notifier).addToDo(result);
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: ObjectKey(toDoList[index].createdAt),
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: toDoList[index].isDone,
              onChanged: (isDone) {
                ref
                    .read(homeProvider.notifier)
                    .toggleToDoStatus(toDoList[index], isDone ?? false);
              },
              title: Text(toDoList[index].task),
              subtitle: Text(DateFormat.yMMMd()
                  .add_jm()
                  .format(toDoList[index].createdAt)),
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    final result = await showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return _AddForm(
                            initialText: toDoList[index].task,
                          );
                        });
                    if (result != null && result is String) {
                      ref
                          .read(homeProvider.notifier)
                          .editToDoTask(toDoList[index], result);
                    }
                  },
                  backgroundColor: CustomColors.editColor,
                  icon: Icons.edit,
                  label: Messages.editTitle,
                ),
                SlidableAction(
                  onPressed: (context) {
                    ref
                        .read(homeProvider.notifier)
                        .removeToDo(toDoList[index].createdAt);
                  },
                  backgroundColor: CustomColors.deleteColor,
                  icon: Icons.cancel,
                  label: Messages.deleteTitle,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AddForm extends ConsumerWidget {
  final String initialText;

  const _AddForm({Key? key, this.initialText = ''}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller =
        TextEditingController(text: initialText);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: controller,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(Messages.cancelTitle)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        Navigator.of(context).pop(controller.text);
                      }
                    },
                    child: Text(Messages.addTitle),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 128),
        ],
      ),
    );
  }
}
