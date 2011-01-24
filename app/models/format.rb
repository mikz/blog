class Format < ActiveRecord::Base
  validates :class_name, :method, :name, :presence => true
  
  module Scopes
    def enabled
      where(:disabled => false)
    end
  end
  extend Scopes
  
  def format(text)
#    DEBUG {%w{CGI::unescapeHTML(text) text}}
    text = CGI::unescapeHTML(text)
    klass = class_name.constantize if class_name?
    text = klass.new(text).send(method) if klass.present?
    text
  end
  
  alias_method :process, :format
  
  def to_label
    (name? && class_name?)? %{#{name} (#{class_name})} : "none"
  end
  
  module PageMethods
    extend ActiveSupport::Concern
    SHORT_BODY_LENGTH = 100
    
    included do
      belongs_to :format
    end
    
    def short_body_html
      ::HTML_Truncator.truncate self.body_html, SHORT_BODY_LENGTH, "&hellip;"
    end
    
    def apply_filter
       self.body_html = EnkiFormatter.format_as_xhtml self.body, self.format
    end
  end
end