require File.dirname(__FILE__) + '/../spec_helper'

describe "routes for Comments" do
  subject { get "/2010/11/32/test-a-slug/comments" }
  
  it "routes /:year/:month/:day/:slug/comments to :year/:month/:day/:slug" do
    subject.should redirect_to("/2010/11/32/test-a-slug")
  end
end