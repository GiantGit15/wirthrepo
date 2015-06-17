# Implementing the UICollectionViewDataSource Protocol see
# https://developer.apple.com/library/iOs/documentation/UIKit/Reference/UICollectionViewDataSource_protocol/Reference/Reference.html#//apple_ref/doc/uid/TP40012175


class PhotoDataSource

  PHOTOSET_CELL_ID = "PhotosetCell"
  PHOTOSET_FOOTER_ID = "SectionFooter"

  def photoset_cell_id
    PHOTOSET_CELL_ID
  end

  def photoset_footer_id
    PHOTOSET_FOOTER_ID
  end


  def initialize
    @data = [{items: [] }]
    @photos = {}

    @selected_photo = nil
    @selected_index_path = nil
  end

  def collectionView(view, numberOfItemsInSection: section)
    @data[section][:items].count || 0
  end

  def collectionView(view, cellForItemAtIndexPath: index_path)
    view.dequeueReusableCellWithReuseIdentifier(PHOTOSET_CELL_ID, forIndexPath: index_path).tap do |cell|
      rmq.build(cell) unless cell.reused
      photo = get_photo_by_index_path(index_path)
      cell.photo = photo
    end
  end

  def collectionView(clv, viewForSupplementaryElementOfKind:kind, atIndexPath:path)
    if kind == UICollectionElementKindSectionFooter
      clv.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:PHOTOSET_FOOTER_ID, forIndexPath:path).tap do |footer|
        rmq.build(footer) unless footer.reused
      end
    end
  end

  def empty_data
    @data = [{items:[]}]
  end

  def data
    @data.first[:items]
  end

  def has_photo_with_id?(id)
    @photos.has_key?(id)
  end

  def data= dat
    @data = dat
  end

  def add_data_point data_point
    @photos[data_point["id"]] ||= Photo.new(data_point["id"], data_point)
    data.insert(0, data_point)
  end

  def remove_data_point data_point
    @photos[data_point["id"]] = nil
  end

  def get_photo_by_id id
    @photos[id]
  end

  def get_photo_by_index_path index_path
    get_photo_by_id( get_item(index_path)["id"] )
  end

  def get_item(index_path)
    @data[index_path.section][:items][index_path.row]
  end

  ##
  # Selecting photos
  #
  #

  def select(photo, index_path)
    @selected_photo = photo
    @selected_index_path = index_path
    photo.selected = true
  end

  def deselect(photo)
    index_path = @selected_index_path
    photo.selected = false
    clear_selected
  end

  def selected?(id)
    @selected_photo && @selected_photo.id == id
  end

  def toggle_selected(index_path)
    photo = get_photo_by_index_path(index_path)
    if selected?(photo.id)
      deselect(photo)
    else
      select(photo, index_path)
    end
    photo
  end

  def clear_selected
    @selected_photo = nil
    @selected_index_path = nil
  end

  def something_selected?
    !@selected_photo.nil?
  end

  def selected_photo
    @selected_photo
  end

end
