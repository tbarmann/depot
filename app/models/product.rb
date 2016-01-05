class Product < ActiveRecord::Base
	validates :title, :description, presence: true
	validates :price, numericality: {greater_than_or_equal_to: 0.01}
	validates :title, uniqueness: true
	validates :image_url, allow_blank: true, format: {
		with: %r{\.(gif|jpg|png)\Z}i,
		message: 'must be a URL for GIF, JPG, or PNG image.'
	}
	validates :title, length: {minimum: 10,
		too_short: "must have at least %{count} characters"
	}
end


