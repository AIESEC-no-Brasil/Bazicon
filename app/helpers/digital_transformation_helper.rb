module DigitalTransformationHelper
 def options_for(collection)

   capture do
     unless collection.empty?
       concat(content_tag :option, collection.first, value: "")
     end
     collection.each.with_index(1) do |item, index|
       unless index == 1
        concat(content_tag :option, item, value: "#{index}")
      end
     end
   end
 end 
end
