require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :products  # loads products.yml file
  test "product attributes title, description and price must not be empty" do
  	#binding.pry
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
  	assert product.errors[:price].any?
  #	assert product.errors[:image_url].any?
  end


	test "product price must be positive" do
		product = Product.new(title: "My Book Title",
			description: "yyy",
			image_url: "zzz.jpg"
			)
		product.price = -1
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"],
			product.errors[:price]

		product.price = 0
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"],
			product.errors[:price]

		product.price = 1
		assert product.valid?
	end


	def new_product(image_url)
		Product.new(title: "My book title",
			description: "yyy",
			price: 1,
			image_url: image_url
			)
	end

	def new_product2(attributes = {})
		attributes = {title: "My book title",description: "yyy",price: 1,image_url: "test.jpg"}.merge(attributes)
		Product.new(attributes)
	end


	test "image url" do
		ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.c.c/x/y/z/fred.gif}
		bad = %w{fred.doc fred.gif/more fred.gif.more}

		ok.each do |img_url|
			assert new_product2({image_url:img_url}).valid?, "#{img_url} should be valid"
		end
		bad.each do |img_url|
			assert new_product2({image_url:img_url}).invalid?, "#{img_url} shouldn't be valid"
		end
	end

	test "product is not valid without a unique title" do
		product = Product.new(title: products(:ruby).title,
					description: "yyy",
					price: 1,
					image_url: "fred.gif"
					)
		assert product.invalid?
		assert_equal ["has already been taken"], product.errors[:title]
	end

	test "product title must be at least 10 characters long" do
		too_short = %w{123456789 abc}
		just_right = %w{123456789A Even_longer_title}
		too_short.each do |title|
			assert new_product2({title:title}).invalid?, "#{title} shouldn't be valid"
		end
		just_right.each do |title|
			assert new_product2({title:title}).valid?, "#{title} should be valid"
		end


	end

end
