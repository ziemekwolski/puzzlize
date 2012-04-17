module Puzzlize
  module ViewHelpers
  	def puzzlize_javascript_and_css(puzzle)
  	  droppable_function = puzzle.puzzle_pieces_names.collect do |name|

  			  		"$('#i-#{name}').draggable({helper:'original', handle:'.drag'}); 
  			  		$('#s-#{name} > .sensible').droppable({
  			  		 accept: '#i-#{name}',
  			  		 tolerance: 'intersect',
  			  		 activeClass: 'droppable-active',
  			  		 hoverClass: 'droppable-hover',
  			  		 drop: function() { 
  			  			$('#s-#{name}').addClass('s-#{name}');
  			  		 	$('#s-#{name}').addClass('encastrada');
  			  			$('#i-#{name}').remove();
  			  		 }
  			  		 });"
      end.join(" ")

      droppable_css = ""
      image_urls = puzzle.puzzle_images_urls
  		puzzle.puzzle_pieces_names.each_with_index do |name, index|
    		droppable_css += ".s-#{name} {
    			background-image:url(#{image_urls[index]});
    			background-repeat:no-repeat;
    			background-position:center center;
    		}"
    	end

      "<script type='text/javascript'>
  			  // Javascript library made by:
  			  // Fernando.com.ar 
  			  // http://www.fernando.com.ar/jquery-puzzle/index.php

  				$(document).ready(function(){
  				  #{droppable_function}
            });

  			</script>
  			<style type='text/css'>
        #{droppable_css}
  			.drag{
  				width:#{puzzle.horizontal_piece_size}px;
  				height:#{puzzle.vertical_piece_size}px;
  			}
  			.sensible{
  				width:#{puzzle.horizontal_piece_size}px;
  				height:#{puzzle.vertical_piece_size}px;
  				border:0px solid red;
  			}
  			#canvas{
  				width:#{puzzle.image_width}px;
  				height:#{puzzle.image_height}px;
  				background-color:#A5A5A5;
  				float:left;
  			}
  			#canvasFinal{
  				width:#{puzzle.image_width}px;
  				height:#{puzzle.image_height}px;
  				background-image:url(#{ puzzle.default_puzzle_image_url});
  				background-repeat:no-repeat;
  				background-position:center center;
  				float:left;
  				position:absolute;
  				display:none;
  				z-index:9;
  			}
  			</style>".html_safe
  	end

  	def puzzlize_show_puzzle(puzzle)
  	  puzzle_pieces_html = ""
  		puzzle.puzzle_pieces_names.each do |name|
    		puzzle_pieces_html += "
    		<div class='s-#{name} %> ' id='i-#{name}' style='width:#{puzzle.horizontal_piece_size}px; height:#{puzzle.vertical_piece_size}px; position:absolute; top:#{134 + rand(320)}px; left:#{rand(180)}px;' >
    		  <div class='drag'></div>
    		</div>"
  		end

     "<div>
        <div class='puzzle' style='width:660px;'>
          <div style='width:390px; height:450px; background-color:#FFF; float:left;'>
            #{puzzle_pieces_html}
          </div>
        </div>
      </div>".html_safe
  	end
  end
end