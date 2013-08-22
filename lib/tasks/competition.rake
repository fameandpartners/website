#a script that outputs entry date, name, email and entries

namespace "competition" do
  desc "show users with entries"
  task entries: :environment do
    users = calculate_data
    display_header
    users.each do |user|
      display_user_info(user)
    end
  end
end

def calculate_data
  data = []
  
  CompetitionEntry.where(master: true).order('created_at asc').each do |master_entry|
    user = master_entry.user
    next if user.blank?

    data.push({
      name: user.fullname,
      email: user.email,
      created_at: master_entry.created_at,
      entries: user.entries.count.to_s
    })
  end

  data
end

def display_header
  header = " | #{ 'Date'.ljust(20) } | #{'Name'.ljust(30)} | #{'Email'.ljust(30)} | #{'Entries'.ljust(10)} | "
  puts "-" * header.length
  puts header
  puts "-" * header.length
end

def display_user_info(user)
  date = user[:created_at].to_s(:db)
  name = user[:name]
  email = user[:email]
  entries = user[:entries]
  info_row = " | #{ date.ljust(20) } | #{name.ljust(30)} | #{email.ljust(30)} | #{entries.ljust(10)} | "
  puts info_row
  puts '-' * info_row.length
end
