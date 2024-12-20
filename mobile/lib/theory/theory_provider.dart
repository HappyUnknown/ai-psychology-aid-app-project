import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'theory_provider.g.dart';

@riverpod
class Theory extends _$Theory {
  late final limit;
  @override
  Future<PageContent> build() async {
    limit = int.parse(await rootBundle.loadString("assets/theory/scheme.json")) + 1;

    return ChapterContent("Overview", "heello", 0, [1,2,3,4].map((e) => PageContent("Chapter $e", "here is the main textof this chapter", e)).toList(),  "");
  }

  Future<String> getText(int chapterIndex) { 
    // assert that it is not chapter index
    return rootBundle.loadString("assets/theory/chapter${chapterIndex}.md");
  }

  Future<void> redirectToPage(int index) async  {
    final chapter = PageContent("Chapter $index", await getText(index), index);

    state = AsyncData(chapter);

  }

  void redirectNextPage() {
    state.whenData((data) {
      if (data.index < limit -1 ) {
        redirectToPage(data.index + 1);
      }
    });
  }

   void redirectPreviousPage() {
    state.whenData((data) {
      if (data.index > 0) {
        redirectToPage(data.index - 1);
      }
    });
  }
  
}


class PageContent { 
  String title;
  String text;
  int index;
  PageContent(this.title, this.text, this.index);
}

class ChapterContent extends PageContent {
  String image;
  List<PageContent> pages;

  ChapterContent(super.title, super.text, super.index, this.pages, this.image); 
}