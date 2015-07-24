require 'open-uri'
require 'json'
require 'faraday'

projects = {
  "redmine-counts-foo" => "dti",
}

REDMINE_URL = "http://soporte.ifarhu.gob.pa"
REDMINE_KEY = "3747869791b876be81396cf983a194f8c9c1ce2f"
REDMINE_PRIORITIES = { 3 => "low", 4 => "normal", 5 => "high",
                       6 => "urgent", 7 => "immediate" }

class RedmineTicketCounts
  def initialize(widget_id, project_id)
    @widget_id = widget_id
    @project_id = project_id
  end

  def widget_id()
    @widget_id
  end

  def latest_ticket_counts()
    conn = Faraday.new(:url => REDMINE_URL)
    counts = {}
    REDMINE_PRIORITIES.each do |prio_id, prio|
      response = conn.get '/issues.json',
                          { :project_id => @project_id,
                            :priority_id => prio_id,
                            :limit => 1,
                            :key => REDMINE_KEY }
      issue_list = JSON[response.body]
      counts[prio] = issue_list['total_count']
    end
    counts
  end
end


@RedmineTicketCounts = []
projects.each do |widget_id, project_id|
  begin
    @RedmineTicketCounts.push(RedmineTicketCounts.new(widget_id, project_id))
  rescue Exception => e
    puts e.to_s
  end
end

SCHEDULER.every '10m', :first_in => 0 do |job|
  @RedmineTicketCounts.each do |redmine_project|
    ticket_counts = redmine_project.latest_ticket_counts
    send_event(redmine_project.widget_id, ticket_counts)
  end
end