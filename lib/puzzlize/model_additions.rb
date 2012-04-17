require "puzzlize/model_instance_methods"
module Puzzlize
  module ModelAdditions
    def puzzlize(attribute)
      include Puzzlize::ModelInstanceMethods
      @@puzzle_attribute_name = attribute
      
      after_save :make_puzzle
      
      def get_puzzlize_attribute_name
        @@puzzle_attribute_name
      end
    end
  end
end