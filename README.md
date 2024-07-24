Here is an example of a detailed wiki for your API service:

---

## Welcome to the Motivator Quotes Api Service 

### Overview
This API service is built using Dart and provides motivational quotes organized into various categories and subcategories. The service allows users to fetch quotes by different criteria, such as by quote ID, by author, and by category.

### Table of Contents
1. [Getting Started](#getting-started)
2. [API Endpoints](#api-endpoints)
    - [List All Categories](#list-all-categories)
    - [Get Subcategories by Category Name](#get-subcategories-by-category-name)
    - [Get Quote by ID](#get-quote-by-id)
    - [List All Authors](#list-all-authors)
    - [Get Quotes by Author](#get-quotes-by-author)
3. [Hosting](#hosting)
    - [Firebase Hosting](#firebase-hosting)
4. [Contributing](#contributing)
5. [License](#license)

### Getting Started
To get started with the Dart API Service, you will need Dart installed on your machine. Clone the repository and run the following commands to start the server:

```bash
git clone https://github.com/yourusername/yourrepository.git
cd yourrepository
dart run bin/server.dart
```

The server will start on `http://localhost:8080`.

### API Endpoints

#### List All Categories
**Endpoint:** `/categories`  
**Method:** `GET`  
**Description:** Returns a list of all categories with their IDs.

**Response:**
```json
{
  "categories": [
    {"id": 11, "name": "Self-Improvement"},
    {"id": 12, "name": "Motivation"}
    // more categories
  ]
}
```

#### Get Subcategories by Category Name
**Endpoint:** `/categories/{categoryName}/subcategories`  
**Method:** `GET`  
**Description:** Returns a list of subcategories for a given category name along with their IDs.

**Response:**
```json
{
  "subcategories": [
    {"id": 111, "name": "Personal Growth"},
    {"id": 112, "name": "Learning and Education"}
    // more subcategories
  ]
}
```

#### Get Quote by ID
**Endpoint:** `/quotes/{quoteId}`  
**Method:** `GET`  
**Description:** Returns the quote with the specified ID.

**Response:**
```json
{
  "quote": {
    "id": "2406",
    "text": "Personal growth is not a matter of learning new information but unlearning old limits.",
    "author": "Anonymous"
  }
}
```

#### List All Authors
**Endpoint:** `/authors`  
**Method:** `GET`  
**Description:** Returns a list of all unique authors.

**Response:**
```json
{
  "authors": ["Anonymous", "Steve Jobs", "Eleanor Roosevelt"]
}
```

#### Get Quotes by Author
**Endpoint:** `/quotes/author/{authorName}`  
**Method:** `GET`  
**Description:** Returns all quotes by the specified author.

**Response:**
```json
{
  "quotes": [
    {
      "id": "2406",
      "text": "Personal growth is not a matter of learning new information but unlearning old limits.",
      "author": "Anonymous"
    },
    {
      "id": "2415",
      "text": "Your time is limited, don’t waste it living someone else’s life.",
      "author": "Steve Jobs"
    }
    // more quotes
  ]
}
```



### Contributing
We welcome contributions to improve the API service. Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature-branch-name`.
3. Make your changes and commit them: `git commit -m 'Add some feature'`.
4. Push to the branch: `git push origin feature-branch-name`.
5. Create a pull request.

### License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

