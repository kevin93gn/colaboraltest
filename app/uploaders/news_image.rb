class NewsImage < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :fog
  process :resize_to_fill => [260, 260]

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end