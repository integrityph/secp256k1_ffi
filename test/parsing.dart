import 'dart:convert';

import 'helpers.dart';

List<Map<String, dynamic>> keyValueToJSON(
  String src,
  String name, {
  String separator = ":",
  String unnamedTagKey = "",
}) {
  final List<String> lines = src
      .split("\n")
      .map((line) => line.trim())
      .toList();
  final List<Map<String, dynamic>> result = [];

  Map<String, dynamic>? tempMap;
  List<String> parts;
  int counter = 1;
  String unnamedTagValue = "";
  String namedTagKey = "";
  String namedTagValue = "";
  final unnamedTagRegex = RegExp(r'\[([^\]=]+)\]');
  final namedTagRegex = RegExp(r'\[([^\]=]+?)\s*=\s*([^\]]+?)\]');
  RegExpMatch? match;
  for (final line in lines) {
    if (line.startsWith("#")) {
      continue;
    }
    if (line.isEmpty && tempMap != null) {
      result.add(tempMap);
      tempMap = null;
      counter++;
      continue;
    }

    if (line.isEmpty) {
      continue;
    }
    match = unnamedTagRegex.firstMatch(line);
    if (unnamedTagKey != "" && match != null) {
      unnamedTagValue = match.group(0)!;
      unnamedTagValue = line.substring(1, line.length - 1);
      continue;
    }
    match = namedTagRegex.firstMatch(line);
    if (match != null) {
      namedTagKey = match.group(1)!;
      namedTagValue = match.group(2)!;
      continue;
    } else if (!line.contains(separator)) {
      continue;
    }
    // at this point we have a sample
    if (tempMap == null) {
      tempMap = {"_name": "sample #$counter"};
      if (unnamedTagValue != "") {
        tempMap[unnamedTagKey] = unnamedTagValue;
      }
      if (namedTagKey != "") {
        tempMap[namedTagKey] = namedTagValue;
      }
    }
    parts = line.split(separator);
    parts[0] = parts[0].trim();
    parts[1] = parts.sublist(1).join(separator).trim();

    // prepare the value
    if (parts[1].startsWith("\"")) {
      parts[1] = hex.encode(utf8.encode(parts[1].substring(1,parts[1].length-1)));
    }
    tempMap[parts[0]] = parts[1];
  }

  // check if we still have a sample that wasn't added yet
  if (tempMap != null) {
    tempMap["_name"] = "sample #$counter";
    result.add(tempMap);
  }

  return result;
}
