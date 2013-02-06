class Node < ActiveRecord::Base
  self.abstract_class = true

  attr_accessor :expanded
  def expanded?() expanded end
  
  def classes() '' end

  # p is items separated by dots or array of names
  def self.find_from_path(p_arr_or_str, divider = '.')
    p = p_arr_or_str.class == Array ? p_arr_or_str : p_arr_or_str.split(divider)
    
    self_name = p.pop
    return self.find_by_name(self_name) if p.empty? # base case

    parent = self.find_from_path p
    return parent.children.find_by_name(self_name)
  end

  def tree_level
    visited = { }

    level = 0 
    node = self
    while !node.parent.nil?
      visited[node] = true
      level += 1
      node = node.parent
      break if visited[node]
    end

    level
  end
  
  def path(options = {})
    visited = { }

    options[:display] ||= 'to_s'
    options[:display] ||= ' : '

    path = ''
    node = self
    while !node.nil?
      visited[node] = true
      path = node.send(options[:display]) + (options[:divider] if node != self).to_s + path
      node = node.parent
      break if visited[node]
    end
    path
  end

  def level
    self.ancestors.size
  end

  def leaf?
    self.children.empty?
  end

#- Class methods ----

  def self.types_options()
    return [] if !respond_to?('subtypes')
    [''] + subtypes.collect{ |type| [ type.name, type.name.underscore ] }
  end

  def self.roots
    self.find_all_by_parent_id nil
  end
  
  def self.to_list_options
    roots_to_dropdown_list :roots => self.roots, :include_blank => true
  end

  def self.roots_to_dropdown_list(params)
    list_options = if params[:include_blank] then [ [ '' ] ] else [ ] end

    for root in params[:roots]
      add_tree_node_to_dropdown_list params.merge(:node => root, :list => list_options) do |node|
        node.to_s
      end
    end

    list_options
  end

  def self.add_tree_node_to_dropdown_list(params)
    # defaults
    params[:separator] ||= ' : '
    params[:built]     ||= ''
    params[:indented]  ||= false 
    params[:prefix]    ||= if params[:indented] then '    ' else '' end
    params[:level]     ||= 0 

    node_s = yield(params[:node])

    if params[:indented] then
      new_dropdown_entry = ( params[:prefix] * params[:level]) + node_s
    else
      new_dropdown_entry = params[:built] + (if params[:level] > 0 then params[:separator] end).to_s + yield(params[:node])

      # next call will have the prefix, don't want an initial prefix
      params[:built] = params[:prefix] + new_dropdown_entry
    end

    params[:list] << [ new_dropdown_entry, params[:node].id ]
    next_level = params[:level] + 1

    for child in params[:node].children
      add_tree_node_to_dropdown_list(params.merge(:node => child, :level => next_level)) do |node|
        yield(node)
      end
    end
  end
end
