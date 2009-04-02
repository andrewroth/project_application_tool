module Filter
  
  def self.grab_hash_from(params)
    if params.class == Hash
      return params 
    elsif params.nil?
      return {}
    elsif params.class == Array
      return params[0].class == Hash ? params[0] : {}
    else
      return {}
    end
  end
  
  # unfiltered should be a symbol pointing to a method which returns an array of elements
  # it will extend that method to allow params
  # 
  #   :filter => [ <ARRAY OF STRING> ]
  #   :default => true or false
  #   
  #  each element should respond to a 'filter' method which returns a list of strings of 
  #  flags that are true on that element.  Then when unfiltered is call filtering will
  #  be applied, based on this algorithm:
  #     - if default is true, only elements that match filter are removed
  #     - if default is false, only elements that match filter are included
  #   and an element 'matches' filter when element.filter INTERSECT filter is not empty.
  #  
  def self.setup(base, unfiltered, *params, &block)
    params = grab_hash_from(params)
    
    base.class_eval do      
      
      if block_given?
        define_method(:"custom_filter", block)
      end
      
      attr_accessor :filter
      
      s = "" +
      "alias_method :\"#{unfiltered}_all\", :\"#{unfiltered}\"\n" +
      "filtered_proxy = Proc.new { |*params| \n" + 
      "  params = Filter.grab_hash_from(params)\n" + 
      "  puts 'filtered_proxy params before merge: ' + params.inspect if params[:debug]\n" + 
      "  params = (@filter || {}).merge(params)\n" + 
      "  params[:debug] = params[:debug].nil? ? #{params[:debug] == true} : params[:debug]\n" +
      "  puts 'filtered_proxy params after merge: ' + params.inspect if params[:debug]\n" + 
      "  params[:all] = #{unfiltered}_all\n" +
      "  get_with_filter(params)\n" +
      "}\n" + 
      "define_method(:filtered_proxy, filtered_proxy)\n" + 
      "define_method(:#{unfiltered}, filtered_proxy)\n" + 
      "define_method(:is_container?) do\n" + 
      "  #{params[:container] == true}\n" +
      "end"
      
      puts s if params[:debug]
      eval s
      
      attr_accessor :filter
    end
  end
  
  def get_with_filter(*params)
    params = Filter.grab_hash_from(params)
    if params.class != Hash || params[:default].nil? || params[:filter].nil?
      puts "no filtering required for " + self.class.name if params[:debug]
      return params[:all]
    end

    puts "filtering required for " + self.class.name if params[:debug]
    
    params_no_debug = params.clone
    params_no_debug[:debug] = false
    
    # special case for if this item itself matches the filter
    self_matches_filter = !respond_to?('flags') ? nil : !(params[:filter] & flags).empty?
    if self_matches_filter
      return params[:default] ? [] : params[:all]
    end
    
    # remove all elements that are empty because their subelements are all removed by filtering,
    #  or that don't pass the filter themselves
    filtered = []
    params[:all].each do |e|
      e.filter = params_no_debug if e.respond_to? 'filter'
      
      size = e.respond_to?('filtered_proxy') ? e.send('filtered_proxy', params_no_debug).size : 0
      item_matches_filter = !e.respond_to?('flags') ? nil : !(params[:filter] & e.flags).empty?
      
      puts "::: e #{e.class.name} #{e.id.to_s}" if params[:debug]
      puts "e.filtered-size: " + size.inspect if params[:debug]
      puts "e.matches: " + item_matches_filter.to_s if params[:debug]
      
      if params[:default] == false && !item_matches_filter && size == 0
        puts "removing item because it doesn't match the filter, it's empty, and default is false!" if params[:debug]
      else
        puts "e.respond_to?('flags') #{e.respond_to?('flags')}" if params[:debug]
        
        if !e.respond_to?('flags') && (params[:default] == true || !size != 0)
          filtered << e
          puts "e doesn't have any flags but added it anyways because default is true (or else its size > 0)" if params[:debug]
        elsif params[:default] == true
          # by default accept -- only add if it not match the filter (ie remove if it matches)
          if !item_matches_filter
            filtered << e
            puts "accepted e because it does *not* matches the filter" if params[:debug]
          end
        else
          # by default reject -- only add if it does match the filter or it's not empty (ie something inside it matches the filter)
          if item_matches_filter || size > 0
            filtered << e
            if item_matches_filter
              puts "accepted e because it *does* match the filter (its flags: #{e.flags} | filter: #{params[:filter]})" if params[:debug]
            elsif size > 0
              puts "accepted e because it has (at least) #{size} element(s) which matches the filter" if params[:debug]
            end
          end
        end
      end
    end
    
    # allow custom filtering on what's left
    if respond_to?('custom_filter')
      self.send(:custom_filter, filtered, params_no_debug)
    end
    
    puts "final filtered results: " + filtered.collect{|f| f.id}.inspect if params[:debug]
    filtered
  end
end
