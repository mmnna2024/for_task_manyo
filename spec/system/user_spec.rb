require "rails_helper"

RSpec.describe "ユーザ管理機能", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:user2) }
  let!(:task) { FactoryBot.create(:task, user: user) }
  let!(:admin_task) { FactoryBot.create(:second_task, user: admin) }

  before do
    driven_by(:selenium_chrome_headless)
  end

  describe "登録機能" do
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
        expect(page).to have_selector("div.alert", text: "ログインしてください")
      end
    end
  end

  describe "ログイン機能" do
    
    before do
      visit new_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
    end

    context "登録済みのユーザでログインした場合" do
      it "タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される" do
        expect(page).to have_content("タスク一覧ページ")
        expect(page).to have_selector("div.alert", text: "ログインしました")
      end

      it "自分のタスク詳細画面にアクセスできる" do
        click_link "詳細", href: task_path(task)
        expect(page).to have_content("タスク詳細ページ")
      end

      it "他人の詳細画面にアクセスすると、タスク一覧画面に遷移する" do
        visit task_path(admin_task.id)
        expect(page).to have_content("タスク一覧ページ")
        expect(page).to have_selector("div.alert", text: "アクセス権限がありません")
      end

      it "ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される" do
        click_link "ログアウト"
        expect(page).to have_content("ログインページ")
        expect(page).to have_selector("div.alert", text: "ログアウトしました")
      end
    end
  end

  describe "管理者機能" do

    def login_as_admin
      visit new_session_path
      fill_in "メールアドレス", with: admin.email
      fill_in "パスワード", with: admin.password
      click_button "ログイン"
    end

    def login_as_user
      visit new_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
    end

    context "管理者がログインした場合" do
      it "ユーザ一覧画面にアクセスできる" do
        login_as_admin
        visit admin_users_path
        expect(page).to have_content("ユーザ一覧ページ")
      end

      it "管理者を登録できる" do
        login_as_admin
        visit new_admin_user_path
        fill_in "名前", with: "User3"
        fill_in "メールアドレス", with: "user3@gmail.com"
        fill_in "パスワード", with: "user3desu"
        fill_in "パスワード（確認）", with: "user3desu"
        find("#user_admin").click
        click_button "登録する"
        expect(page).to have_content("ユーザ一覧ページ")
        expect(page).to have_selector("div.alert", text: "ユーザを登録しました")
      end

      it "ユーザ詳細画面にアクセスできる" do
        login_as_admin
        visit admin_user_path(user.id)
        expect(page).to have_content("ユーザ詳細ページ")
      end

      it "ユーザ編集画面から、自分以外のユーザを編集できる" do
        login_as_admin
        visit edit_admin_user_path(user.id)
        fill_in "名前", with: user.name
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        fill_in "パスワード（確認）", with: user.password
        click_button "更新する"
        expect(page).to have_content("ユーザ一覧ページ")
        expect(page).to have_selector("div.alert", text: "ユーザを更新しました")
      end

      it "ユーザを削除できる" do
        login_as_admin
        visit admin_users_path
        accept_alert do
          click_link("削除", match: :first)
        end
        expect(page).not_to have_content("User1")
        expect(page).to have_selector("div.alert", text: "ユーザを削除しました")
      end
    end

    context "一般ユーザがユーザ一覧画面にアクセスした場合" do
      it "タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される" do
        login_as_user
        visit admin_users_path
        expect(page).to have_content("タスク一覧ページ")
        expect(page).to have_selector("div.alert", text: "管理者以外アクセスできません")
      end
    end

    context "管理者が一人しかいない状態でそのユーザを削除しようとした場合" do
      it "削除は実行されず「管理者が0人になるため削除できません」というエラーメッセージが表示される" do
        login_as_admin
        visit admin_users_path
        accept_alert do
          click_link('削除', href: admin_user_path(admin))
        end
        expect(page).to have_content '管理者が0人になるため削除できません'
      end
    end

    context "管理者が一人しかいない状態でそのユーザから管理者権限を外す更新をしようとした場合" do
      it "更新は実行されず「管理者が0人になるため権限を変更できません」というエラーメッセージが表示させる" do
        login_as_admin
        visit edit_admin_user_path(admin)
        find('input[name="user[name]"]').set(admin.name)
        find('input[name="user[email]"]').set(admin.email)
        find('input[name="user[password]"]').set(admin.password)
        find('input[name="user[password_confirmation]"]').set(admin.password)
        uncheck 'user[admin]'
        click_button '更新する'
        expect(page).to have_content '管理者が0人になるため権限を変更できません'
      end
    end
  end
end

