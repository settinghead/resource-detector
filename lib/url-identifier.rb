require "url-identifier/version"
require 'domainatrix'
require 'cgi'
require "addressable/uri"

module UrlIdentifier
  def analyze(url)
  	#get url components
    duri = ::Domainatrix.parse url
    dduri = Addressable::URI.parse url
    referral_path = duri.path.empty? ? "/" : duri.path
    filters = {}
    parameters = {}
    parameters = CGI::parse dduri.query unless dduri.query.nil?

    domain = strip_www duri

    #set the default
    result = {
      :source => "#{domain}.#{duri.public_suffix}",
      :uid => referral_path
    }

    params = {
      :domain => domain,
      :path => dduri.path,
      :query => dduri.query,
      :public_suffix => duri.public_suffix
    }

    if duri.domain == "blogspot"
      result[:source] = "#{domain}"
      result[:uid] = "#{dduri.path}"
    elsif duri.domain == "youtube"
      result[:source] = "#{domain}"
      unless dduri.query.nil?
        result[:uid] = parameters["v"].first || result[:uid]
      end
    elsif duri.domain == "youtu" and duri.public_suffix == "be"
      result[:source] = "youtube"
      m = /\/(.+)$/.match duri.path
      if m.length > 1 #found v id
        result[:uid] = m[1] || result[:uid]
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
      if duri.path.start_with? "/item/"
        m = /\/item\/([0-9]+).*/.match duri.path
        if m.length > 1 #found item id
          result[:uid] = m[1] || result[:uid]
        end
      end
    elsif duri.domain == "shareasale"
      result[:source] = "#{domain}"
      unless dduri.query.nil?
        result[:uid] = parameters["afftrack"].first unless parameters["afftrack"].first.nil? or parameters["afftrack"].first.empty?
        result[:uid] = (result[:uid].split '--').first
      end 
    elsif duri.domain == "facebook" #do not process facebook stats for now
      result[:source] = "#{domain}"
      result[:uid] = nil
    end
    result
  end

  private
  def strip_www(duri)
        #strip "www"
    if (duri.subdomain.start_with? "www.")
      domain = duri.subdomain.slice(4, duri.subdomain.length-4)
      domain = domain + "." if domain.length > 0
    elsif (duri.subdomain== "www" or duri.subdomain.length == 0)
      domain = ""
    else
      domain = "#{duri.subdomain}."
    end
    domain += duri.domain
    domain
  end
end
