import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_health_app/app_drawer.dart';
import 'package:mental_health_app/theory/theory_provider.dart';

class TheoryPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TheoryState();
}

class _TheoryState extends ConsumerState<TheoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theoretical"),
      ),
      drawer: const AppDrawer(),
      body: Consumer(builder: (context, ref, _) {
        return ref.watch(theoryProvider).when(
            data: (content) => switch (content) {
                  ChapterContent chapter =>
                    ChapterContentWidget(content: chapter),
                  _ => const Text("nothingF"),
                },
            error: (error, stack) => Text("erro"),
            loading: () => CircularProgressIndicator());
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
    final size = MediaQuery.sizeOf(context);
    return const Center(
      child : SafeArea(child: Markdown(data: "# Heading 1\n Some text here",)),
    );
  }
}
