require File.dirname(__FILE__) + '/../../spec_helper'

describe "/posts/show.html" do
  include UrlHelper
  
  before(:each) do
    view.stub!(:enki_config).and_return(Enki::Config.default)

    mock_tag = mock_model(Tag,
      :name => 'code'
    )

    mock_comment = mock_model(Comment,
      :created_at              => 1.month.ago,
      :author_name             => "Don Alias",
      :body_html               => "A comment",
      :author                  => nil
    )

    mock_comment2 = mock_model(Comment,
      :created_at              => 1.month.ago,
      :author_name             => "Don Alias",
      :body_html               => "A comment",
      :author                  => nil
    )

    @post = mock_model(Post,
      :title             => "A post",
      :body_html         => "Posts contents!",
      :published_at      => 1.year.ago,
      :slug              => 'a-post',
      :approved_comments => [mock_comment, mock_comment2],
      :tags              => [mock_tag]
    )
    assign :post, @post
    assign :comment, Comment.new
  end

  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it "should render a post" do
    controller.request.path_parameters["id"] = 4
    render :template => "posts/show.html.haml"
  end
end
