current_valuation = 0
current_open = 0
current_closed = 0
current_resolved = 0

# Execute every 1 minute
SCHEDULER.every '60s' do
  # Queries
  by_status = "SELECT
    COUNT(ticket_id) AS num,
    status_id
    FROM ost_ticket
    GROUP BY status_id";

  # Save old references
  last_open = current_open
  last_closed = current_closed
  last_resolved = current_resolved

  # Execute query
  results = settings.db.query(by_status)
  results.map do |row|
    if row['status_id'] == 1
      # Open
      current_open = row['num']
    elsif row['status_id'] == 3
      # Closed
      current_closed = row['num']
    elsif row['status_id'] == 11
      # Resolved
      current_resolved = row['num']
    end
  end

  # Now update the numbers ;)
  send_event('open-tickets', { current: current_open, last: last_open })
  send_event('closed-tickets', { current: current_closed, last: last_closed })
  send_event('resolved-tickets', { current: current_resolved, last: last_resolved })
end