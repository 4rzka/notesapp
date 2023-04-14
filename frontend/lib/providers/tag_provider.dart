import 'package:flutter/cupertino.dart';
import '../models/tag.dart';
import '../services/api_service.dart';

class TagProvider with ChangeNotifier {
  List<Tag> tags = [];
  bool isLoading = true;

  TagProvider() {
    fetchTags();
  }

  void addTag(Tag tag) {
    tags.add(tag);
    notifyListeners();
    ApiService.addTag(tag);
  }

  void updateTag(Tag tag) {
    int tagIndex =
        tags.indexOf(tags.firstWhere((element) => element.id == tag.id));
    tags[tagIndex] = tag;
    notifyListeners();
    ApiService.updateTag(tag);
  }

  void deleteTag(Tag tag) {
    int tagIndex =
        tags.indexOf(tags.firstWhere((element) => element.id == tag.id));
    tags.removeAt(tagIndex);
    notifyListeners();
    ApiService.deleteTag(tag.id);
  }

  void fetchTags() async {
    tags = await ApiService.fetchTags();
    isLoading = false;
    notifyListeners();
  }
}
