require "rails_helper"

RSpec.describe "タスク管理機能", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:first_task) { FactoryBot.create(:task, user: user) }
  let!(:second_task) { FactoryBot.create(:second_task, user: user) }
  let!(:third_task) { FactoryBot.create(:third_task, user: user) }
  let!(:label) { FactoryBot.create(:label, user: user) }
  let!(:label2) { FactoryBot.create(:label, name: "label-2", user: user) }
  let!(:labelling) { FactoryBot.create(:labelling, task: first_task, label: label) }
  let!(:labelling2) { FactoryBot.create(:labelling, task: second_task, label: label) }

  before do
    driven_by(:selenium_chrome_headless)
  end

  before do
    visit new_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
  end

  describe "登録機能" do
    context "タスクを登録した場合" do
      it "登録したタスクが表示される" do
        visit tasks_path
        expect(page).to have_content "企画書"
      end
    end
  end

  describe "一覧表示機能" do
    context "一覧画面に遷移した場合" do
      it "作成済みのタスク一覧が表示される" do
        expect(page).to have_content "second_task"
        expect(page).to have_content "third_task"
      end
    end

    context "一覧画面に遷移した場合" do
      it "作成済みのタスク一覧が作成日時の降順で表示される" do
        expect(page.text).to match(/#{second_task.title}[\s\S]*#{third_task.title}/)
      end
    end

    context "新たにタスクを作成した場合" do
      it "新しいタスクが一番上に表示される" do
        task_list = all(".task_list")[0]
        expect(task_list).to have_content "first_task_title"
      end
    end
  end

  describe "ソート機能" do
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
    context "タイトルであいまい検索をした場合" do
      it "検索ワードを含むタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        expect(Task.title_search("first")).to include(first_task)
        expect(Task.title_search("first")).not_to include(second_task)
        expect(Task.title_search("first")).not_to include(third_task)
        expect(Task.title_search("first").count).to eq 1
      end
    end
    context "ステータスで検索した場合" do
      it "検索したステータスに一致するタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        expect(Task.status_search("着手中")).to include(first_task)
        expect(Task.status_search("着手中")).not_to include(second_task)
        expect(Task.status_search("着手中")).not_to include(third_task)
        expect(Task.status_search("着手中").count).to eq 1
      end
    end
    context "タイトルとステータスで検索した場合" do
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        expect(Task.title_search("first").status_search("着手中")).to include(first_task)
        expect(Task.title_search("first").status_search("着手中")).not_to include(second_task)
        expect(Task.title_search("first").status_search("着手中")).not_to include(third_task)
        expect(Task.title_search("first").status_search("着手中").count).to eq 1
      end
    end
    context "ラベルで検索をした場合" do
      it "そのラベルの付いたタスクがすべて表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        visit tasks_path
        find("#search_label").find("option[value='#{label.id}']").select_option
        click_button "検索"
        expect(page).to have_content("first_task_title")
        expect(page).to have_content("second_task_title")
        expect(page).not_to have_content("third_task_title")
      end
    end
  end

  describe "詳細表示機能" do
    context "任意のタスク詳細画面に遷移した場合" do
      it "そのタスクの内容が表示される" do
        visit tasks_path(first_task.id)
        expect(page).to have_content "first_task"
      end
    end
  end
end
