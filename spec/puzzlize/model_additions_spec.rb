require "spec_helper"

describe "puzzlize" do
  describe "ModelAdditions" do
    it "should add in get the right attribute" do
      Puzzle.get_puzzlize_attribute_name.should == :puzzle
    end
  end
  
  describe "ModelInstanceMethods" do
    it "should include the following methods" do
      p = Puzzle.new
      methods = [:default_puzzle_image_path, :default_puzzle_image_url, :puzzle_images_urls, :puzzle_pieces_names, :make_puzzle, :single_piece, :piece_file_name, :all_piece]
      (p.methods & methods).should == methods
    end
    
    it "should get the right puzzle_pieces_names" do
      expected = ["puzzle_0-0", "puzzle_1-0", "puzzle_2-0", "puzzle_3-0", "puzzle_4-0", 
                  "puzzle_0-1", "puzzle_1-1", "puzzle_2-1", "puzzle_3-1", "puzzle_4-1", 
                  "puzzle_0-2", "puzzle_1-2", "puzzle_2-2", "puzzle_3-2", "puzzle_4-2", 
                  "puzzle_0-3", "puzzle_1-3", "puzzle_2-3", "puzzle_3-3", "puzzle_4-3", 
                  "puzzle_0-4", "puzzle_1-4", "puzzle_2-4", "puzzle_3-4", "puzzle_4-4"]
      p = Puzzle.new
      p.vertical_pieces = 5
      p.horizontal_pieces = 5
      p.puzzle_pieces_names.should == expected
    end
  
  end
end