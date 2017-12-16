module DigitalTransformationHelper
  def options_for(collection)

    capture do
      unless collection.empty?
        first = collection.shift
        concat(content_tag :option, first, value: "")
      end
      collection.each_with_index do |item, index|
        concat(content_tag :option, item, value: "#{index+1}")
      end
    end
  end
end
