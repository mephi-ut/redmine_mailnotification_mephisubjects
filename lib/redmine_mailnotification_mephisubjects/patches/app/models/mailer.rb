# encoding: UTF-8

module MailNotificationMephiSubjects 
	module MailerPatch
		def self.included(base)
			base.extend(ClassMethods)
			base.send(:include, InstanceMethods)

			base.class_eval do
				unloadable

				alias_method_chain :issue_add,  :mephisubjects
				alias_method_chain :issue_edit, :mephisubjects
			end
		end

		module ClassMethods
		end

		module InstanceMethods
			def issue_add_with_mephisubjects(issue, to_users, cc_users)
				redmine_headers 'Project' => issue.project.identifier,
						'Issue-Id' => issue.id,
						'Issue-Author' => issue.author.login
				redmine_headers 'Issue-Assignee' => issue.assigned_to.login if issue.assigned_to
				message_id issue
				references issue
				@author = issue.author
				@issue = issue
				@users = to_users + cc_users
				@issue_url = url_for(:controller => 'issues', :action => 'show', :id => issue)
				@subject = "[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}] (#{issue.status.name}) #{issue.subject}"

				@subject = "[##{issue.id}] (#{issue.status.name}) #{issue.subject}" if issue.project.parent_id == 12761


				mail :to => to_users.map(&:mail),
				     :cc => cc_users.map(&:mail),
				     :subject => @subject

			end

			def issue_edit_with_mephisubjects(journal, to_users, cc_users)
				issue = journal.journalized
				redmine_headers 'Project' => issue.project.identifier,
						'Issue-Id' => issue.id,
						'Issue-Author' => issue.author.login
				redmine_headers 'Issue-Assignee' => issue.assigned_to.login if issue.assigned_to
				message_id journal
				references issue
				@author = journal.user
				s = "[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}] "
				s = "##{issue.id}] " if issue.project.parent_id == 12761
				s << "(#{issue.status.name}) " if journal.new_value_for('status_id')
				s << issue.subject
				@issue = issue
				@users = to_users + cc_users
				@journal = journal
				@journal_details = journal.visible_details(@users.first)
				@issue_url = url_for(:controller => 'issues', :action => 'show', :id => issue, :anchor => "change-#{journal.id}")
				mail :to => to_users.map(&:mail),
				     :cc => cc_users.map(&:mail),
				     :subject => s

			end
		end
	end
end
Mailer.send(:include, MailNotificationMephiSubjects::MailerPatch)

