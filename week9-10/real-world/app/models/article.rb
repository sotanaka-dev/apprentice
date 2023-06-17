class Article < ApplicationRecord
  belongs_to :user

  def as_json_response(author)
    {
      slug:,
      title:,
      description:,
      body:,
      createdAt: created_at,
      updatedAt: updated_at,
      author: {
        username: author.username,
        bio: author.bio,
        image: author.image
      }
    }
  end
end
