class Video < ActiveRecord::Base

  belongs_to :channel

  validates_presence_of :channel_id, :title

end
