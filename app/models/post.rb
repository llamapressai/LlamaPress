class Post < ApplicationRecord
  belongs_to :page, optional: true
  belongs_to :user

  validates :user_id, presence: true # A post must have a user.

  # This renders the page content that includes the post, with the post content embedded in it's associated page content.
  # This is so users can have a page that acts as a template for different types of posts.
  # The page saves a placeholder for the post content like this: {{post}}, and the post content is embedded in the page content using this method.
  def render_content
    content = self.page&.render_content
    post_content = self.content.to_s
    content_with_post = content.present? ? content.gsub("{{post}}", post_content) : post_content
    return content_with_post
  end

  def summarized_content
    content = self.content
    return content.present? ? content.gsub(/<[^>]*>/, '').squish : content
  end
end
