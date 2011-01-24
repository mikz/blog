require File.dirname(__FILE__) + '/../../spec_helper'

describe PostsController do
  describe "route" do
    it 'generates destroy params' do
      {:delete => "/admin/session"}.should route_to(:controller => 'admin/sessions', :action => 'destroy')
    end
  end
end
