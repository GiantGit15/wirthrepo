FactoryGirl.define do

  base_folder = "#{Rails.root}/Test Project/sample_photos/Photo Event/Processed"

  factory :photo do
    original_path PNS.path_relative_to_project("#{base_folder}/Original/1.jpg")
    branded_path PNS.path_relative_to_project("#{base_folder}/Branded/1.jpg")
    display_path PNS.path_relative_to_project("#{base_folder}/Display/1.jpg")
    printing_path PNS.path_relative_to_project("#{base_folder}/Branded/1.jpg")
  end

end
