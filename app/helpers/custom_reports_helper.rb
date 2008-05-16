module CustomReportsHelper
  include ReportElementsHelper
  include ActiveScaffold::Helpers::Ids

  def no_show_existing
    true
  end
end

