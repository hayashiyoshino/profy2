class QuestionsController < ApplicationController
  def create
    Question.create(create_params)
    redirect_to :root and return
  end
  #redirect_to :rootを書くだけではアクション内の処理は終了せず次の行のコードを実行していってしまう。今回は下に続く処理がないので問題ないが、慣習的につけるようにした方が良い

  #今まではアクションにQuestion.create(text: create_params[:text], user_id: current_user.id, group_id: current_user.group_id)のようにハッシュのキーと値をそれぞれ書いていた。今回はmergeメソッドを使うことによってストロングパラメーターが生成される際にuser_idとgroup_idのキーと値をもつハッシュを追加する

  private
  def create_params
    params.require(:question).permit(:text).merge(user_id: current_user.id, group_id: current_user.group_id)
  end
end
