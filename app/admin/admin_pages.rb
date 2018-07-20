ActiveAdmin.register AdminPage do
  menu priority: 2, label: proc{ I18n.t("active_admin.pages") }
  permit_params :namespace, :lang, :body

  index do
    selectable_column
    id_column
    column :namespace
    column :lang
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :namespace
      row :lang
      row (:admin_page) { |admin_page| raw(admin_page.body) }
      row :updated_at
      row :created_at
    end
  end

  module ActiveAdmin
    class ResourceDSL < DSL
      def permit_params(*args, &block)
        resource_sym = config.resource_name.singular.to_sym
        controller do
          define_method :permitted_params do
            params.permit :_method, :_wysihtml5_mode, :utf8,
                          :authenticity_token, :commit, :id,
                          resource_sym =>
                          block ? instance_exec(&block) : args
          end
        end
      end
    end
  end


  filter :namespace
  filter :lang
  filter :created_at

  form do |f|
    f.inputs do
      f.input :namespace
      f.input :lang
      f.input :body, as: :html_editor
    end
    f.actions
  end

end
