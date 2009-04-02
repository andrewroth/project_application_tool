module ModelXML
  # default xml_children - some classes might be included for their attributes
  # but not have children
  def xml_children
    return []
  end
  
  def to_xml_deep(params = {})
    (params[:no_header] ? "" : "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n") +
    to_xml_deep_rec(0, params)
  end
  
  class Indenter < String
    def initialize(indent_cnt, indent_base_unit)
      @indent_str = ""
      (1..indent_cnt).each do
        @indent_str += indent_base_unit
      end
    end
    def <<(s)
      super @indent_str + s + "\n"
    end
  end
  
  def _escape(text)
    text.gsub(/[^-\w\d\/\n\r _:;+=.\@*,()#]/) do |x|
      case x
        when '"' : '&quot;'
        when '\'' : '&apos;'
        when '<' : '&lt;'
        when '>' : '&gt;'
        when '&' : '&amp;'
        else
            #"&##{x[0]};"   # this seemed to cause weird chars
            x
      end
    end
  end 
  
  def to_xml_deep_rec(indent_cnt, params = {})
    except = params[:except].nil? ? [] : params[:except]
    
    indent_base_unit = '  '
    
    xml = Indenter.new(indent_cnt, indent_base_unit)
    xml << "<#{self.class.to_s.underscore}"
    attributes(:except => except, :only => []).each do |key,val|
      xml << "  #{key}=\"#{_escape(val.to_s)}\""
    end
    xml << ">"
    
    xml_children.inject(xml) do |xml, e|
      xml << e.to_xml_deep_rec(indent_cnt+1, params)
    end
    
    xml << "</#{self.class.to_s.underscore}>"
  end
end
