// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:perspicacity/box.dart';
import 'package:perspicacity/utils/globals.dart';

class ListWihParts extends StatefulWidget {
  const ListWihParts({super.key});

  @override
  State<ListWihParts> createState() => _ListWihPartsState();
}

class _ListWihPartsState extends State<ListWihParts> {
  void remove_index(int index) {
    Provider.of<globals>(context, listen: false).removeItem(index);
  }

  void updateMyTiles(int oldIndex, int newIndex) {
    Provider.of<globals>(context, listen: false)
        .reorderItems(oldIndex, newIndex);
  }

  // void remove_index(int index) {
  //   // redundant
  //   setState(() {
  //     Provider.of<globals>(context, listen: false).myArray.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: ThemeData(
        canvasColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Consumer<globals>(
          builder: (context, arrayProvider, child) {
            return ReorderableListView.builder(
              itemCount: arrayProvider.myArray.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: currentWidth > 850
                      ? ReorderableDragStartListener(
                          index: index,
                          child: const Icon(
                            Icons.drag_indicator_outlined,
                            color: Colors.white,
                          ))
                      : null,
                  key: ValueKey('${arrayProvider.myArray[index]}_$index'),
                  title: ClipRect(
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: DrawerMotion(),
                        extentRatio: 1,
                        children: [
                          SlidableAction(
                            onPressed: (context) {},
                            backgroundColor: Color(0xff38544d),
                            foregroundColor: Colors.white,
                            label: "additional text here",
                            borderRadius: BorderRadius.circular(14),
                          )
                        ],
                      ),
                      startActionPane: ActionPane(
                        motion: DrawerMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.circular(12),
                            onPressed: (context) => remove_index(index),
                            icon: Icons.delete,
                            label: 'Delete',
                            backgroundColor: Colors.red.shade400,
                          )
                        ],
                      ),
                      child: SlidableContainer(
                        child: arrayProvider.myArray[index],
                      ),
                    ),
                  ),
                );
              },
              onReorder: (oldIndex, newIndex) =>
                  updateMyTiles(oldIndex, newIndex),
            );
          },
        ),
      ),
    );
  }
}
