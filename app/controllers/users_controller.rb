class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    current_user.update(update_params)
  end

  private
  def update_params
    params.require(:user).permit(:family_name, :first_name, :family_name_kana, :first_name_kana, :avatar)
  end
  #requireメソッドはストロングパラメーターのメソッド。利用することでparamsのハッシュの中で利用するキーを制限することができる。params.require(:user)とすることでuserキー以下のパラメーターのみを取得することができる。requireを指定することで不要なパラメーターを受け取ることを防げる。
end
