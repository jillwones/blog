require 'post_repository'

def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'blog_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_tables
  end

  it 'finds a post and relevant comments' do 
    repo = PostRepository.new

    post = repo.find_with_comments(1)

    expect(post.title).to eq('First Blog Post')
    expect(post.content).to eq('bad blog')

    expect(post.comments.length).to eq(3)
    expect(post.comments.first.author_name).to eq('bob')
  end
end