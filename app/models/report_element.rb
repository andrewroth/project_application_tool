class ReportElement < ActiveRecord::Base
  #acts_as_list

  belongs_to :report
  belongs_to :element
  belongs_to :cost_item
  belongs_to :report_model_method

  before_update :test

  def name
    return self.heading || 'unknown' if self[:type].nil? || self[:type] == 'ReportElement'

    if self[:type] != self.class.name
      ReportElement.find(id).name
    else
      super
    end
  end

  protected

  def test
    logger.info "XYY ReportElement(MODEL)::before_update " + self.inspect
  end
end
