require "rails_helper"

RSpec.describe "タスク管理機能", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  describe "登録機能" do
    context "タスクを登録した場合" do
      it "登録したタスクが表示される" do
        FactoryBot.create(:task)
        visit tasks_path
        expect(page).to have_content '企画書'
      end
    end
  end

  describe "一覧表示機能" do
    context "一覧画面に遷移した場合" do
      it "登録済みのタスク一覧が表示される" do
        FactoryBot.create(:task)
        visit tasks_path
        expect(page).to have_content '書類作成'
      end
    end
  end

  describe "詳細表示機能" do
    context "任意のタスク詳細画面に遷移した場合" do
      it "そのタスクの内容が表示される" do
        FactoryBot.create(:task, id: '1')
        visit task_path(1)
        expect(page).to have_content '書類作成'
      end
    end
  end
end
