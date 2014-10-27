# encoding: utf-8
module Prawn
  class Table
    class SplitCell

    def initialize(cell)
      @cell = cell
      @original_content = cell.content
      @content_array = cell.content.split(' ')
    end

    attr_accessor :cell

    def split(max_available_height)
      # prepare everything for the while loop
      # first we're gonna check if a single word fits the available space
      i = 0
      cell.content = @content_array[0]

      content_that_fits = ''
      while recalculate_height <= max_available_height
        # content from last round
        content_that_fits = content_old_page(i)
        break if @content_array[i].nil?
        i += 1
        cell.content = content_old_page(i)
      end
      
      split_content(content_that_fits, i)
      
      # recalcualte height for the cell in question
      recalculate_height(include_dummy_cells: true)

      return self
    end

    private

    def recalculate_height(options = {})
      new_height = cell.recalculate_height_ignoring_span

      if options[:include_dummy_cells] == true
        # if a height was set for this cell, use it if the text didn't have to be split
        # cell.height = cell.original_height if cell.content == old_content && !cell.original_height.nil?
        # and its dummy cells
        cell.dummy_cells.each do |dummy_cell|
          dummy_cell.recalculate_height_ignoring_span
        end      
      end

      return new_height
    end

    def split_content(content_that_fits, i)
      # did anything fit at all?
      if content_that_fits && content_that_fits.length > 0
        cell.content = content_that_fits
        cell.content_new_page = (cell.content_new_page  || '' ) + content_new_page(i)
      else
        cell.content = @original_content
      end
    end

    def content_old_page(i)
      @content_array[0..i].join(' ')
    end

    def content_new_page(i)
      @content_array[i..-1].join(' ')
    end
  end
end
end