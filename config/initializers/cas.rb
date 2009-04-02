# enable detailed CAS logging
cas_logger = CASClient::Logger.new(RAILS_ROOT+'/log/cas.log')
cas_logger.level = Logger::DEBUG

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url  => "https://signin.mygcx.org/cas/",
  :username_session_key => :cas_user,
  :extra_attributes_session_key => :cas_extra_attributes,
  :proxy_retrieval_url => "https://www.globalshortfilmnetwork.com/cas_proxy_callback/retrieve_pgt",
  :proxy_callback_url => "https://www.globalshortfilmnetwork.com/cas_proxy_callback/receive_pgt",
  # :authenticate_on_every_request => true,
  :logger => cas_logger
)
