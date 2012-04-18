require "spec_helper"

class Puzzle < SuperModel::Base
  extend Puzzlize::ModelAdditions
  puzzlize :puzzle  
  
  #patch for to avoid paperclip
  @@image_path_location = ""
  
  def default_puzzle_image_path
    @@image_path_location
  end
  
  def self.image_path_location=(path)
    @@image_path_location = path
  end
end

describe "puzzlize" do
  
  it "test should create a whole puzzle using a square image" do
    root = Dir.getwd
    Puzzle.image_path_location = "#{root}/spec/support/made/simple_sample.jpg"
    img_handle = Puzzle.new({:image => File.new(root + '/spec/support/simple_sample.jpg')})
    img_handle.save.should == true
    id = img_handle.id.to_s
    4.times do |x|
      4.times do |y|
        File.size(File.join(root, "spec", "support", "made", "simple_sample-#{x}_#{y}.gif")).to_s.should == File.size(File.join(root, "spec", "support", "correct", "simple_sample-#{x}_#{y}.gif")).to_s
      end
    end
    `cd #{root}/spec/support/made/ && rm -rf simple_sample-*`
  end
  
  it "test should create a whole puzzle using regular photo" do
    root = Dir.getwd

    # instead adding paperclip to the test, we stub out the method that we usually use paperclip for.
    Puzzle.image_path_location = "#{root}/spec/support/made/regular_photo.jpg"
    img_handle = Puzzle.create!({:image => File.new(root + '/spec/support/regular_photo.jpg')})
    id = img_handle.id.to_s
    4.times do |x|
      2.times do |y|
        File.size(File.join(root, "spec", "support", "made", "regular_photo-#{x}_#{y}.gif")).to_s.should == File.size(File.join(root, "spec", "support", "correct", "regular_photo-#{x}_#{y}.gif")).to_s
      end
    end
    `cd #{root}/spec/support/made/ && rm -rf regular_photo-*`
  end
  
end