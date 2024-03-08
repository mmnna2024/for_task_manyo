require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:first_task) { FactoryBot.create(:task, user: user) }
  let!(:second_task) { FactoryBot.create(:second_task, user: user) }
  let!(:third_task) { FactoryBot.create(:third_task, user: user) }
  
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        first_task.update(title: nil)
        expect(first_task).to be_invalid
        expect(first_task.errors.full_messages).to eq ["タイトルを入力してください"]
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        first_task.update(content: nil)
        expect(first_task).to be_invalid
        expect(first_task.errors.full_messages).to eq ["内容を入力してください"]
      end
    end

    context 'タスクの終了期限が空文字の場合' do
      it 'バリデーションに失敗する' do
        first_task.update(deadline_on: nil)
        expect(first_task).to be_invalid
        expect(first_task.errors.full_messages).to eq ["終了期限を入力してください"]
      end
    end

    context 'タスクの優先度が空文字の場合' do
      it 'バリデーションに失敗する' do
        first_task.update(priority: nil)
        expect(first_task).to be_invalid
        expect(first_task.errors.full_messages).to eq ["優先度を入力してください"]
      end
    end

    context 'タスクのステータスが空文字の場合' do
      it 'バリデーションに失敗する' do
        first_task.update(status: nil)
        expect(first_task).to be_invalid
        expect(first_task.errors.full_messages).to eq ["ステータスを入力してください"]
      end
    end

    context 'タスクの全ての要素に値が入っている場合' do
      it 'タスクを登録できる' do
        expect(first_task).to be_valid
      end
    end
  end

  describe '検索機能' do
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.title_search("first")).to include(first_task)
        expect(Task.title_search('first')).not_to include(second_task)
        expect(Task.title_search('first')).not_to include(third_task)
        expect(Task.title_search('first').count).to eq 1
      end
    end

    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.status_search('着手中')).to include(first_task)
        expect(Task.status_search('着手中')).not_to include(second_task)
        expect(Task.status_search('着手中')).not_to include(third_task)
        expect(Task.status_search('着手中').count).to eq 1
      end
    end

    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.title_search('first').status_search('着手中')).to include(first_task)
        expect(Task.title_search('first').status_search('着手中')).not_to include(second_task)
        expect(Task.title_search('first').status_search('着手中')).not_to include(third_task)
        expect(Task.title_search('first').status_search('着手中').count).to eq 1
      end
    end
  end
end
