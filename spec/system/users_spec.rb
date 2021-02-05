require 'rails_helper'

RSpec.describe "ユーザーログイン機能", type: :system do

  it 'ログインしていない状態でトップページにアクセスした時、サインインページに移動する' do
    #トップページに遷移
    visit root_path
    #ログインしていない場合、サインインページに遷移していることを確認
    expect(current_path).to eq new_user_session_path
  end

  it 'ログインに成功し、トップページに遷移する' do
    #あらかじめユーザーをDBに保存
    user = FactoryBot.create(:user)
    #サインインページに移動
    visit new_user_session_path
    #ログインしていない場合、サインインページに遷移していることを確認
    expect(current_path).to eq new_user_session_path
    #すでに保存されているユーザーのemailとpasswordを確認
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    #ログインボタンをクリック
    click_on 'Log in'
    #トップページに遷移していることを確認
    expect(current_path).to eq root_path
  end

  it 'ログインに失敗し、サインインページに戻ってくる' do
    #あらかじめユーザーをDBに保存
    user = FactoryBot.create(:user)
    #トップページに遷移
    visit root_path
    #ログインしていない場合、サインインページに遷移
    expect(current_path).to eq new_user_session_path
    #誤ったユーザー情報を入力
    fill_in 'user_email', with: 'aaa@aaa'
    fill_in 'user_password', with: 'aaaaaa'
    #ログインボタンをクリック
    click_on 'Log in'
    #サインインページに戻っているを確認
    expect(current_path).to eq new_user_session_path
  end

end