require 'rails_helper'

RSpec.describe 'メッセージ投稿機能' do
  before do
    @room_user = FactoryBot.create(:room_user)
  end

  context '投稿に失敗した時' do
    it '送る値が空の時' do
      #サインインする
      sign_in(@room_user.user)
      #作成されたチャットルームに遷移
      click_on(@room_user.room.name)
      #DBに保存されていないことの確認
      expect{click_on '送信'}.not_to change{Message.count}
      #元のページに戻ってくることの確認
      expect(current_path).to eq room_messages_path(@room_user.room)
    end
  end

  context '投稿に成功した時' do
    it 'テキストの投稿ができると、投稿一覧に遷移して、投稿内容が表示されている' do
      #サインインする
      sign_in(@room_user.user)
      #作成されたチャットルームに遷移
      click_on(@room_user.room.name)
      #値をテキストフォームに入力
      fill_in 'message_content', with: "aaa"
      #送信した値がDBに保存されていることを確認
      expect{click_on '送信'}.to change{Message.count}.by(1)
      #投稿一覧画面に遷移していることを確認
      expect(current_path).to eq room_messages_path(@room_user.room)
      #送信した値がブラウザに表示されていることの確認
      expect(page).to have_content("aaa")
    end

    it '画像の投稿ができると、投稿一覧に遷移して、投稿した画像が表示されている' do
      #サインインする
      sign_in(@room_user.user)
      #作成されたチャットルームに遷移
      click_on(@room_user.room.name)
      #添付する画像の定義
      image_path = Rails.root.join('public/images/test_image.png')
      attach_file('message[image]', image_path, make_visible: true)
      #送信した値がDBに保存されていることを確認
      expect{click_on '送信'}.to change{Message.count}.by(1)
      #投稿一覧画面に遷移していることを確認
      expect(current_path).to eq room_messages_path(@room_user.room)
      #送信した画像がブラウザに表示されていることの確認
      expect(page).to have_selector('.message-image')
    end

    it 'テキストと画像両方の投稿に成功する' do
      #サインインする
      sign_in(@room_user.user)
      #作成されたチャットルームに遷移
      click_on(@room_user.room.name)
      #添付する画像の定義
      image_path = Rails.root.join('public/images/test_image.png')
      attach_file('message[image]', image_path, make_visible: true)
      #値をテキストフォームに入力
      fill_in 'message_content', with: "aaa"
      #送信した値がDBに保存されていることを確認
      expect{click_on '送信'}.to change{Message.count}.by(1)
      #投稿一覧画面に遷移していることを確認
      expect(current_path).to eq room_messages_path(@room_user.room)
      #送信した画像がブラウザに表示されていることの確認
      expect(page).to have_selector('.message-image')
      #送信した値がブラウザに表示されていることの確認
      expect(page).to have_content("aaa")
    end
  end
end