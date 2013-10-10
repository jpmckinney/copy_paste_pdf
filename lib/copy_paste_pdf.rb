require 'copy_paste_pdf/table'

module CopyPastePDF
  class Error < StandardError; end
  class CopyToNonEmptyCellError < Error; end
  class MissingSourceError < Error; end
  class InvalidRowError < Error; end
  class MergeWithEmptyCellError < Error; end
end