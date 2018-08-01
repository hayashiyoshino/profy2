class Group < ActiveRecord::Base
  has_many :users
  has_many :questions, ->{ order("created_at DESC") }
  has_many :feed_contents, ->{ order("updated_at DESC") }
  #orderオプションは取得する順番を変更できるオプション。全てのオプションの前に記述する。
  #今回モデルで指定したorderオプションは->というlambda(ラムダ)気泡で指定されている。lambdaは匿名関数のことを指し、アソシエーションでオプションを指定する際に用いる。
end
