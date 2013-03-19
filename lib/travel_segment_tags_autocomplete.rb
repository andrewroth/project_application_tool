module TravelSegmentTagsAutocomplete

  def find_options(column, search)
    {  :conditions => [ "LOWER(#{column}) LIKE ?", '%' + search.downcase + '%' ], 
       :order => "#{column} ASC",
       :limit => 10 
    }
  end
  
  def auto_complete_for_travel_segment_tags
    tl = params[:travel_segment][:tags] + ' ' # add a space so if you have a tl ending with , it will
                                              #   get the last item of the split to be an empty string,
                                              #   that way the autocomplete will list all possible items
                                              #   instead of mistakenly matching the item before the ,
    tags = tl.split(',').collect{ |tag| tag.strip }
    tag = tags.delete_at tags.size-1
    
    @items = Tag.find(:all, find_options('name', tag))
    
    # add the project names to autocomplete options
    @items += @eg.projects.find(:all, find_options('title', tag))
    
    @items.sort! { |a,b| a.name <=> b.name }
    
    # grab only the first ten, downcase em
    @items2 = []
    for i in 0..9 do
      break if @items[i].nil?
      @items2 << @items[i]
    end
    
    render :inline => "<%= auto_complete_result2(@items2, 'name', '#{CGI::escape(tag)}', '#{CGI::escape(tags.join(', ') + (', ' if !tags.empty?).to_s)}') %>"
  end
end
