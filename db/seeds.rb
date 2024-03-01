User.create!(id: 1, name: "Admin", email: "admin@gmail.com", password: "aaaaaa", admin: true)
User.create!(id: 2, name: "User1", email: "user1@gmail.com", password: "bbbbbb", admin: false)

start_deadline_on = Date.new(2024, 3, 1)
end_deadline_on = Date.new(2024, 4, 1)

50.times do |i|
  Task.create!(
    title: "Task#{i+1}",
    content: "Content#{i+1}",
    deadline_on: start_deadline_on + rand(end_deadline_on - start_deadline_on + 1),
    priority: ["高", "中", "低"].sample,
    status: ["未着手", "着手中", "完了"].sample,
    user_id: 1
    )
end

50.times do |i|
  Task.create!(
    title: "タスク#{i+1}",
    content: "内容#{i+1}",
    deadline_on: start_deadline_on + rand(end_deadline_on - start_deadline_on + 1),
    priority: ["高", "中", "低"].sample,
    status: ["未着手", "着手中", "完了"].sample,
    user_id: 2
    )
end