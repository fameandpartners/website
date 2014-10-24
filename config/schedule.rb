every :hour do
  runner 'EmailMarketing.send_emails'
  rake   'feed:export:all'
end
