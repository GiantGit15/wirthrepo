class Event < ActiveRecord::Base
  has_many :photosets, dependent: :destroy
  has_many :photos, through: :photosets

  #before_create :set_defaults
  #before_validation(on: :create) do
  before_validation do
    self.set_defaults
  end

  validates :branded_image_width, presence: true, numericality: { only_integer: true }
  validates :branded_image_height, presence: true, numericality: { only_integer: true }
  validates :display_image_width, presence: true, numericality: { only_integer: true }
  validates :display_image_height, presence: true, numericality: { only_integer: true }
  validates :print_image_width, presence: true, numericality: { only_integer: true }
  validates :print_image_height, presence: true, numericality: { only_integer: true }

  validates :smugmug_album, presence: true, if: :option_smugmug

  validates :photos_in_set, numericality: { only_integer: true, greater_than_or_equal_to: 4 }, if: :gif_mode

  validate :smugmug_must_be_enabled_if_gif_and_facebook
  validate :gifs_cannot_have_multiple_orientations

  validates :option_smugmug, :option_email, :option_facebook, :option_twitter, :inclusion => {:in => [true, false]}

  # Validations
  #
  def smugmug_must_be_enabled_if_gif_and_facebook
    if gif_mode? && option_facebook? && !option_smugmug?
      errors.add(:option_facebook, "Smugmug must be enabled to share a gif over facebook")
    end
  end

  def gifs_cannot_have_multiple_orientations
    if gif_mode? && multiple_orientations?
      errors.add(:multiple_orientations, "Gifs cannot have multiple orientations")
    end
  end
  #

  def self.latest
    order(updated_at: :desc).limit(1).first
  end

  def last_updated
    self.photos.order(updated_at: :desc).first.try(:updated_at).to_i
  end

  def latest_photoset
    photosets.order(created_at: :desc).limit(1).first || photosets.create
  end

  def gif_mode?
    self.gif_mode ? true : false
  end

  def orientation
    if self.multiple_orientations
      :none
    else
      branded_image_width.to_f / branded_image_height.to_f < 1 ? :portrait : :landscape
    end
  end

  def activate
    # Firstly deavtivate all other events. 'There can be only one'
    Event.where(active:true).each do |event|
      event.deactivate
    end

    self.active = true
    save
  end

  def deactivate
    self.active = false
    save
  end

  def set_default(attr, &block)
    send("#{attr}=", block.call) if send("#{attr}").nil?
  end

  def set_defaults

    set_default(:gif_mode) { false }
    set_default(:photos_in_set) { ENV["MAX_PHOTOS_IN_SET"] }

    set_default(:multiple_orientations) { false }
    set_default(:branded_image_width) { ENV["BRANDED_IMAGE_WIDTH"] }
    set_default(:branded_image_height) { ENV["BRANDED_IMAGE_HEIGHT"] }
    set_default(:display_image_width) { ENV["DISPLAY_IMAGE_WIDTH"] }
    set_default(:display_image_height) { ENV["DISPLAY_IMAGE_HEIGHT"] }
    set_default(:print_image_width) { ENV["PRINT_IMAGE_WIDTH"] }
    set_default(:print_image_height) { ENV["PRINT_IMAGE_HEIGHT"] }

    set_default(:option_smugmug) { false }
    set_default(:smugmug_album) { ENV["SMUGMUG_ALBUM_TITLE"] || "" }

    set_default(:option_email) { true }
    set_default(:copy_email_subject) { ENV["SHARE_COPY_EMAIL_SUBJECT"] }
    set_default(:copy_email_body) { ENV["SHARE_COPY_EMAIL_BODY"] }

    set_default(:option_print) { true }

    set_default(:option_facebook) { gif_mode ? false : true }
    set_default(:copy_social) { ENV["SHARE_COPY_SOCIAL"] }

    set_default(:option_twitter) { true }
    set_default(:copy_twitter) { ENV["SHARE_COPY_TWITTER"] }
  end

end
