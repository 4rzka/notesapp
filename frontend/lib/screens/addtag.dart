import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tag.dart';
import '../providers/tag_provider.dart';

class AddTagPage extends StatefulWidget {
  final bool isUpdate;
  final String? tag;
  const AddTagPage({Key? key, required this.isUpdate, this.tag})
      : super(key: key);

  @override
  State<AddTagPage> createState() => _AddTagPageState();
}

class _AddTagPageState extends State<AddTagPage> {
  TextEditingController tagController = TextEditingController();

  final FocusNode tagFocus = FocusNode();

  void addNewTag() {
    Tag newTag = Tag(
      name: tagController.text,
    );
    Provider.of<TagProvider>(context, listen: false).addTag(newTag);
  }

  void updateTag() {
    Tag updatedTag = Tag(
      id: widget.tag,
      name: tagController.text,
    );

    Provider.of<TagProvider>(context, listen: false).updateTag(updatedTag);
  }

  @override
  void initState() {
    if (widget.isUpdate) {
      tagController.text = widget.tag!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                widget.isUpdate ? 'Update Tag' : 'Add Tag',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: tagController,
                focusNode: tagFocus,
                decoration: const InputDecoration(
                  labelText: 'Tag',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Existing Tags',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Consumer<TagProvider>(
              builder: (context, tagProvider, child) {
                if (tagProvider.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tagProvider.tags.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(tagProvider.tags[index].name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            tagProvider.deleteTag(tagProvider.tags[index]);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.isUpdate)
                    ElevatedButton.icon(
                      onPressed: () => tagController.clear(),
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear'),
                    ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (widget.isUpdate) {
                        updateTag();
                      } else {
                        addNewTag();
                      }
                    },
                    icon: Icon(widget.isUpdate ? Icons.save : Icons.add),
                    label: Text(widget.isUpdate ? 'Update' : 'Add'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
