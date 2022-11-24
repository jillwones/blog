# Post Model and Repository Classes Design Recipe

## 1. Design and create the Table

```
Table: posts

Columns:
id | title | content
```

## 2. Create Test SQL seeds

```sql
TRUNCATE TABLE comments, posts RESTART IDENTITY; 

INSERT INTO posts (title, content) VALUES ('First Blog Post', 'bad blog');
INSERT INTO students (title, content) VALUES ('Second Blog Post', 'better blog');

INSERT INTO comments (content, author_name, post_id) VALUES('happy comment', 'bob', 1);
INSERT INTO comments (content, author_name, post_id) VALUES('angry comment', 'jeff', 1);
INSERT INTO comments (content, author_name, post_id) VALUES('another angry comment', 'greg', 1);
INSERT INTO comments (content, author_name, post_id) VALUES('happiest comment', 'jill', 2);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
class Post
end

class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
class Post
  attr_accessor :id, :title, :content, :comments
  def initialize
    @comments = []
  end
end
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

```ruby
class PostRepository
  def find_with_comments(post_id)
    # Executes the SQL query:
    'SELECT posts.id AS post_id, posts.title AS post_title, posts.content AS post_content, comments.id AS comment_id, comments.content AS comment_content, comments.author_name, comments.post_id
    FROM posts
    JOIN comments ON comments.post_id = posts.id
    WHERE posts.id = $1'
    # returns a post object
    # with an array of comment objects
end
```

## 6. Write Test Examples

```ruby
# 1
# finds cohort with relevant students

repo = PostRepository.new

post = repo.find_with_comments(1)

expect(post.title).to eq('First Blog Post')
expect(post.content).to eq('bad blog')

expect(post.comments.length).to eq(3)
expect(post.comments.first.author_name).to eq('bob')
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'blog_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_tables
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._