FactoryBot.define do
  factory :task, class: Task do
    title { "first_task_title" }
    content { "企画書を作成する。" }
    deadline_on { "2024-02-18" }
    priority { "高" }
    status { "着手中" }
    created_at { "2022-02-18" }
    user
  end

  factory :second_task, class: Task do
    title { "second_task_title" }
    content { "顧客へ営業のメールを送る。" }
    deadline_on { "2024-02-17" }
    priority { "中" }
    status { "未着手" }
    created_at { "2022-02-17" }
    user
  end

  factory :third_task, class: Task do
    title { "third_task_title" }
    content { "見込み顧客に電話をする。" }
    deadline_on { "2024-02-16" }
    priority { "低" }
    status { "完了" }
    created_at { "2022-02-16" }
    user
  end
end
