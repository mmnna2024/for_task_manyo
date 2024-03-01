class ChangeAdminToNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :admin, true
  end
end
