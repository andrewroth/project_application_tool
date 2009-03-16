class ConvertTitleData < ActiveRecord::Migration
  def self.up
    convert_title
  end

  def self.down
  end

def self.convert_title
es = Element.find_all_by_text 'Title', :include => { :page_elements => :page }
for e in es
  next if e.page_elements.empty?
  page = e.page_elements.first.page
  pi = page.elements.detect { |el| el.text == 'Personal Information Form' }

  if pi
    puts "found pi (#{pi.id}) for #{e.id} q #{page.questionnaires.first.form.title} in #{page.questionnaires.first.form.event_group.to_s_with_eg_path}" if pi

    # convert the actual data now
    @cache = {}
    n = 0
    for a in e.answers
      next if a.nil? || a.empty?

      # find person
      app = Appln.find_by_id a.instance_id
      next unless app && app.profile && app.profile.viewer &&
        app.profile.viewer.person
      p = app.profile.viewer.person

      t = @cache[a.answer] || (@cache[a.answer] = Title.find_by_desc(a.answer))
      #puts "Convert #{a.answer} -> #{t.id}"
      n += 1
      p.title_id = t.id
      p.save!
    end
    puts "Converted #{n} titles."
  end
end
end

end
