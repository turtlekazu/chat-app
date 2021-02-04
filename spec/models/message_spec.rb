require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#create' do
    before do
      @message = FactoryBot.build(:message)
    end

    it 'contentとimageが存在していれば保存できる' do
      expect(@message).to be_valid
    end

    it 'imageがあればcontentが空でも保存できること' do
      @message.image = nil
      expect(@message).to be_valid
    end

    it 'contentがあればimageが空でも保存できること' do
      @message.content = ""
      expect(@message).to be_valid
    end

    it 'contentとimageが空では保存できないこと' do
      @message.image = nil
      @message.content = ""
      @message.valid?
      expect(@message.errors.full_messages).to include("Content can't be blank")
    end

    it 'roomが紐づいていないと保存できないこと' do
      @message.room = nil
      @message.valid?
      expect(@message.errors.full_messages).to include("Room must exist")
    end

    it 'userが紐づいていないと保存できないこと' do
      @message.user = nil
      @message.valid?
      expect(@message.errors.full_messages).to include("User must exist")
    end
  end
end
