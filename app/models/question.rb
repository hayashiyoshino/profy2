class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :answers
  validates_presence_of :user_id, :text, :group_id
  #validates_presence_ofで値が空でないか検証できる
end
