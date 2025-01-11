import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'theory_provider.g.dart';

class TheoryWrapper {
  int index;
  final int limit;
  final List<HeadingContent> headings;
  PageItem item;

  TheoryWrapper(this.index, this.limit, this.headings, this.item);

  String? heading(int index) {
    if (index >= 0 && index < headings.length) {
      return headings[index].title;
    }

    return null;
  }

  TheoryWrapper copyWith(
      {int? index,
      int? limit,
      List<HeadingContent>? headings,
      PageItem? item}) {
    return TheoryWrapper(index ?? this.index, limit ?? this.limit,
        headings ?? this.headings, item ?? this.item);
  }
}

@riverpod
class Theory extends _$Theory {
  late int limit;
  late List<HeadingContent> headings;
  // late int index;
  @override
  Future<TheoryWrapper> build() async {
    ChapterContent chapter = ChapterContent.fromJson(
        jsonDecode(await rootBundle.loadString("assets/theory/scheme.json")));
    print("building again");
    headings = chapter.headings;
    limit = chapter.headings.length + 1;
    print("limit $limit");
    // index = 0;

    return TheoryWrapper(0, limit, headings, chapter);
  }

  Future<String> getText(int chapterIndex) {
    // assert that it is not chapter index
    return rootBundle.loadString("assets/theory/chapter${chapterIndex}.md");
  }

  Future<void> redirectToPage(int index) async {
    print("redirecting here to $index");

    if (index == 0) {
      print("invalidating 0=$index");
      ref.invalidateSelf();
    } else {
      state.whenData((data) async {
        final chapter =
            PageContent(headings[index - 1].title, await getText(index), index);
        state = AsyncData(data.copyWith(item: chapter, index: index));
      });
    }
  }

  void redirectNextPage() async {
    state.whenData((data) {
      int index = data.index;
      print("redirecting next page current index $index");
      if (index < limit - 1) {
        redirectToPage(index + 1);
      }
    });
  }

  void redirectPreviousPage() async {
    state.whenData((data) {
      int index = data.index;
      print("redirecting previos page current index $index");

      if (index > 0) {
        redirectToPage(index - 1);
      }
    });
  }
}

mixin PageItem {
  String get title;
}

class PageContent implements PageItem {
  @override
  String title;
  String text;
  int index;
  PageContent(this.title, this.text, this.index);
}

@JsonSerializable()
class HeadingContent {
  final String title;
  final String path;

  HeadingContent(
    this.title,
    this.path,
  );

  factory HeadingContent.fromJson(Map<String, dynamic> json) =>
      _$HeadingContentFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$HeadingContentToJson(this);
}

@JsonSerializable()
class ChapterContent implements PageItem {
  @override
  String title;
  List<HeadingContent> headings;

  ChapterContent(
    this.title,
    this.headings,
  );

  factory ChapterContent.fromJson(Map<String, dynamic> json) =>
      _$ChapterContentFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ChapterContentToJson(this);
}
