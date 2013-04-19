require_dependency 'mailer'

module SolvedIssuesPlugin
  module MailerPatch
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      base.class_eval do
      end
    end

    module ClassMethods
      def solved_issues(options={})
        mailcopy = options[:cc]
        status_id = Setting[:plugin_redmine_solved_issues][:issue_status]
        solved_issues = Issue.open.where(:status_id => status_id)
        solved_issues.map(&:author).uniq.map do |user|
          solved_issues_mail(user, solved_issues.where(:author_id => user.id), mailcopy).deliver
        end
      end
    end

    module InstanceMethods
      def solved_issues_mail(user, solved_issues, mailcopy)
        set_language_if_valid user.language
        issues_count = solved_issues.count
        subject = case issues_count
          when 1 then  l(:mail_subject_solved_issues1, :count => issues_count)
          when 2..4 then l(:mail_subject_solved_issues2, :count => issues_count)
          else l(:mail_subject_solved_issues5, :count => issues_count)
        end
        status_id = Setting[:plugin_redmine_solved_issues][:issue_status]
        @solved_issues = solved_issues
        @firstname = user.firstname
        @lastname = user.lastname
        @issues_url = url_for(:controller => 'issues', :action => 'index', :set_filter => 1, :author_id => 'me', :status_id => status_id, :sort => 'priority:desc,updated_on:desc')
        mail(:to => user.mail, :cc => mailcopy, :subject => subject) if user.mail.present? && issues_count.nonzero?
      end
    end
  end
end
