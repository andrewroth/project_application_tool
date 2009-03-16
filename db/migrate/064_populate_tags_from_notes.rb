class PopulateTagsFromNotes < ActiveRecord::Migration
  def self.up
    TravelSegment.find(:all).each do |ts|
      tags = ts.notes.to_s.split(',').collect{ |tag| tag.strip }
      puts "ts want #{ts.id} tags #{tags.inspect} ts.tags #{ts.tags}"
      ts_tags = ts.tags_o.collect{ |tag| tag.name }
      tags.each do |tag|
        if !ts_tags.include?(tag)
          puts "adding tag " + tag
          ts.tags += tag
          ts.save! # this will create the tag as well, if it doesn't exist
        end
      end
    end

    TravelSegment.find(:all).each do |ts|
      # clear notes field
      ts.notes = ''
      ts.save!
    end
  end

  def self.down
    # don't do anything for reversing, sorry
  end
end
