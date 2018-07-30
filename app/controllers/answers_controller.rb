class AnswersController < ApplicationController

  def new
    @question = Question.find(params[:question_id])
    @answer = Answer.new
    @answer.question_id = @question.id
  end
  #回答を新規登録する際には、その回答に対応するquestionのidも関連づけて保存したいため@answerのプロパティ値としてあらかじめセットしている。
  def create
    @answer = Answer.create(create_params)
  end

  private
  def create_params
    params.require(:answer).permit(:question_id, :text).merge(user_id: current_user.id)
  end
end
