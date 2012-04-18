require "puzzlize/model_instance_methods"
module Puzzlize
  module ModelAdditions
    def puzzlize(attribute)
      include Puzzlize::ModelInstanceMethods
      @@puzzle_attribute_name = attribute
      
      # one of the main reason why this doesn't run off of after create is because paperclip callback hook is after_save.
      # since I use paper's medium image, we need to run after save.
      # Because I did not want to tightly integrate with paperclip, I did not use their callback hooks.
      after_save :make_puzzle
      
      def get_puzzlize_attribute_name
        @@puzzle_attribute_name
      end
    end
  end
end