module ControllerXML
  def spt_attribute_exceptions 
    [ 'id', 'questionnaire_id', 'page_id', 'question_id', 'parent_id', 'position' ]
  end
  
  def setup_xml_file_header(filename)
    headers['Content-Type'] = "text/xml" 
    headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
    headers['Cache-Control'] = ''
  end
  
  def import_from_xml
    xml_str = ''
    if params[:xml].class.name['StringIO']
      xml_str = params[:xml]
    else
      File.open(params[:xml].path.to_s, "r") { |f|
          xml_str = f.read
      }
    end
    
    doc = REXML::Document.new(xml_str)
    create_from_xml doc.root
  end
  
  def create_from_xml(root)
    parent_created = (self.class.name == "PagesController") ? @questionnaire : nil
    create_from_xml_with_parent(root, parent_created, nil)
  end
  
  def create_from_xml_with_parent(xml_elem, parent_created, parent_xml)
    my_class_name = self.class.name
    
    # after this if, created and ec should be set
    
    if (xml_elem.name == 'question_option')
      oc = ApplicationController::QuestionOptionsController.new
      created = oc.create_with_id(parent_created.id)
      # question options won't have any children so we can use whatever
      # controller since there won't be any recursive calls
      ec = self
    elsif (xml_elem.name == 'form_questionnaire')
      created = create
      # controller used in the recursive call
      ec = ApplicationController::PagesController.new
      
    elsif (xml_elem.name == "page")        
      @questionnaire ||= parent_created
      create
      created = @page
      # controller used in the recursive call
      ec = ApplicationController::ElementsController.new
      
    elsif (xml_elem.name != "page") # must be an element
      params = {}
      params[:element_type] = xml_elem.name.camelize
      params[:no_redirect] = true
      @page = parent_created

      params[:no_inheritance] = true
      
      # set parent_id for all elements whose parents aren't pages (that means
      # the parent must be a group or question, and need parent set
      if (parent_created.class.name != 'Page')
        params[:parent_id] = parent_created.id
      end
      
      create_with_params(params, true)
      created = @element
      
      # controller used in the recursive call
      ec = self
    end
    
    if (xml_elem.name != 'form_questionnaire')
      
      position = parent_xml.nil? ? 0 : parent_xml.attributes['next_position']
      if (xml_elem.name == 'page')
        # all pages have a position but it's set in the questionnaire_pages tuple
        questionnaire_page = parent_created.questionnaire_pages.find_by_page_id(created.id)
        questionnaire_page.position = position
        questionnaire_page.save!
      elsif
        # all elements have a position, but if it's on a page it uses the
        # page tuple's position
        if (parent_created.class.name == "Page")
          page_element = parent_created.page_elements.find_by_element_id(created.id)
          page_element.position = position
          page_element.save!
          xml_elem.attributes['position'] = 0
        else
          # all elements and question options (ie everything but forms) have a position.  
          # use the order they come from XML
          xml_elem.attributes['position'] = position
        end
      end
      if !parent_xml.nil?
        parent_xml.attributes['next_position'] = position.next
      end
    end
    
    created.attributes = xml_elem.attributes
    created.save!
    
    # init next_position attributes (it will be used to position elements in the order they are in the XML)
    xml_elem.attributes['next_position'] = "0"
      
    xml_elem.elements.each do |child|
      ec.create_from_xml_with_parent(child, created, xml_elem)
    end
  end
end
