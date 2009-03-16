
class ApplnUsedInReportViewController < ApplnController
  def get_filter() { :filter => [ "used_in_report" ], :default => false } end
end
