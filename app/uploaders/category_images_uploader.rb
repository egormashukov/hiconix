class CategoryImagesUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  version :admin_large do

    process :resize_to_limit => [500, 500]

  end


  version :crop do

    process :crop

    process :crop_resize_to_fill

  end

  def crop_resize_to_fill

    resize_to_fill(model.crop_version[0], model.crop_version[1])

  end

  def crop

    if model.crop_x.present?

      resize_to_limit(500, 500)

        manipulate! do |img|

        x = model.crop_x.to_i

        y = model.crop_y.to_i

        w = model.crop_w.to_i

        h = model.crop_h.to_i

        img.crop("#{w}x#{h}+#{x}+#{y}")

        img

      end

    end

  end
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/hiconix_catalogue/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:

  version :admin_mini do
    process :resize_to_fill => [150, 100]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.

end
