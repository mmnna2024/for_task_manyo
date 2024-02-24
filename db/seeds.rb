[
  ['first_task', 'content1', '2022-02-18', '中', '未着手'],
  ['second_task', 'content2', '2022-02-17', '高', '着手中'],
  ['third_task', 'content3', '2022-02-16', '低', '完了'],
  ['4th_task', 'content4', '2022-02-15', '中', '着手中'],
  ['5th_task', 'content5', '2022-02-14', '高', '完了'],
  ['6th_task', 'content6', '2022-02-13', '低', '未着手'],
  ['7th_task', 'content7', '2022-02-12', '中', '完了'],
  ['8th_task', 'content8', '2022-02-11', '高', '未着手'],
  ['9th_task', 'content9', '2022-02-10', '低', '着手中'],
  ['10th_task', 'content10', '2022-02-09', '中', '未着手']
].each do |title, content, deadline, priority, status|
  Task.create!(
    { title: title, content: content, deadline_on: deadline, priority: priority, status: status}
  )
end
