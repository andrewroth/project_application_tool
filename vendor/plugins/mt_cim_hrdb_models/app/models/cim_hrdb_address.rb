class CimHrdbAddress < Address
  self.abstract_class = true

  belongs_to :province
  belongs_to :country
  belongs_to :title_bt, :class_name => 'Title', :foreign_key => :title_id

  def state
    province ? province.name : ''
  end

  def country
    province && province.country ? province.country.name : ''
  end

  def title
    title_bt ? title_bt.desc : ''
  end

  def province=(val) throw 'not implemented' end
  def country=(val) throw 'not implemented' end
    
  def mailing
    out = address1.to_s 
    out += "<br />" unless out.strip.empty?
    out += city.to_s 
    out += ", "  unless city.to_s.empty?
    out += state.to_s + " " + zip.to_s
  end

end
