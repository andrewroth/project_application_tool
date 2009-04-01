# Fix "undefined method `[]' for #<Enumerable::Enumerator:0x2a083c0>" errors
#
# See http://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg528878.html
#
unless '1.9'.respond_to?(:force_encoding)
  String.class_eval do
    begin
      remove_method :chars
    rescue NameError
      # OK
    end
  end
end

