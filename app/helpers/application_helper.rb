module ApplicationHelper
  def actions(instance, actions=%w(edit destroy))
    haml_tag 'nav.instance_actions' do
      haml_tag 'ul' do
        haml_tag :li do
          haml_concat(link_to t('actions.edit'), edit_polymorphic_path(instance))
        end
        haml_tag :li do
          haml_concat(link_to t('actions.destroy'), instance, :confirm => t('actions.confirm') , :method => :delete)
        end
      end
    end
  end
end
