# file: app.rb

require_relative 'lib/database_connection'
require_relative 'lib/post_repository'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('blog')

repo = PostRepository.new 

post = repo.find_with_comments(1)

p post.title 

post.comments.each do |comment|
  p comment.content
end

# terminal outputs the post with id 1 and the 3 comments with 1 as their post_id's:

# "First Blog Post"
# "happy comment"
# "angry comment"
# "another angry comment"