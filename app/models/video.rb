class Video < ActiveRecord::Base

  belongs_to :channel

  validates_presence_of :channel_id

  # Test para ejecutar desde un scheduller
  class << self
    def check_thumbnails
      Video.all.each do |video|
        puts("Video con id " + video.id.to_s) if video.thumbnail.nil?
      end
    end
  end

end
