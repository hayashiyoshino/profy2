class AnswersController < ApplicationController

  before_action :redirect, only: :new
  #ビューで条件によって表示を分けたことで、一度回答した質問には「回答する」ボタンは表示されなくなった。しかし一度回答した質問であっても直接/answers/new?question_id=1のようなパスにアクセスすることで回答できてしまう。そのためコントローラーで、一度回答したユーザーが直接回答画面にアクセスしてきた際にはホーム画面に遷移するように設定を行う。

  def new
    @question = Question.find(params[:question_id])
    @answer = Answer.new
    @answer.question_id = @question.id
  end
  #回答を新規登録する際には、その回答に対応するquestionのidも関連づけて保存したいため@answerのプロパティ値としてあらかじめセットしている。
  def create
    @answer = Answer.create(create_params)
  end

  def edit
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def update
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @answer.update(update_params)
  end

  private
  def create_params
    params.require(:answer).permit(:question_id, :text).merge(user_id: current_user.id)
  end

  def redirect
    if Answer.exists?(question_id: params[:question_id], user_id: current_user.id)
      redirect_to :root
    end
  end

  def update_params
    params.require(:answer).permit(:text)
  end
end
