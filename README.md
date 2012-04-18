# Puzzlizer

## 	Description

This gem allows you to create a puzzle from an upload image by a user. It uses RMagic to cut up the images and they some query to allow the user to move the pieces 
around. There is a cutter library that is decoupled from RMagic rapper which will allow for easy replacement of type of Image Rapper used. I tested this plugin with 
paperclip, but you should be able to use any gem that stores the file location in the database.

##	Installation

Edit you gem file add puzzlize to it.

	```ruby
	gem "puzzlize"
	```
	
Alternatively you could install the gem your self:

	Console:
	gem install puzzlize

##	Usage

Before you start you will need to add a migration on the model that you want to use:

  ```ruby
  rails g migration add_puzzle_columns
  ```
  
Inside the migration you will need:

  ```ruby
  def self.up
    change_table :painting do |t|
      t.add_puzzlize_columns
    end
  end

  def self.down
    remove_puzzlize_columns :painting
  end
  ```
  
Inside your model you will need:

	```ruby
	class Painting < ActiveRecord::Base
	  # optional but use be placed here if used.
	  has_attached_file :image, {:styles => { :medium => "800x800>" }}.merge(PAPERCLIP_STORAGE_OPTIONS)
	  # end optional

	  puzzlize :image
	end
	```

If you are not using paperclip and your image object does not have access to `image.path(:medium)` and `image.url(:medium)` you can must simply overwritte these two methods in your model.

	```ruby
	class Painting < ActiveRecord::Base
	
  	def default_puzzle_image_url
  	  // Replacement code for --- image.url(:medium) ---
  	end

  	def default_puzzle_image_path
  	  // Replacement code for --- image.path(:medium) ---
  	end
  end
	```

in the view (I used a show):

	```ruby
	puzzlize_javascript_and_css(@painting)
	puzzlize_show_puzzle(@painting)
  ```
  
where @painting is model object.