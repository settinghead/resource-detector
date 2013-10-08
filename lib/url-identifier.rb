require "url-identifier/version"
require 'domainatrix'
require 'cgi'
require "addressable/uri"
require 'ostruct'

module UrlIdentifier
  def analyze(url)
  	#get url components
    duri = ::Domainatrix.parse url
    dduri = Addressable::URI.parse url

    params = get_params(duri, dduri)

    parse(params)

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
    return domain + duri.domain
  end

  def get_params(duri, dduri)

    OpenStruct.new :domain => strip_www(duri),
      :main_domain => duri.domain,
      :path => dduri.path,
      :query => dduri.query,
      :query_parameters => (dduri.query.nil? ? {} : CGI::parse(dduri.query)),
      :public_suffix => duri.public_suffix,
      :referral_path => duri.path.empty? ? "/" : duri.path
  end

  def parse(params)
    #set the default
    result = {
      :source => "#{params.domain}.#{params.public_suffix}",
      :uid => params.referral_path
    }
    if params.main_domain == "blogspot"
      result[:source] = "#{params.domain}"
      result[:uid] = "#{params.path}"
    elsif params.main_domain == "youtube"
      result[:source] = "#{params.main_domain}"
      unless params.query.nil?
        result[:uid] = params.query_parameters["v"].first || result[:uid]
      end
    elsif params.main_domain == "youtu" and params.public_suffix == "be"
      result[:source] = "youtube"
      m = /\/(.+)$/.match params.path
      if m.length > 1 #found v id
        result[:uid] = m[1] || result[:uid]
      end
    elsif params.main_domain == "lookbook"
      result[:source] = "#{params.main_domain}"
      if params.path.start_with? "/look/"
        m = /\/look\/([0-9]+).*/.match params.path
        if m.length > 1 #found look id
          result[:uid] = m[1] || result[:uid]
        end
      end
    elsif params.main_domain == "fashiolista"
      result[:source] = "#{params.main_domain}"
      if params.path.start_with? "/item/"
        m = /\/item\/([0-9]+).*/.match params.path
        if m.length > 1 #found item id
          result[:uid] = m[1] || result[:uid]
        end
      end
    elsif params.main_domain == "shareasale"
      result[:source] = "#{params.main_domain}"
      unless params.query.nil?
        result[:uid] = params.query_parameters["afftrack"].first unless params.query_parameters["afftrack"].first.nil? or params.query_parameters["afftrack"].first.empty?
        result[:uid] = (result[:uid].split '--').first
      end 
    elsif params.main_domain == "facebook" #do not process facebook stats for now
      result[:source] = "#{params.main_domain}"
      result[:uid] = nil
    end
    result
  end
end
