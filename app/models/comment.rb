class Comment < ActiveRecord::Base
  DEFAULT_LIMIT = 15

  attr_accessible       :body, :post, :author_name
  
  attr_accessor         :openid_error
  attr_accessor         :openid_valid

  belongs_to            :post
  belongs_to            :author, :class_name => 'User'

  before_save           :apply_filter
  after_save            :denormalize
  after_destroy         :denormalize

  validates_presence_of :body, :post

  validate :open_id_error_should_be_blank, :author_name_or_user

  def open_id_error_should_be_blank
    errors.add(:base, openid_error) unless openid_error.blank?
  end
  
  def author_name_or_user
    
    errors.add_on_blank :author_name if author.nil?
  end

  def apply_filter
    self.body_html = Lesstile.format_as_xhtml(self.body, :code_formatter => Lesstile::CodeRayFormatter)
  end

  def trusted_user?
    false
  end

  def user_logged_in?
    false
  end

  def approved?
    true
  end

  def denormalize
    self.post.denormalize_comments_count!
  end

  def destroy_with_undo
    undo_item = nil
    transaction do
      self.destroy
      undo_item = DeleteCommentUndo.create_undo(self)
    end
    undo_item
  end

  # Delegates
  delegate :title, :to => :post, :prefix => true, :allow_nil => true
  delegate :label, :to => :author, :prefix => true, :allow_nil => true

  class << self
    def new_with_filter(params)
      comment = Comment.new(params)
      comment.created_at = Time.now
      comment.apply_filter
      comment
    end

    def build_for_preview(params)
      comment = Comment.new_with_filter(params)
      comment
    end

    def find_recent(options = {})
      find(:all, {
        :limit => DEFAULT_LIMIT,
        :order => 'created_at DESC'
      }.merge(options))
    end
  end
end
