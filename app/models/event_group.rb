class EventGroup < Node
  belongs_to :ministry
  belongs_to :location

  has_many :custom_reports
  has_many :projects
  has_many :forms
  has_many :travel_segments
  has_many :cost_items
  has_many :feedbacks
  has_many :forms
  has_many :reason_for_withdrawals
  has_many :reference_emails
  has_many :tags

  acts_as_tree

  def to_s
    ministry = self.ministry ? self.ministry.to_s + ' ': 
      (self.ministry_id ? "Can't find ministry where id=#{self.ministry_id}" : nil)
    "#{ministry}#{title}"
  end

  def to_s_with_ministry
    "#{ministry_inherited_name}:#{title}"
  end

  # returns the ministry followed by the entire path of parents in the event group tree
  def to_s_with_ministry_and_eg_path
    "#{ministry_inherited_name} - #{eg_path}"
  end
  
  def to_s_with_eg_path
    "#{eg_path}"
  end

  def ministry_inherited_name
    m = ministry_inherited
    m ? "#{m.name} " : ''
  end

  def eg_path
    visited = { self => true }

    eg_path = ''
    node = self
    while !node.nil?
      eg_path = eg_path.empty? ? node.title : (node.title + ' - ' + eg_path)
      node = node.parent

      if visited[node]
        node = nil
      else
        visited[node] = true
      end
    end

    eg_path
  end

  def ministry_inherited
    node = self
    while node.ministry.nil? && !node.parent_id.nil?
      node = node.parent
    end

    node.ministry
  end
end
