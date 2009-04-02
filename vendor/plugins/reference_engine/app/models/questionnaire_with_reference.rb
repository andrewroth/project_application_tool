
module QuestionnaireWithReference

  def references
    # find all refs then go up the path to see if they match this questionnaire
    Reference.find(:all).collect { |ref|
      q = ref.traverse_to_questionnaire
      q == self ? ref : nil
    }.compact
  end

  def references_old(element = nil)
    return @references_cache if @references_cache and element.nil? 

    # go through all the reference elements and find which ones are added to this questionnaire
    elements = []

    # at elements level
    if element
      # reset the filter so that refs actually show up
      saved_filter = filter
      element.filter = nil

      elements << element if element.class == Reference

      for child in element.elements
        elements += references child
      end

      # restore filter
      filter = saved_filter

      return elements
    end

    # reset the filter so that refs actually show up
    self.filter = nil

    # at questionnare level
    for page in pages
      elements += references(page)
    end

    # restore filter
    filter = saved_filter

    references = elements.uniq.sort{ |a,b| a.id <=> b.id }
    @references_cache = references if element.nil?
    references
  end
end

