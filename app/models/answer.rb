class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_one :feed_content, as: :content, dependent: :destroy

  validates_presence_of :user_id, :text

  after_create :create_feed_content
  after_update :update_feed_content
  #チムラインを作成した際に設定したのと同様にafter_updateと回答に変更が加えられたタイミングでもコールバックを設定している。

  private
  def create_feed_content
    self.feed_content = FeedContent.create(group_id: question.group_id, updated_at: updated_at)
  end

  def update_feed_content
    self.feed_content.update(updated_at: updated_at)
  end
  #ここでのupdated_atは「self.updated_at」を省略した形で、コールバックが働いた際のレシーバーである回答の更新日時を表す。

end
