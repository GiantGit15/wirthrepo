module RubyMotionQuery
  class RMQ

    def remove_tags(*tag_or_tags)
      selected.each do |view|
        tag_or_tags.each do |tag|
          view.rmq_data.tags.delete(tag)
        end
      end
      self
    end

    def toggle_tag(tag)
      selected.each do |view|
        if view.rmq_data.tags.include? tag
          view.rmq_data.tags.delete tag
        else
          view.rmq_data.tag(tag)
        end
      end
    end

  end
end
