require_relative './comment'
require_relative './post'

class PostRepository
  def find_with_comments(post_id)

    sql = 'SELECT posts.id AS post_id, posts.title AS post_title, posts.content AS post_content, comments.id AS comment_id, comments.content AS comment_content, comments.author_name, comments.post_id
    FROM posts
    JOIN comments ON comments.post_id = posts.id
    WHERE posts.id = $1'
    sql_params = [post_id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)
    first_record = result_set[0]
    post = Post.new 
    post.id = first_record['post_id']
    post.title = first_record['post_title']
    post.content = first_record['post_content']

    result_set.each do |record|
      comment = Comment.new 
      comment.id = record['comment_id']
      comment.content = record['comment_content']
      comment.author_name = record['author_name']
      comment.post_id = record['post_id']

      post.comments << comment  
    end
    return post
  end
end