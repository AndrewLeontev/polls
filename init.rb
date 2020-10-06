Redmine::Plugin.register :polls do
  name 'Polls plugin'
  author 'Andrey Leontev'
  description 'This is a plugin for Redmine'
  version '0.0.1'

  menu :top_menu, :polls, { :controller => 'polls', :action => 'index' }, caption: :button_polls, if: Proc.new { User.current.logged? }, html: {class: 'in_link'}
  menu :top_menu, :polls_report, { :controller => 'polls', :action => 'report' }, caption: :button_polls_report, if: Proc.new { User.current.admin }, html: {class: 'in_link'}

  requires_redmine :version_or_higher => '4.0.0'

  project_module :polls do
    permission :manage_polls, :polls => [:new, :edit, :create, :update, :destroy]
  end

  Rails.application.config.to_prepare do
    load 'polls/loader.rb'
  end

end
