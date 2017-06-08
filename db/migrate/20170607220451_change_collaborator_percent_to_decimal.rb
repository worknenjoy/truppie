class ChangeCollaboratorPercentToDecimal < ActiveRecord::Migration
  def change
    change_column :collaborators, :percent, :decimal, precision: 5, scale: 2
  end
end
