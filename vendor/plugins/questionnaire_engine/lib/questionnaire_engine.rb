#  Copyright (c) 2006 Josh Starcher <josh.starcher@uscm.org>
#  
#  The MIT License
#  
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#  
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#  
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.
#  


module QE
  def boom
    raise request.env.inspect # test error handling
  end
  
  def up_monitor
#    raise "DB looks down" if Questionnaire.find(:first).nil?
    render :text => "<html><body>looks good (we're up, OK)</body></html>"
  end
  
  protected
  
  def format_date(value=nil)
    format_qe_date
  end

  def format_qe_date(value=nil)
    return '' if value.to_s.empty?
    time = ''
    begin
      time = value.class == Time ? value : Time.parse(value)
      time = time.strftime('%m/%d/%Y')
    rescue
    end
    time
  end
  
  # add underscores
  def u(str)
    str.strip.gsub(/[[:space:][:punct:]]+/, '_')
  end
  OPTIONS= {
      :table_prefix => nil
  }
end

module CustomPages
end

module CustomElements
end

module ActionView #nodoc
  module Helpers
    module ActiveRecordHelper
      def error_messages_for(*params)
        options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}
        objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
        count   = objects.inject(0) {|sum, object| sum + object.errors.count }
        unless count.zero?
          html = {}
          [:id, :class].each do |key|
            if options.include?(key)
              value = options[key]
              html[key] = value unless value.blank?
            else
              html[key] = 'errorExplanation'
            end
          end
          header_message = "#{pluralize(count, 'error')} prohibited this #{(options[:object_name] || params.first).to_s.gsub('_', ' ')} from being marked as completed."
          error_messages = objects.map {|object| object.errors.full_messages.map {|msg| content_tag(:li, msg) } }
          content_tag(:div,
            content_tag(options[:header_tag] || :h2, header_message) <<
              content_tag(:p, 'There were problems with the following fields:') <<
              content_tag(:ul, error_messages),
            html
          )
        else
          ''
        end
      end
    end
  end
end

load 'api_extensions.rb'
