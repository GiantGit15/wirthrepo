class PhotosetController < UICollectionViewController

  attr_accessor :data, :header

  def self.new(args = {})
    layout = UICollectionViewFlowLayout.alloc.init
    self.alloc.initWithCollectionViewLayout(layout)
  end

  def viewDidLoad
    super

    # If we don't have an event stored we open the settings screen
    # instead of going any further with this one.
    #
    unless Event.get
      App.delegate.open_settings
      return
    end

    hide_status_bar
    init_nav

    @album ||= PhotoDataSource.new

    rmq.stylesheet = PhotosetControllerStylesheet

    collectionView.tap do |cv|
      cv.registerClass(PhotosetCell, forCellWithReuseIdentifier: @album.photoset_cell_id)
      cv.registerClass(PhotosetFooter, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: @album.photoset_footer_id)
      cv.delegate = self
      cv.dataSource = @album
      cv.allowsSelection = true
      cv.allowsMultipleSelection = false
      rmq(cv).apply_style :collection_view
    end

    @footer = rmq.append(UIView, :main_footer).get

    @header = rmq.append(MainHeader, :main_header).get
    @header.create_icons(Event.icons)

    @print_modal = rmq.append(PrintModal, :print_modal).hide.on(:tap) do |sender|
      rmq(sender).hide
    end.get

    @loading_modal = rmq.append(LoadingModal).hide.get

    @zoom = rmq.append(ZoomView, :zoom_view).hide.get

    @refreshControl = UIRefreshControl.alloc.init
    @refreshControl.addTarget(self, action: "refreshControlAction", forControlEvents: UIControlEventValueChanged)
    self.collectionView.addSubview(@refreshControl)
    self.collectionView.alwaysBounceVertical = true

  end

  def hide_status_bar
    UIApplication.sharedApplication.setStatusBarHidden(true, animated:false)
  end

  def viewWillAppear(animated)
    super
    fetch_data
  end

  def viewWillDisappear(animated)
    super
  end

  # Remove if you are only supporting portrait
  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAll
  end

  def prefersStatusBarHidden
    true
  end

  def init_nav
    self.title = 'Photos'
    self.navigationController.setNavigationBarHidden(true)
  end

  def refreshControlAction
    beginRefreshingCollecitonView
    fetch_data #this should call  @refreshControl.endRefreshing upon completion
  end

  def beginRefreshingCollecitonView
    @refreshControl.beginRefreshing
    if self.collectionView.contentOffset.y == 0
      UIView.animateWithDuration(
        0.25,
        delay:0,
        options: UIViewAnimationOptionBeginFromCurrentState,
        animations: lambda{
          self.collectionView.contentOffset = CGPointMake(-14, -@refreshControl.frame.size.height)
        },
        completion: lambda{ |finished| }
      )
    end
  end

  def endRefreshingCollectionView
    @refreshControl.endRefreshing
    self.collectionView.setContentOffset(CGPoint.new(-14, 0), animated:true)
  end


  def fetch_data

    unless Event.get
      endRefreshingCollectionView
      return
    end

    Photo.fetch(
      {
        completed: lambda {
          endRefreshingCollectionView
        }
      }
    ) do |list|

      new_items = list.select do |x|
        @album.has_photo_with_id?(x["id"]) == false
      end

      if new_items.count > 0
        new_items.each { |datapoint| @album.add_data_point datapoint }
        self.collectionView.reloadData
      else
        NSLog("fetched data is nothing new")
      end
    end

  end

  def numberOfSectionsInCollectionView(view)
    1
  end

  def collectionView(view, didSelectItemAtIndexPath: index_path)
    photo = @album.toggle_selected(index_path)
    @zoom.open_photo(photo)
    @header.disable_or_enable_icons(@album.something_selected?)
  end

  def open_settings
    App.delegate.open_settings
  end

  def print_selected

    if @album.something_selected?
      @album.selected_photo.print
      show_print_modal
    else
      rmq.append(PlainModal, :plain_modal).get.text = "SELECT A PHOTO TO PRINT"
    end

  end

  def show_print_modal

    clean_slate

    rmq(@print_modal).animations.fade_in(
      {
        duration: 0.5,
        completion: -> (did_finish, q) {
          rmq(@print_modal).animations.fade_out(
            {
              delay: 1.5,
              duration: 2.0
            }
          )
        }
      }
    )
  end

  # clear the popup view and deselect photos
  def clean_slate
    @zoom.close
    deselect_all
  end

  def deselect_all
    @album.clear_selected
    @header.disable_or_enable_icons(@album.something_selected?)
  end

  def refresh_signout_clear_jump

    deselect_all

    UIView.animateWithDuration(
      0,
      delay:0,
      options: UIViewAnimationOptionBeginFromCurrentState,
      animations: lambda{
        self.collectionView.setContentOffset(CGPointMake(-14, 0), false)
      },
      completion: lambda{ |finished|
        @refreshControl.sendActionsForControlEvents(UIControlEventValueChanged)
      }
    )

    # Kill the zoom
    @zoom.close
  end

  # Open the SharesController and pass in the photo and the maner in
  # which it wants to be shared.
  #
  def share_photo(share_type)
    controller = SharesController.new(@album.selected_photo, share_type)
    controller.parent_controller = self
    navigationController.pushViewController(controller, animated: true)
  end


end

__END__

