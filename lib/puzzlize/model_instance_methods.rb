module Puzzlize
  module ModelInstanceMethods
    def default_puzzle_image_url
      self.send(self.class.get_puzzlize_attribute_name, :url, :medium)
    end

    def default_puzzle_image_path
      self.send(self.class.get_puzzlize_attribute_name, :path, :medium)
    end

    def puzzle_images_urls
      output = []
      self.vertical_pieces.to_i.times do |y_axis|
        self.horizontal_pieces.to_i.times do |x_axis|
          output << piece_file_name(x_axis, y_axis, self.default_puzzle_image_url)
        end
      end
      output
    end

    def puzzle_pieces_names
      output = []
      self.vertical_pieces.to_i.times do |y_axis|
        self.horizontal_pieces.to_i.times do |x_axis|
          output << "puzzle_#{x_axis}-#{y_axis}"
        end
      end
      output
    end

    def make_puzzle
      @file_location = self.default_puzzle_image_path
      @source_file = Magick::Image.read(@file_location).first
      @cutter = Puzzlize::Cutter.new
      @cutter.piece_size = (@source_file.columns * 0.25).to_i
      @cutter.image_width = @source_file.columns
      @cutter.image_height = @source_file.rows
      @source_file = @source_file.crop(*(@cutter.piece_fitting_diamentions + [true]))
      all_piece
      update_piece_information
    end
    
    # this is isolated because supermodel treats update_attributes the same as save
    # ActiveRecord does not do this.
    def update_piece_information
      self.update_attributes({
        :vertical_pieces => @cutter.vertical_pieces, 
        :horizontal_pieces => @cutter.horizontal_pieces, 
        :vertical_piece_size => @cutter.real_piece_size, 
        :horizontal_piece_size => @cutter.real_piece_size,
        :image_width => @cutter.image_width,
        :image_height => @cutter.image_height})
    end

    def single_piece(row_x, row_y)

      # get the source image and crop it to the appropriate size.
      bg = @source_file.crop(*(@cutter.piece_points(row_x, row_y) + [true]))

      # This will be the final image output
      img = Magick::Image.new(bg.columns,bg.rows)
      img.compression = Magick::LZWCompression

      # draw the image that is suppose to be invisible.
      gc = Magick::Draw.new
      gc.stroke_antialias(false)
      gc.stroke_width(0)

      # first start with black box.
      gc.fill('#000000')
      gc.rectangle(0,0,bg.columns, bg.rows)

      # draw rectangles around the edges of the images aka "buffers"
      # that will later be made transperant
      gc.fill('#09f700')
      @cutter.rectangle_locations(row_x, row_y).each do |a_rectangle|
        gc.rectangle(*a_rectangle) unless a_rectangle.nil?
      end

      # draw the up to 4 connectors
      connector_types = @cutter.connector_types(row_x, row_y)
      @cutter.connector_locations(row_x, row_y).each_with_index do |connector, index|
        unless connector.nil?
          gc.fill('#09f700') if connector_types[index] == -1
          gc.fill('#000000') if connector_types[index] == 1
          points = connector
          points << (connector[0] + @cutter.connector_radius)
          points << connector[1]
          gc.circle(*points)
        end
      end

      # draw the image and composite the background image (bg) and set the transparency.
      # Creating a cookie cutter affect.
      gc.draw(img)
      img = img.matte_replace((bg.columns / 2).to_i,(bg.rows / 2).to_i)
      img = bg.composite(img, Magick::CenterGravity, Magick::OverCompositeOp)
      img = img.transparent('#09f700')
      
      Rails.logger.debug { "[puzzle_maker] writing image to #{@file_location.sub(/\..*$/, "-#{row_x}_#{row_y}.gif")}".inspect } if defined? Rails
      img.write(piece_file_name(row_x, row_y, @file_location))
    end

    def piece_file_name(row_x, row_y, file_location)
      file_location.sub(/\..*$/, "-#{row_x}_#{row_y}.gif")
    end

    def all_piece
      @cutter.vertical_pieces.times do |y_axis|
        @cutter.horizontal_pieces.times do |x_axis|
          single_piece(x_axis, y_axis)
        end
      end
    end
  end
end