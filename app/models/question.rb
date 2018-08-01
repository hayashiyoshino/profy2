class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :answers
  has_one :feed_content, as: :content, dependent: :destroy

  validates_presence_of :user_id, :text, :group_id
  #validates_presence_ofで値が空でないか検証できる
  after_create :create_feed_content
  #コールバックでfeed_contentsもcreateしている

  def user_answer(user_id)
    Answer.find_by(user_id: user_id, question_id: id)
  end
  #find_byメソッドは検索条件に該当したレコードを１件だけ取得するメソッド。findメソッドがidのカラムに対してのみ検索をかけられるのに対し、find_byメソッドは検索条件として複数のカラムを指定できる。今回の例でいうと、answersテーブルからuser_idカラムの値が、引数として渡されている「現在ログインしているユーザーのid」と一致し、かつquestion_idカラムの値が「メソッドを呼び出した元の質問のid」と一致する回答を検索し取得している。
  #question_id: idのidという部分は、self.idのselfを省略した形。

  def answered?(user)
    answers.exists?(user_id: user.id)
  end
  #answered?メソッドでは引数としてユーザーを受け取り、そのユーザーのidがanswersテーブルのuser_idカラムで見つかればtrueを返り値とする。つまり、引数として渡されたuserがその質問に回答しているかどうかを確認できる。

   private
  def create_feed_content
    self.feed_content = FeedContent.create(group_id: group_id, updated_at: updated_at)
  end
end
