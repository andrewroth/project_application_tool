class Report < ActiveRecord::Base
  has_many :report_elements, :order => 'position'

  def report_elements_with_order
    report_elements_without_order.sort!{ |a,b| a.position.to_i <=> b.position.to_i }
    report_elements_without_order
  end

  # hack to fix rails bug http://dev.rubyonrails.org/ticket/3438
  alias_method :report_elements_without_order, :report_elements
  alias_method :report_elements, :report_elements_with_order
end
