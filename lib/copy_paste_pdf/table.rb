module CopyPastePDF
  class Table < Array
    # Removes all empty rows from the table.
    def remove_empty_rows!
      reject! do |row|
        row.all?(&:nil?)
      end
    end

    # Copies the values of the given cells from a line to any following lines
    # whose corresponding cells are empty.
    #
    # @param [Array] indices the cell indices to copy
    # @yieldparam [Array] row a row in the table
    # @yieldreturn [Boolean] whether to skip the row from the table
    # @raise if a destination has no source
    # @raise if a destination cell has a value
    # @raise if a row is neither a source nor a destination
    def copy_into_cell_below(*indices)
      source = nil
      each do |row|
        if !block_given? || !yield(row)
          values = row.values_at(*indices)
          case values.count(&:nil?)
          when 0
            source = values
          when indices.size
            if source
              indices.each_with_index do |index,i|
                if row[index]
                  raise "#{index} contains #{row[index]}"
                else
                  row[index] = source[i]
                end
              end
            else
              raise "#{row} has no source"
            end
          else
            raise "#{row} is neither a source nor a destination"
          end
        end
      end
    end

    # Merges the values of the given cells from a line, whose other cells are 
    # empty, into the corresponding cells of the prececeding line.
    #
    # @param [Array] indices the cell indices to merge
    # @raise if a destination cell is empty
    def merge_into_cell_above(*indices)
      each_with_index.reverse_each do |row,i|
        if row.each_with_index.all?{|value,j| value.nil? || indices.include?(j)}
          indices.each do |index|
            if self[i - 1][index]
              self[i - 1][index] = "#{self[i - 1][index]}\n#{row[index]}"
            else
              raise "#{index} is empty"
            end
          end
          delete_at(i)
        end
      end
    end
  end
end
