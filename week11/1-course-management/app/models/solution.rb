class Solution < ActiveRecord::Base
	validates :text_block, presence: true

	belongs_to :task
end