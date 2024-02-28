require "rails_helper"

RSpec.describe "ユーザ管理機能", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  describe "登録機能" do
    let!(:user) { FactoryBot.create(:user) }

    before do
      visit new_session_path
    end

    context "ユーザを登録した場合" do
      it "タスク一覧画面に遷移する" do
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログイン"
        expect(page).to have_text("タスク一覧ページ")
      end
    end

    context "ログインせずにタスク一覧画面に遷移した場合" do
      it "ログイン画面に遷移し、「ログインしてください」というメッセージが表示される" do
        visit tasks_path
        expect(page).to have_content("ログインページ")
        expect(page).to have_selector("div.notice", text: "ログインしてください")
      end
    end
  end

  describe "ログイン機能" do
    let!(:user) { FactoryBot.create(:user, id: 1) }
    let!(:task) { FactoryBot.create(:task, id: 1, user_id: 1) }
    let!(:user2) { FactoryBot.create(:user2, id: 2) }
    let!(:task2) { FactoryBot.create(:second_task, id: 2, user_id: 2) }

    before do
      visit new_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
    end

    context "登録済みのユーザでログインした場合" do
      it "タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される" do
        expect(page).to have_content("タスク一覧ページ")
        expect(page).to have_selector("div.notice", text: "ログインしました")
      end

      it "自分の詳細画面にアクセスできる" do
        click_link "詳細"
        expect(page).to have_content("タスク詳細ページ")
      end

      it "他人の詳細画面にアクセスすると、タスク一覧画面に遷移する" do
        visit task_path(2)
        expect(page).to have_content("タスク一覧ページ")
        expect(page).to have_selector("div.notice", text: "アクセス権限がありません")
      end

      it "ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される" do
        click_link "ログアウト"
        expect(page).to have_content("ログインページ")
        expect(page).to have_selector("div.notice", text: "ログアウトしました")
      end
    end
  end

  describe "管理者機能" do
    context "管理者がログインした場合" do
      it "ユーザ一覧画面にアクセスできる" do
      end
      it "管理者を登録できる" do
      end
      it "ユーザ詳細画面にアクセスできる" do
      end
      it "ユーザ編集画面から、自分以外のユーザを編集できる" do
      end
      it "ユーザを削除できる" do
      end
    end
    context "一般ユーザがユーザ一覧画面にアクセスした場合" do
      it "タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される" do
      end
    end
  end
end
