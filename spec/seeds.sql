TRUNCATE TABLE comments, posts RESTART IDENTITY; 

INSERT INTO posts (title, content) VALUES ('First Blog Post', 'bad blog');
INSERT INTO posts (title, content) VALUES ('Second Blog Post', 'better blog');

INSERT INTO comments (content, author_name, post_id) VALUES('happy comment', 'bob', 1);
INSERT INTO comments (content, author_name, post_id) VALUES('angry comment', 'jeff', 1);
INSERT INTO comments (content, author_name, post_id) VALUES('another angry comment', 'greg', 1);
INSERT INTO comments (content, author_name, post_id) VALUES('happiest comment', 'jill', 2);