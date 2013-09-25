require "url_analyzer/version"

module UrlAnalyzer
  def self.analyze(url)
  	#get url components
  	url = url_post.url unless url.present?
    duri = Domainatrix.parse url
    dduri = URI::parse url
    referral_path = duri.path.empty? ? "/" : duri.path #+ (dduri.fragment.present? ? "\##{dduri.fragment}" : "")
    filters = {}
    parameters = {}
    parameters = CGI::parse dduri.query if dduri.query.present?
    uid = nil
    
    #strip "www"
    if (duri.subdomain.start_with? "www.")
      domain = duri.subdomain.slice(4, duri.subdomain.length-4)
      domain = domain + "." if domain.length > 0
    elsif (duri.subdomain== "www" or duri.subdomain.length == 0)
      domain = ""
    else
      domain = "#{duri.subdomain}"
    end
    domain += duri.domain

    result = {
      :source => domain + ".#{duri.public_suffix}",
      :uid => referral_path
    }

    if duri.domain == "blogspot"
      result[:source] = "#{domain}"
      result[:uid] = "#{referral_path}"
    elsif duri.domain == "youtube"
      result[:source] = "#{domain}"
      if dduri.query.present?
        result[:uid] = parameters["v"].first || vid #TODO: temp fix
      end
    elsif duri.domain == "lookbook"
      result[:source] = "#{domain}"
      if duri.path.start_with? "/look/"
        m = /\/look\/([0-9]+).*/.match duri.path
        if m.length > 1 #found look id
          result[:uid] = m[1] || result[:uid]
        end
      end
    elsif duri.domain == "fashiolista"
      result[:source] = "#{domain}"
      if duri.path.start_with? "/look/"
        m = /\/item\/([0-9]+).*/.match duri.path
        if m.length > 1 #found item id
          result[:uid] = m[1] || result[:uid]
        end
      end
    elsif duri.domain == "shareasale"
      result[:source] = "#{domain}"
      if dduri.query.present?
        parameters = CGI::parse dduri.query
        result[:uid] = parameters["afftrack"].first if parameters["afftrack"].first.present? and not parameters["afftrack"].first.empty?
        result[:uid] = (aff_id.split '--').first
      end
    elsif duri.domain == "facebook" #do not process facebook stats for now
      result[:uid] = nil
    end
    result
  end
end
