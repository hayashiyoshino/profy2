class TopController < ApplicationController

  def index
    @question = Question.new
    @questions = current_user.group.questions
    #アソシエーションを利用して同じグループの質問を全て取得している。Groupモデルのアソシエーションのオプションに->{order("created_at DESC")}をしているためcreated_atでソートされて取得できる
  end

end
