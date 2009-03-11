class AddDevTickets < ActiveRecord::Migration
  USERS = {
    'andrew.roth' => 'andrew',
    'archie.kenyon' => 'archie',
    'student7' => 'student7',
    'jon.baelde' => 'jon',
    'charlotte.martin' => 'charlotte'
  }

  def self.up
    if RAILS_ENV == 'development'
      USERS.each_pair do |user_id, ticket_s|
        Ticket.create :viewer_id => Viewer.find_by_viewer_userID(user_id).id, :ticket_ticket => "#{ticket_s}_ticket"
      end
    end
  end

  def self.down
    if RAILS_ENV == 'development'
      USERS.each_pair do |user_id, ticket_s|
        t = Viewer.find_by_viewer_userID(user_id).tickets.find_by_ticket_ticket "#{ticket_s}_ticket"
	t.destroy
      end
    end
  end
end
