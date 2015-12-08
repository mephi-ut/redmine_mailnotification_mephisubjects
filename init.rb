require 'redmine'

require 'redmine_mailnotification_mephisubjects/patches/app/models/mailer'

Redmine::Plugin.register :redmine_mailnotification_mephisubjects do
	name 'Тема уведомительного письма в зависимости от особенностей конкретных проектов НИЯУ МИФИ'
	author 'Dmitry Yu Okunev'
	author_url 'https://github.com/xaionaro/'
	url 'https://devel.mephi.ru/dyokunev/redmine_mailnotification_mephisubjects'
	version '0.0.1'
end
