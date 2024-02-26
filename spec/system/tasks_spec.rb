require "rails_helper"

RSpec.describe "タスク管理機能", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  describe "登録機能" do
    let!(:task1) { FactoryBot.create(:task, id: 1, title: "first_task", created_at: "2022-02-18") }

    before do
      visit tasks_path
    end

    context "タスクを登録した場合" do
      it "登録したタスクが表示される" do
        expect(page).to have_content "企画書"
      end
    end
  end

  #step2
  describe "一覧表示機能" do
    let!(:task1) { FactoryBot.create(:task, id: 1, title: "first_task", created_at: "2022-02-18") }
    let!(:task2) { FactoryBot.create(:task, id: 2, title: "second_task", created_at: "2022-02-17") }
    let!(:task3) { FactoryBot.create(:task, id: 3, title: "third_task", created_at: "2022-02-16") }

    before do
      visit tasks_path
    end

    context "一覧画面に遷移した場合" do
      it "作成済みのタスク一覧が表示される" do
        expect(page).to have_content "second_task"
        expect(page).to have_content "third_task"
      end
    end

    context "一覧画面に遷移した場合" do
      it "作成済みのタスク一覧が作成日時の降順で表示される" do
        expect(page.text).to match(/#{task2.title}[\s\S]*#{task3.title}/)
      end
    end

    context "新たにタスクを作成した場合" do
      it "新しいタスクが一番上に表示される" do
        task_list = all(".task_list")[0]
        expect(task_list).to have_content "first_task"
      end
    end
  end

  describe "ソート機能" do
    let!(:first_task) { FactoryBot.create(:task, title: "first_task_title", deadline_on: "2024-02-18", priority: "高")}
    let!(:second_task) { FactoryBot.create(:second_task, title: "second_task_title", deadline_on: "2024-02-17", priority: "中") }
    let!(:third_task) { FactoryBot.create(:third_task, title: "third_task_title", deadline_on: "2024-02-16", priority: "低") }

    context "「終了期限」というリンクをクリックした場合" do
      it "終了期限昇順に並び替えられたタスク一覧が表示される" do
        # allメソッドを使って複数のテストデータの並び順を確認する
        visit tasks_path(sort_deadline_on: true)
        expect(page.text).to match(/#{third_task.title}[\s\S]*#{second_task.title}[\s\S]*#{first_task.title}/)
      end
    end
    context "「優先度」というリンクをクリックした場合" do
      it "優先度の高い順に並び替えられたタスク一覧が表示される" do
        # allメソッドを使って複数のテストデータの並び順を確認する
        visit tasks_path(sort_priority: true)
        expect(page.text).to match(/#{first_task.title}[\s\S]*#{second_task.title}[\s\S]*#{third_task.title}/)
      end
    end
  end

  describe "検索機能" do
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task_title', status: '着手中') }
    let!(:second_task) { FactoryBot.create(:second_task, title: 'second_task_title', status: '未着手') }
    let!(:third_task) { FactoryBot.create(:third_task, title: 'third_task_title', status: '完了') }

    context "タイトルであいまい検索をした場合" do
      it "検索ワードを含むタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        expect(Task.title_search('first')).to include(first_task)
        expect(Task.title_search('first')).not_to include(second_task)
        expect(Task.title_search('first')).not_to include(third_task)
        expect(Task.title_search('first').count).to eq 1
      end
    end
    context "ステータスで検索した場合" do
      it "検索したステータスに一致するタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        expect(Task.status_search('着手中')).to include(first_task)
        expect(Task.status_search('着手中')).not_to include(second_task)
        expect(Task.status_search('着手中')).not_to include(third_task)
        expect(Task.status_search('着手中').count).to eq 1
      end
    end
    context "タイトルとステータスで検索した場合" do
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        expect(Task.title_search('first').status_search('着手中')).to include(first_task)
        expect(Task.title_search('first').status_search('着手中')).not_to include(second_task)
        expect(Task.title_search('first').status_search('着手中')).not_to include(third_task)
        expect(Task.title_search('first').status_search('着手中').count).to eq 1
      end
    end
  end

  describe "詳細表示機能" do
    let!(:task1) { FactoryBot.create(:task, id: 1, title: "first_task", created_at: "2022-02-18") }

    before do
      visit tasks_path(1)
    end

    context "任意のタスク詳細画面に遷移した場合" do
      it "そのタスクの内容が表示される" do
        expect(page).to have_content "first_task"
      end
    end
  end
end
