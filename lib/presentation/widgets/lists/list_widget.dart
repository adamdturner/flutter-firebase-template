import 'package:flutter/material.dart';

class ListWidget<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T) itemBuilder;

  const ListWidget({
    super.key,
    required this.items,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(items[index]),
    );
  }
}