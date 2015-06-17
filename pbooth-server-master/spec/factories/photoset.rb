FactoryGirl.define do

  base_folder = "#{Rails.root}/Test Project/sample_photos/Gif Event/Processed"

  factory :photoset do
    factory :gif do
      branded_path PNS.path_relative_to_project("#{base_folder}/Gifs/Branded/1.gif")
      display_path PNS.path_relative_to_project("#{base_folder}/Gifs/Display/1.jpg")
      printing_path PNS.path_relative_to_project("#{base_folder}/Gifs/Print/1.jpg")

      after(:create) do |photoset|
        6.times do |n|
          create(:photo,
                 photoset: photoset,
                 original_path: PNS.path_relative_to_project("#{base_folder}/Original/#{n+1}.jpg"),
          branded_path: nil,
            display_path: nil,
            printing_path: nil
                )
        end
      end
    end
  end

end
