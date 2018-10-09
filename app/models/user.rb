class User < ActiveRecord::Base

  #accessor
  attr_accessor :group_key

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable,
         authentication_keys: [:email, :group_key]
         #承認を行いたいキーを変更する場合は、:authentication_keysに指定するキーを変更する。今回の場合は:emailに加えて:group_keyを追加している。これにより認証に:group_keyが使われるようになる。

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>"}
  validates_attachment_content_type :avatar, content_type: ["image/jpg","image/jpeg","image/png"]

  #association
  belongs_to :group
  has_many :questions, ->{ order("created_at DESC") }
  has_many :answers, ->{ order("updated_at DESC") }
  has_many :answerd_questions, through: :answers, source: :question
  #has_many :answerd_questions, through: :answers, source: :questionのアソシエーション定義では「自分の回答した質問」を取得している。
  #sourceオプションは関連テーブル(answers)から先のモデルにアクセスするための関連名を指定している。今回はanswersテーブルを通し、questionsテーブルの情報を取得しているので:questionを指定している。アソシエーションの「名前と関連先テーブルが同じ名前の場合省略することもできる。今回の場合、has_many :questions というアソシエーション名にしてしまえばsourceオプションをかく必要はない。しかし、それだとUserとQuestionを紐付ける通常の１対多のアソシエーション定義と被ってしまうのでanswerd_questionという違う名前にしている。

  #validation
  before_validation :group_key_to_id, if: :has_group_key?
  #before_validationメソッドはバリデーションを行う前に実行したい処理を書くときに使う。group_key_to_idメソッドはhas_group_key?によりインスタンスがある時のみ発動する。

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    group_key = conditions.delete(:group_key)
    group_id = Group.where(key: group_key).first
    email = conditions.delete(:email)

    # devise認証を、複数項目に対応させる
    if group_id && email
      where(conditions).where(["group_id = :group_id AND email = :email",
        { group_id: group_id, email: email }]).first
    elsif conditions.has_key?(:confirmation_token)
      where(conditions).first
    else
      false
    end
  end
  #self.find_first_by_auth_conditionsメソッドはdeviseに定義されているメソッド。このメソッドはログインやアクセス時のユーザー認証時にユーザーのインスタンスを取得する役割を果たしている。今回のようにカスタマイズでもしない限り見ることはないが、８行目でモジュールを読み込んだことで自動的に読み込まれている。カスタマイズのためにはオーバーライド(再定義による上書き)をして使う。デフォルトではemailとパスワードでテーブルから検索するようになっているため、新たにgroup_idを検索条件に追加している。

  def name
    "#{family_name} #{first_name}"
  end

  def name_kana
    "#{family_name_kana} #{first_name_kana}"
  end

  def full_profile?
    avatar? && family_name? && first_name? && family_name_kana? && first_name_kana?
  end
  #ユーザー画像、姓名、姓名カナ、全てが登録されていないとfalseを返すメソッドになっている。
  #カラム名＋？とかくと、指定したカラムに値が存在しないとfalseを返すというActiveRecordの機能を利用した。

  private
  def has_group_key?
    group_key.present?
  end

  def group_key_to_id
    group = Group.where(key: group_key).first_or_create
    self.group_id = group.id
  end
  #groupテーブルのkeyカラムからgroup_keyと一致するインスタンスを取り出し(なければインスタンスを生成し)、自身nのgroup_idプロパティにそのidをセットしている。
end
