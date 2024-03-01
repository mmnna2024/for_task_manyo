require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーションのテスト' do
    let!(:user) { FactoryBot.create(:user, id: 1) }
    let!(:task) { FactoryBot.create(:task, user_id: 1) }

    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task.update(title: nil)
        expect(task).to be_invalid
        expect(task.errors.full_messages).to eq ["タイトルを入力してください"]
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task.update(content: nil)
        expect(task).to be_invalid
        expect(task.errors.full_messages).to eq ["内容を入力してください"]
      end
    end

    context 'タスクの終了期限が空文字の場合' do
      it 'バリデーションに失敗する' do
        task.update(deadline_on: nil)
        expect(task).to be_invalid
        expect(task.errors.full_messages).to eq ["終了期限を入力してください"]
      end
    end

    context 'タスクの優先度が空文字の場合' do
      it 'バリデーションに失敗する' do
        task.update(priority: nil)
        expect(task).to be_invalid
        expect(task.errors.full_messages).to eq ["優先度を入力してください"]
      end
    end

    context 'タスクのステータスが空文字の場合' do
      it 'バリデーションに失敗する' do
        task.update(status: nil)
        expect(task).to be_invalid
        expect(task.errors.full_messages).to eq ["ステータスを入力してください"]
      end
    end

    context 'タスクの全ての要素に値が入っている場合' do
      it 'タスクを登録できる' do
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    let!(:user) { FactoryBot.create(:user, id: 1) }
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task_title', status: '着手中', user_id: 1) }
    let!(:second_task) { FactoryBot.create(:second_task, title: 'second_task_title', status: '未着手', user_id: 1) }
    let!(:third_task) { FactoryBot.create(:third_task, title: 'third_task_title', status: '完了', user_id: 1) }

    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.title_search('first')).to include(first_task)
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
