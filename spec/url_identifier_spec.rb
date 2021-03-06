# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'url-identifier'

class DummyClass
end

describe UrlIdentifier do
	before(:each) do
	  @dummy_class = DummyClass.new
	  @dummy_class.extend(UrlIdentifier)
	end

	it "should get valid source and uid given a url" do
		@dummy_class.analyze("http://rosalieeve.blogspot.com/2013/01/military-print.html").should == {:source => 'rosalieeve.blogspot', :uid =>"/2013/01/military-print.html"}
		@dummy_class.analyze("http://rosalieeve.blogspot.com/2013/01/military-print.html?affiliate=true").should == {:source => 'rosalieeve.blogspot', :uid =>"/2013/01/military-print.html"}
		@dummy_class.analyze("http://rosalieeve.wordpress.com/?page=2333").should == {:source => 'rosalieeve.wordpress.com', :uid =>"/?page=2333"}
		@dummy_class.analyze("http://www.youtube.com/watch?v=9bZkp7q19f0").should == {:source=>'youtube', :uid=>'9bZkp7q19f0'}
		@dummy_class.analyze("http://youtu.be/X-7rixEph5s").should == {:source=>'youtube', :uid=>'X-7rixEph5s'}
		@dummy_class.analyze("http://lookbook.nu/look/5384932-Choies-Coat-Shirt-Romwe-Bag-Hat-Inspired-By-Freja-Beha").should == {:source => 'lookbook', :uid =>'5384932'}
		@dummy_class.analyze("http://www.shareasale.com/r.cfm?b=393018&u=314743&m=41271&afftrack=skim34712X927925Xea9dfabecfd3bfab249967985e2441f9&urllink=www.abc.com%2Fproduct%2Fadd-asa-dadsa").should == {:source => 'shareasale', :uid =>'skim34712X927925Xea9dfabecfd3bfab249967985e2441f9'}
		@dummy_class.analyze("http://www.fashiolista.com/item/12944315/").should == {:source => 'fashiolista', :uid =>'12944315'}
		@dummy_class.analyze("http://www.facebook.com/").should == {:source => 'facebook', :uid =>nil}
		@dummy_class.analyze("http://hello.blogspot.com/2013/09/tronchetti-mon-amour/?utm_source=rss&#038;utm_medium=rss&#038;utm_campaign=tronchetti-mon-amour").should == {:source => 'hello.blogspot', :uid => '/2013/09/tronchetti-mon-amour/'}
		@dummy_class.analyze("http://www.someunknownsite.com/?page=hello").should == {:source => 'someunknownsite.com', :uid => '/?page=hello'}
		@dummy_class.analyze("http://www.subdomain2.someunknownsite2.com/?page=hello").should == {:source => 'subdomain2.someunknownsite2.com', :uid => '/?page=hello'}
    end
end