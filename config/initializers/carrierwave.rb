require 'fog/aws/storage'
require 'carrierwave'

CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => 'AKIAJCEMDWKPUAXFG52A', #Rails.application.secrets.access_key_id,                        # required
      :aws_secret_access_key  => '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',#Rails.application.secrets.secret_access_key,                        # required
      :region                 => 'sa-east-1',                  # optional, defaults to 'us-east-1'
      #:host                   => 's3.example.com',             # optional, defaults to nil
      #:endpoint               => 's3-website-sa-east-1.amazonaws.com' # optional, defaults to nil
  }
  config.fog_directory  = 'indovirtual'                          # required
  config.fog_public     = true                                        # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"} # optional, defaults to {}
end