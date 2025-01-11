import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_health_app/app_drawer.dart';
import 'package:mental_health_app/theory/page_content_widget.dart';
import 'package:mental_health_app/theory/theory_provider.dart';

class TheoryPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TheoryState();
}

class _TheoryState extends ConsumerState<TheoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.sizeOf(context).width, 50),
        child: AppBar(
          title: Builder(builder: (context) {
            return ref.watch(theoryProvider).when(
                  data: (data) {
                    if (data.index == 0) {
                      return Text(data.item.title);
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  error: (error, stack) => Text("Could not Load"),
                  loading: () => Text("Loading..."),
                );
          }),
        ),
      ),
      drawer: const AppDrawer(),
      body: Consumer(builder: (context, ref, _) {
        return ref.watch(theoryProvider).when(
            data: (content) => switch (content.item) {
                  ChapterContent chapter =>
                    ChapterContentWidget(content: chapter),
                  PageContent pc => PageContentWidget(content: pc),
                  _ => const Text("Unsupported page item"),
                },
            error: (error, stack) => Text("$error $stack"),
            loading: () => const CircularProgressIndicator());
      }),
    );
  }
}

class ChapterContentWidget extends ConsumerStatefulWidget {
  final ChapterContent content;
  const ChapterContentWidget({super.key, required this.content});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChapterContentWidgetState();
}

class _ChapterContentWidgetState extends ConsumerState<ChapterContentWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: widget.content.headings.length,
      // itemExtent: 60,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              ref.read(theoryProvider.notifier).redirectToPage(i + 1);
            },
            child: Text(
              "${i + 1}. ${widget.content.headings[i].title}",
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      },
    );
  }
}
