class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_one :feed_content, as: :content, dependent: :destroy
  # ポリモーフィックのアソシエーション。クラス名はfeed_content、ポリモーフィック関連名はcontent。feed_contentのcontent_id、content_typeカラムにanswerのid、answerのタイプ保存されるようにしている。


  validates_presence_of :user_id, :text
  # 値が空でないかのバリデーション


  after_create :create_feed_content
  # 回答がcreateされた後にfeed_contentもcreateされるようコールバックを設定している。
  after_update :update_feed_content
  #回答に変更が加えられたタイミングでもコールバックを設定している。こうすることで編集された投稿がタイムラインの一番上にくるようになる。

  private
  def create_feed_content
    self.feed_content = FeedContent.create(group_id: question.group_id, updated_at: updated_at)
  end

  def update_feed_content
    self.feed_content.update(updated_at: updated_at)
  end
  #ここでのupdated_atは「self.updated_at」を省略した形で、コールバックが働いた際のレシーバーである回答の更新日時を表す。

end
