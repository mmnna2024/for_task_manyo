require 'rails_helper'

RSpec.describe 'ユーザモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    let!(:user1) { FactoryBot.create(:user, email: "user1@gmail.com") }

    context 'ユーザーの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        user1.update(name: nil)
        expect(user1).to be_invalid
        expect(user1.errors.full_messages).to eq ["名前を入力してください"]
      end
    end

    context 'ユーザーのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user1.update(email: nil)
        expect(user1).to be_invalid
        expect(user1.errors.full_messages).to eq ["メールアドレスを入力してください", "メールアドレスは不正な値です"]
      end
    end

    context 'ユーザーのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user1.update(password: nil)
        expect(user1).to be_invalid
        expect(user1.errors.full_messages).to eq ["パスワードを入力してください", "パスワードは6文字以上で入力してください"]
      end
    end

    context 'ユーザーのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
        user2 = User.new(name: "User2", email: "user1@gmail.com", password: "user2des")
        expect(user2).to be_invalid
        expect(user2.errors.full_messages).to eq ["メールアドレスはすでに使用されています"]
      end
    end

    context 'ユーザーのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user1.update(password: "12345")
        expect(user1).to be_invalid
        expect(user1.errors.full_messages).to eq ["パスワードは6文字以上で入力してください"]
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        expect(user1).to be_valid
      end
    end

  end
end
