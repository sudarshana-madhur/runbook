import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

/// Extracts the list of Instagram usernames that you follow but who do not
/// follow you back from a raw ZIP file [bytes].
///
/// Returns a list of non-follower usernames on success.
/// Throws an [Exception] with a descriptive message on failure.
Future<List<String>> extractUnfollowers(Uint8List bytes) async {
  final archive = ZipDecoder().decodeBytes(bytes);

  Uint8List? followersBytes;
  Uint8List? followingBytes;

  for (final file in archive) {
    if (!file.isFile) continue;
    final name = file.name.split('/').last;
    if (name == 'followers_1.json' && followersBytes == null) {
      followersBytes = Uint8List.fromList(file.content as List<int>);
    } else if (name == 'following.json' && followingBytes == null) {
      followingBytes = Uint8List.fromList(file.content as List<int>);
    }
    if (followersBytes != null && followingBytes != null) break;
  }

  if (followersBytes == null) {
    throw Exception('followers_1.json not found in the ZIP file.');
  }
  if (followingBytes == null) {
    throw Exception('following.json not found in the ZIP file.');
  }

  // followers_1.json: top-level array; each item has string_list_data[].value
  final followersList = jsonDecode(utf8.decode(followersBytes)) as List<dynamic>;
  final followers = <String>{};
  for (final entry in followersList) {
    final stringListData = entry['string_list_data'] as List<dynamic>;
    for (final item in stringListData) {
      final value = item['value'] as String?;
      if (value != null && value.isNotEmpty) followers.add(value);
    }
  }

  // following.json: { "relationships_following": [...] }; each item has title
  final followingMap = jsonDecode(utf8.decode(followingBytes)) as Map<String, dynamic>;
  final followingList = followingMap['relationships_following'] as List<dynamic>;
  final following = <String>[];
  for (final entry in followingList) {
    final title = entry['title'] as String?;
    if (title != null && title.isNotEmpty) following.add(title);
  }

  // Return users you follow who don't follow back
  return following.where((user) => !followers.contains(user)).toList();
}
