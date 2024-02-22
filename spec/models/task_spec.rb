require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.new(title: nil, content: "Rails")
        expect(task).to be_invalid
        expect(task.errors.full_messages).to eq ["Title can't be blank"]
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.new(title: "Ruby", content: nil)
        expect(task).to be_invalid
        expect(task.errors.full_messages).to eq ["Content can't be blank"]
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = FactoryBot.create(:task)
        expect(task).to be_valid
      end
    end
  end
end
