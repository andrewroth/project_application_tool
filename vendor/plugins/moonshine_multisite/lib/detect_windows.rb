# Returns true if we are running on a MS windows platform, false otherwise.
def Kernel.is_windows?
  (RUBY_PLATFORM =~ /mswin32/) != nil
end
