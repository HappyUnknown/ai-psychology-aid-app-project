import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'theory_provider.g.dart';
@riverpod
class Theory extends _$Theory {
  @override
  Future<PageContent> build() async {
    return ChapterContent("Overview", "heello", [1,2,3,4].map((e) => PageContent("Chapter $e", "here is the main textof this chapter")).toList(),  "");
  }

  
}

class PageContent { 
  String title;
  String text;
  PageContent(this.title, this.text);
}

class ChapterContent extends PageContent {
  String image;
  List<PageContent> pages;

  ChapterContent(super.title, super.text, this.pages, this.image); 
}