# Puzzlizer

## 	Description

Puzzlizer allows you to create a puzzle from an upload image. It uses RMagic to cut up the image and provides helper function to allows the user to move the pieces around to solve the puzzle. 

##	Installation

Edit you gem file add puzzlize to it.

```ruby
gem "puzzlize"
```
	
Alternatively you could install the gem yourself:

```ruby
console:
gem install puzzlize
```

##	Usage

Before you start you will need to add a migration on the model that you want to use:

```ruby
console:
rails g migration add_puzzle_columns
```
  
Inside the migration you will need (assuming that your model is Painting):

```ruby
def self.up
  change_table :paintings do |t|
    t.add_puzzlize_columns
  end
end

def self.down
  remove_puzzlize_columns :paintings
end
```
  
Inside your model you will need:

```ruby
class Painting < ActiveRecord::Base
  has_attached_file :image, {:styles => { :medium => "800x800>" }}.merge(PAPERCLIP_STORAGE_OPTIONS) <-- after paperclip
  puzzlize :image
end
```

If you are not using paperclip and your image object does not have access to `image.path(:medium)` and `image.url(:medium)` you can must overwritte these two methods in your model.

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

in the show/view:

```ruby
  puzzlize_javascript_and_css(@painting)
  puzzlize_show_puzzle(@painting)
```
  
where @painting is model object.