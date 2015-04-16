class Meme < ActiveRecord::Base
  has_attached_file :picture, styles: { thumb: '290x290>' }
  validates_attachment :picture,
                       presence: true,
                       content_type: { content_type: %r{\Aimage\/.*\Z} },
                       size: { in: 0..5.megabytes }

  scope :all_tags, -> (tags) { where('tags @> ARRAY[?]', tags) }
end
