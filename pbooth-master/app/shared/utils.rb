module PBUtils
  module_function
  def dimensions_fill_to_parent_keep_ratio(ratio, parent_width, parent_height)
    if parent_height < (parent_width / ratio)
      { h: parent_height, w: parent_height * ratio }
    else
      { h: parent_width / ratio, w: parent_width }
    end
  end
end
