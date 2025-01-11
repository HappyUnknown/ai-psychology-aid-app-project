import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mental_health_app/theory/theory_provider.dart';

class PageContentWidget extends ConsumerStatefulWidget {
  final PageContent content;
  const PageContentWidget({super.key, required this.content});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PageContentWidgetState();
}

class _PageContentWidgetState extends ConsumerState<PageContentWidget> {
  late final ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ref.watch(theoryProvider).when(
              data: (data) {
                return "${data.index}. ${data.item.title}";
              },
              error: (error, stack) => "Could not Load",
              loading: () => "Loading..."),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        children: [
          Markdown(
              controller: _scroll, shrinkWrap: true, data: widget.content.text),
          Builder(
            builder: (context) {
              final previous = ref.watch(theoryProvider).when(
                      data: (data) => data.heading(data.index - 1),
                      error: (error, stack) => "",
                      loading: () => "") ??
                  "";

              final next = ref.watch(theoryProvider).when(
                      data: (data) => data.heading(data.index + 1),
                      error: (error, stack) => "",
                      loading: () => "") ??
                  "";
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => ref
                          .read(theoryProvider.notifier)
                          .redirectPreviousPage(),
                      child: Text(
                        "Previous: $previous",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  // Spacer(),
                  Expanded(
                    child: TextButton(
                      onPressed: () =>
                          ref.read(theoryProvider.notifier).redirectNextPage(),
                      child: Text(
                        "Next: $next",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
