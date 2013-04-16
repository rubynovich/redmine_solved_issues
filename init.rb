Redmine::Plugin.register :redmine_solved_issues do
  name 'Redmine Solved Issues plugin'
  author 'Roman Shipiev'
  description 'Block for my/page and rake-task for mail delivery (IssueStatus = "Solved")'
  version '0.0.1'
  url 'https://github.com/rubynovich/redmine_solved_issues'
  author_url 'http://roman.shipiev.me'

  settings :default => {
                       :issue_status => IssueStatus.last(:conditions => {:is_closed => false}).try(:id)
                     },
         :partial => 'settings/settings'

end