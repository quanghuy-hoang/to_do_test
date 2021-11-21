import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:to_do/config/custom_colors.dart';
import 'package:to_do/config/messages.dart';
import 'package:to_do/pages/home/home_provider.dart';
import 'package:intl/intl.dart';

enum ToDoListType { all, complete, incomplete }

class Home extends ConsumerWidget {
  final ToDoListType listType;
  const Home({Key? key, this.listType = ToDoListType.all}) : super(key: key);

  Future<String?> _showToDoEditingDialog(BuildContext context,
      {String? title, String? confirmTitle, String initialText = ''}) {
    final TextEditingController controller =
        TextEditingController(text: initialText);
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? Messages.newToDo),
          content: SingleChildScrollView(
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: controller,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(Messages.cancel)),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  Navigator.of(context).pop(controller.text);
                }
              },
              child: Text(confirmTitle ?? Messages.add),
            ),
          ],
        );
      },
    );
  }

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
        centerTitle: true,
        title: Text(Messages.appNameTitle),
      ),
      floatingActionButton: listType != ToDoListType.complete
          ? FloatingActionButton(
              onPressed: () async {
                final result = await _showToDoEditingDialog(
                  context,
                  title: Messages.newToDo,
                  confirmTitle: Messages.add,
                );
                if (result != null && result is String) {
                  ref.read(homeProvider.notifier).addToDo(result);
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 56),
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
                    final result = await _showToDoEditingDialog(context,
                        title: Messages.edit,
                        confirmTitle: Messages.confirm,
                        initialText: toDoList[index].task);
                    if (result != null && result is String) {
                      ref
                          .read(homeProvider.notifier)
                          .editToDoTask(toDoList[index], result);
                    }
                  },
                  backgroundColor: CustomColors.editColor,
                  icon: Icons.edit,
                  label: Messages.edit,
                ),
                SlidableAction(
                  onPressed: (context) {
                    ref
                        .read(homeProvider.notifier)
                        .removeToDo(toDoList[index].createdAt);
                  },
                  backgroundColor: CustomColors.deleteColor,
                  icon: Icons.cancel,
                  label: Messages.delete,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
