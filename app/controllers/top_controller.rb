class TopController < ApplicationController

  def index
    @question = Question.new
    @feed_contents = current_user.group.feed_contents.includes(:content).page(params[:page]).per(5)
    @feed_contents_resource = @feed_contents.map(&:content)
  end
  #５行目：current_user.group.feed_contentsで、ログインユーザーの所属グルーpのfeed_contentsを全て取得している。ここまでは通常のアソシエーションのみ。.includes(:content)のところで、ポリモーフィック先のインスタンスを先読みすることでN+1問題が起きることを防止している。includeメソッドはポリモーフィック関連名を引数に取ることもできる。

  #６行目：mapメソッドを利用してFeedContentクラスのインスタンス配列をポリモーフィック関連先のインスタンスの配列に変換している。mapメソッドやeachメソッドなど、配列の中身を受け取り順番に処理するときは{|object|object.method}の代わりに(&:method)とシンプルに記述することができる。
end
