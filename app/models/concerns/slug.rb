module Slug
  extend ActiveSupport::Concern
  RESTRICTED_SLUG_NAMES = %w(index new session login logout users).freeze

  included do
    validates :slug, uniqueness: true, presence: true,
                     exclusion: { in: RESTRICTED_SLUG_NAMES }
    before_validation :generate_slug

    def to_param
      slug
    end

    private

    def generate_slug
      self.slug ||= name.parameterize
    end
  end
end
