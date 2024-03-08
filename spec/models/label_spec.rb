require 'rails_helper'

RSpec.describe 'ラベルモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:label) { FactoryBot.create(:label, user: user) }

    context 'ラベルの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        label.update(name: nil)
        expect(label).to be_invalid
        expect(label.errors.full_messages).to eq ["名前を入力してください"]
      end
    end

    context 'ラベルの名前に値があった場合' do
      it 'バリデーションに成功する' do
        expect(label).to be_valid
      end
    end
  end
end
