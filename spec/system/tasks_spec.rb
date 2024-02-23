require "rails_helper"

RSpec.describe "タスク管理機能", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  describe "登録機能" do
    let!(:task1) { FactoryBot.create(:task, id: 1, title: 'first_task', created_at: "2022-02-18") }

    before do
      visit tasks_path
    end

    context "タスクを登録した場合" do
      it "登録したタスクが表示される" do
        expect(page).to have_content '企画書'
      end
    end
  end

  #step2
  describe "一覧表示機能" do
    let!(:task1) { FactoryBot.create(:task, id: 1, title: 'first_task', created_at: "2022-02-18") }
    let!(:task2) { FactoryBot.create(:task, id: 2, title: 'second_task', created_at: "2022-02-17") }
    let!(:task3) { FactoryBot.create(:task, id: 3, title: 'third_task', created_at: "2022-02-16") }

    before do
      visit tasks_path
    end

    context "一覧画面に遷移した場合" do
      it "作成済みのタスク一覧が表示される" do
        expect(page).to have_content 'second_task'
        expect(page).to have_content 'third_task'
      end
    end

    context "一覧画面に遷移した場合" do
      it "作成済みのタスク一覧が作成日時の降順で表示される" do
        expect(page.text).to match(/#{task2.title}[\s\S]*#{task3.title}/)
      end
    end

    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        task_list = all('.task_list')[0]
        expect(task_list).to have_content 'first_task'
      end
    end
  end

  describe "詳細表示機能" do
    let!(:task1) { FactoryBot.create(:task, id: 1, title: 'first_task', created_at: "2022-02-18") }

    before do
      visit tasks_path(1)
    end

    context "任意のタスク詳細画面に遷移した場合" do
      it "そのタスクの内容が表示される" do
        expect(page).to have_content 'first_task'
      end
    end
  end
end
