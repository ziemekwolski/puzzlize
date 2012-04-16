require "spec_helper"


describe "Cutter" do
  it "test should store size of piece" do
    cutter = Puzzlize::Cutter.new
    cutter.piece_size = 20
    cutter.piece_size.should == 20
  end

  it "test should store size of image" do
    cutter = Puzzlize::Cutter.new
    cutter.image_width = 20
    cutter.image_height = 100
    cutter.image_width.should == 20
    cutter.image_height.should == 100
  end

  it "test determine number of horizontal pieces" do
    cutter = Puzzlize::Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 100

    cutter.horizontal_pieces.should ==  2
    cutter.vertical_pieces.should == 5
  end

  it "test determine connector size" do
    #connector should be 20% or the size of the piece
    cutter = Puzzlize::Cutter.new
    cutter.piece_size = 20
    cutter.connector_size.should == 4
  end

  it "test determine connector radius" do
    #connector should be 20% or the size of the piece
    cutter = Puzzlize::Cutter.new
    cutter.piece_size = 20
    cutter.connector_radius.should == 2
  end

  it "test should return the 4 positions of the first square" do
    # the piece need to overlap so that we can correctly match the connectors.
    cutter = Puzzlize::Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 40
  
    cutter.get_piece_matrix.should == [[0,0, 22, 22], [18, 0, 22, 22], [0, 18, 22,22], [18, 18, 22 , 22]]
  end

  it "test return points for a given piece" do
    #note: I think this is faulty - there is not enough overlap.
    cutter = Puzzlize::Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 40
  
    cutter.piece_points(0, 0).should == [0,0, 22, 22]
    cutter.piece_points(1, 0).should == [18, 0, 22, 22]
    cutter.piece_points(0, 1).should == [0, 18, 22, 22]
    cutter.piece_points(1, 1).should == [18, 18, 22 , 22 ]

    cutter.piece_points(0, 0, false).should == [0,0, 20, 20]
    cutter.piece_points(1, 0, false).should ==  [20, 0, 20, 20]
    cutter.piece_points(0, 1, false).should == [0, 20, 20,20]
    cutter.piece_points(1, 1, false).should == [20, 20, 20 , 20 ] 
  
    cutter = Puzzlize::Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 60
    cutter.image_height = 60
  
    cutter.piece_points(0, 0).should == [0,0, 22, 22] 
    cutter.piece_points(1, 0).should == [18, 0, 24, 22] 
    cutter.piece_points(2, 0).should == [38, 0, 22, 22] 
  
    cutter.piece_points(0, 1).should == [0, 18, 22, 24] 
    cutter.piece_points(1, 1).should == [18, 18, 24 , 24 ] 
    cutter.piece_points(2, 1).should == [38, 18, 22 , 24 ] 
  
    cutter.piece_points(0, 2).should == [0, 38, 22 , 22 ] 
    cutter.piece_points(1, 2).should == [18, 38, 24 , 22 ] 
    cutter.piece_points(2, 2).should == [38, 38, 22 , 22 ] 
  end

  it "test determine the radius of the connector" do
    cutter = Puzzlize::Cutter.new
    cutter.piece_size = 20
    cutter.connector_radius.should == 2
  end

  it "test should return connector locations give a piece" do
  
    #       2
    #   *********
    # 3 *       * 4
    #   *       *
    #   *********
    #       1

    # because these points will be applied to individual cut up images, 
    # I don't need the points as they relate to the full image. 
    # I only need the points as they relate to the cut image, but
    # you need to account for the overlap aka buffer for the connectors.
    # remember connector radius and overlap is 2px not 4px.
  
    cutter = Puzzlize::Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 40
  
               # [10,0], [10, 20], [0, 10], [20, 10]
    cutter.connector_locations(0, 0).should == [nil, [10, 20], nil, [20, 10]]
    cutter.connector_locations(1, 0).should == [nil, [12, 20], [2, 10], nil]
    cutter.connector_locations(0, 1).should == [[10, 2], nil, nil, [20, 12]]
    cutter.connector_locations(1, 1).should == [[12, 2], nil, [2, 12], nil]
  
    cutter = Puzzlize::Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 60
    cutter.image_height = 60
  
               # [10,0], [10, 20], [0, 10], [20, 10]
    cutter.connector_locations(0, 0).should == [nil, [10, 20], nil, [20, 10]]
    cutter.connector_locations(1, 0).should == [nil, [12, 20], [2, 10], [22,10]]
    cutter.connector_locations(2, 0).should == [nil, [12, 20], [2, 10], nil]

    cutter.connector_locations(0, 1).should == [[10,2], [10, 22], nil, [20, 12]]
    cutter.connector_locations(1, 1).should == [[12,2], [12, 22], [2, 12], [22, 12]]
    cutter.connector_locations(2, 1).should == [[12,2], [12, 22], [2, 12], nil]

    cutter.connector_locations(0, 2).should == [[10,2], nil, nil, [20, 12]]
    cutter.connector_locations(1, 2).should == [[12,2], nil, [2, 12], [22, 12]]
    cutter.connector_locations(2, 2).should == [[12,2], nil, [2, 12], nil]
  end

  it "test should get points for the rectangle for the transperant piece giving a place" do
    # Again, I don't need the rectangles that apply to the image as a whole, only
    # the rectangles that relate to each individual piece. 
  
    cutter = Puzzlize::Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 60
    cutter.image_height = 60
 
  
      #       2
      #   *********
      # 3 *       * 4
      #   *       *
      #   *********
      #       1

    cutter.rectangle_locations(0, 0).should == [nil, [0, 20, 22, 22], nil, [20, 0, 22, 22]]
    cutter.rectangle_locations(1, 0).should == [nil, [0, 20, 24, 22], [0, 0, 2, 22], [22, 0, 24, 22]]
    cutter.rectangle_locations(2, 0).should == [nil, [0, 20, 22, 22], [0, 0, 2, 22], nil]

    # here I have to account for the buffer space at the bottom as well as the top so 
    # all the points are raised.
    cutter.rectangle_locations(0, 1).should == [[0, 0, 22, 2], [0, 22, 22, 24], nil, [20, 0, 22, 24]]
    # image is now 24 pixel wide cause, it's in the center of the image, not bound by anything. -- we need the buffer
    cutter.rectangle_locations(1, 1).should == [[0,0, 24, 2], [0, 22, 24, 24], [0, 0, 2, 24], [22, 0, 24, 24]]
    cutter.rectangle_locations(2, 1).should == [[0,0, 22, 2], [0, 22, 22, 24], [0, 0, 2, 24], nil]

    cutter.rectangle_locations(0, 2).should == [[0,0, 22, 2], nil, nil, [20, 0, 22, 22]]
    cutter.rectangle_locations(1, 2).should == [[0,0, 24, 2], nil, [0, 0, 2, 22], [22, 0, 24, 22]]
    cutter.rectangle_locations(2, 2).should == [[0,0, 22, 2], nil, [0, 0, 2, 22], nil]
  end

  it "test should determine connector type" do
    # CONNECTOR_TOP_PATTERN = [-1, -1 ,1]
    # CONNECTOR_RIGHT_PATTERN = [1, 1, -1]
  
    cutter = Puzzlize::Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 40
 
    cutter.connector_types(0,0).should == [nil, -1, nil, 1]
    cutter.connector_types(1,0).should == [nil, -1, -1, nil]
    cutter.connector_types(0,1).should == [1, nil, nil, 1]
    cutter.connector_types(1,1).should == [1, nil, -1, nil]
  end

  it "test should determine new size of image based on piece size" do
    cutter = Puzzlize::Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 65
  
    cutter.piece_fitting_diamentions.should == [0,0, 40, 60]
    cutter.image_width.should == 40
    cutter.image_height.should == 60
  end

end