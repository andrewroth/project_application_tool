class ReportElementModelMethodsController < ReportElementsController
  active_scaffold do |config|
    config.create.columns.exclude :position
    config.list.columns.exclude :position
    config.show.columns.exclude :position
  end

  def before_create_save(record)
    super
  end
  def before_update_save(record)
    super
  end

  protected

end
