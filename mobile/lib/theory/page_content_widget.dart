import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_health_app/theory/theory_provider.dart';

class PageContentWidget extends ConsumerStatefulWidget {
  final PageContent content;
  const PageContentWidget({super.key, required this.content});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PageContentWidgetState();
}

class _PageContentWidgetState extends ConsumerState<PageContentWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Markdown(data: widget.content.text)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () =>
                    ref.read(theoryProvider.notifier).redirectPreviousPage(),
                child: const Text("<"),
              ),
              const Text("Theoretical"),
              TextButton(
                onPressed: () =>
                    ref.read(theoryProvider.notifier).redirectNextPage(),
                child: const Text(">"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
