import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

late Map<String, dynamic> data;

Future<void> loadData() async {
  final file = File('data.json');
  final contents = await file.readAsString();
  data = jsonDecode(contents);
}

Response _getAllCategories(Request req) {
  try {
    var categories = data["categories"] as List;
    var categoryDetails = categories.map((category) {
      return {
        "id": category["id"],
        "name": category["name"]
      };
    }).toList();

    return Response.ok(
        jsonEncode({"categories": categoryDetails}),
        headers: {'Content-Type': 'application/json'}
    );
  } catch (e) {
    return Response.internalServerError(
        body: 'Failed to get categories: $e'
    );
  }
}

Response _getQuoteById(Request req, String quoteId) {
  try {
    var categories = data["categories"] as List?;
    if (categories == null) {
      return Response.internalServerError(body: 'Categories not found');
    }

    for (var category in categories) {
      var subcategories = category["subcategories"] as List?;
      if (subcategories == null) continue;

      for (var subcategory in subcategories) {
        var quotes = subcategory["quotes"] as List?;
        if (quotes == null) continue;

        var quote = quotes.firstWhere(
                (q) => q["id"].toString() == quoteId,
            orElse: () => {"id": "", "text": "", "author": ""}
        );

        if (quote["id"] != "") {
          return Response.ok(
              jsonEncode({
                "quote": {
                  "id": quote["id"],
                  "text": quote["text"],
                  "author": quote["author"]
                }
              }),
              headers: {'Content-Type': 'application/json'}
          );
        }
      }
    }

    return Response.notFound('Quote not found');
  } catch (e) {
    return Response.internalServerError(
        body: 'Failed to get quote by ID: $e'
    );
  }
}

Response _getAuthors(Request req) {
  try {
    var categories = data["categories"];
    if (categories == null) {
      return Response.internalServerError(body: 'Categories not found');
    }

    var authorSet = <String>{};

    for (var category in categories) {
      var subcategories = category["subcategories"] as List?;
      if (subcategories == null) continue;

      for (var subcategory in subcategories) {
        var quotes = subcategory["quotes"] as List?;
        if (quotes == null) continue;

        for (var quote in quotes) {
          var author = quote["author"];
          if (author != null) {
            authorSet.add(author);
          }
        }
      }
    }

    return Response.ok(jsonEncode({"authors": authorSet.toList()}), headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(body: 'Failed to get authors: $e');
  }
}

Response _getQuotesByAuthor(Request req, String authorName) {
  try {
    var categories = data["categories"] as List?;
    if (categories == null) {
      return Response.internalServerError(body: 'Categories not found');
    }

    var quotesByAuthor = <Map<String, dynamic>>[];

    for (var category in categories) {
      var subcategories = category["subcategories"] as List?;
      if (subcategories == null) continue;

      for (var subcategory in subcategories) {
        var quotes = subcategory["quotes"] as List?;
        if (quotes == null) continue;

        for (var quote in quotes) {
          if (quote["author"] == authorName) {
            quotesByAuthor.add(quote);
          }
        }
      }
    }

    if (quotesByAuthor.isEmpty) {
      return Response.notFound('No quotes found for the author: $authorName');
    }

    return Response.ok(jsonEncode({"quotes": quotesByAuthor}), headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(body: 'Failed to get quotes by author: $e');
  }
}

Response _getSubcategoriesByCategory(Request req, String categoryName) {
  try {
    var categories = data["categories"] as List;
    var subcategoriesList = <Map<String, dynamic>>[];

    for (var category in categories) {
      if (category["name"] == categoryName) {
        var subcategories = category["subcategories"] as List;
        for (var subcategory in subcategories) {
          subcategoriesList.add({
            "name": subcategory["name"],
            "id": subcategory["id"]
          });
        }
        if (subcategoriesList.isEmpty) {
          return Response.notFound('No subcategories found for category: $categoryName');
        }
        return Response.ok(
            jsonEncode({"subcategories": subcategoriesList}),
            headers: {'Content-Type': 'application/json'}
        );
      }
    }

    return Response.notFound('Category not found: $categoryName');
  } catch (e) {
    return Response.internalServerError(
        body: 'Failed to get subcategories by category: $e'
    );
  }
}

Response _home(Request req) {
  return Response.ok('Welcome to the Quotes API! Use the available endpoints to get quotes, authors, and more.',
      headers: {'Content-Type': 'text/plain'});
}

void main() async {
  await loadData();
  final router = Router()
    ..get('/', _home)
    ..get('/categories', _getAllCategories)
    ..get('/quotes/<quoteId>', _getQuoteById)
    ..get('/quotes/author/<authorName>', _getQuotesByAuthor)
    ..get('/authors', _getAuthors)
    ..get('/subcategories/category/<categoryName>', _getSubcategoriesByCategory);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  var port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await io.serve(handler, '0.0.0.0', port);
  print('Server listening on port ${server.port}');
}
