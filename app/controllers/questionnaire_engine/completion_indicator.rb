module CompletionIndicator
  def self.included(base)
    base.class_eval do
      alias_method :validate_page_without_completion_indicator, :validate_page
      alias_method :validate_page, :validate_with_completion_indicator
    end
  end

  def validate_with_completion_indicator
    @completion_indicator = true
    validate_page_without_completion_indicator
  end
end
