module Puzzlize
  module Schema
    @@schema = [
      :vertical_piece_size,
      :horizontal_piece_size,
      :vertical_pieces,
      :horizontal_pieces,
      :image_width,
      :image_height
    ]
    
    
    def add_puzzlize_columns
      @@schema.each do |column_name|
        column(column_name, :integer)
      end
    end
    
    def remove_puzzlize_columns(table_name)
      @@schema.each do |column_name|
        remove_column(table_name, column_name)        
      end
    end
  end
  
end