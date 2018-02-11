class AddMailNotificationToOrganizer < ActiveRecord::Migration
  def change
    add_column :organizers, :mail_notification, :boolean
  end
end
