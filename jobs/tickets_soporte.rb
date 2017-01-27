by_department = "SELECT
    COUNT(ost_ticket.ticket_id) AS num,
    ost_ticket.status_id,
    ost_department.name AS dept_name,
    ost_ticket_status.name AS name
  FROM ost_ticket
  INNER JOIN ost_ticket_status
    ON ost_ticket_status.id = ost_ticket.status_id
  INNER JOIN ost_department
    ON ost_department.id = ost_ticket.dept_id
  WHERE ost_ticket.dept_id = 1
  GROUP BY ost_ticket.status_id, ost_ticket.dept_id
  ORDER BY ost_ticket.dept_id;";

SCHEDULER.every '50s' do
  departments = Hash.new({ value: 0 })
  results = settings.db.query(by_department)
  results.map do |row|
    departments[row['status_id']] = { label: row['name'], value: row['num'] }
  end

  send_event('tickets_soporte', { items: departments.values })
end
