require 'hpricot'
module ActionView
  module Helpers
    def connexion_bar(options = {})
      options[:community] ||= 'Public'
      unless session[:connexion_bar]
        service_uri = "https://www.mygcx.org/#{options[:community]}/module/omnibar/omnibar"
        proxy_granting_ticket = session[:cas_pgt]
        unless proxy_granting_ticket.nil?
          proxy_ticket = CASClient::Frameworks::Rails::Filter.client.request_proxy_ticket(proxy_granting_ticket, service_uri).ticket
          ticket = CASClient::ServiceTicket.new(proxy_ticket, service_uri)
          uri = "#{service_uri}?ticket=#{proxy_ticket}"
          logger.debug('URI: ' + uri)
          uri = URI.parse(uri) unless uri.kind_of? URI
          https = Net::HTTP.new(uri.host, uri.port)
          https.use_ssl = (uri.scheme == 'https')
          https.open_timeout = 3
          https.read_timeout = 3
          begin
            raw_res = https.start do |conn|
              conn.get("#{uri}")
            end
          rescue Timeout::Error
            logger.info('Connexionbar fetch timed out')
            return ""
          end
          begin
            doc = REXML::Document.new(raw_res.body)
          rescue REXML::ParseException => e
            logger.debug("MALFORMED CAS RESPONSE:\n#{raw_res.inspect}\n\nEXCEPTION:\n#{e}")
            return session[:connexion_bar] = ''
          end
          unless doc.elements && doc.elements["reportoutput"]
            logger.debug("This does not appear to be a valid connexion bar (missing reportdata element)!\nXML DOC:\n#{doc.elements.to_s}")
            return session[:connexion_bar] = ''
          end
          doc = Hpricot(raw_res.body)
          # Replace the CSS file
          if options[:css]
            (doc/'style').first.inner_html = "@import url(\"#{options[:css]}\");"
          end

          # Replace the logout link
          if options[:logout]
            old_link = (doc/'a').detect {|e| e.inner_html =~ /LOGOUT/}
            old_link.parent.inner_html = options[:logout]
          end
          # Remove the search and help links since they use relative urls
          doc.search("li[text()*='SEARCH']").remove
          doc.search("li[text()*='HELP']").remove
          # Remove the nested li's on the logout link, to remove the vertical bar beside Logout link
          logout_link = doc.search("a[text()*='LOGOUT']").first
          p = logout_link.parent; pp = p.parent
          pp.replace_child(p, logout_link)

          session[:connexion_bar] = (doc/'reportdata').html
        end
      end
      return session[:connexion_bar]
    end
  end
end
