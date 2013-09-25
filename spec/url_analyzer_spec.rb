# -*- encoding: utf-8 -*-

require 'url-analyzer'

class DummyClass
end

describe UrlAnalyzer do
	before(:each) do
	  @dummy_class = DummyClass.new
	  @dummy_class.extend(UrlAnalyzer)
	end

	it "should get valid source and uid given a url" do
		@dummy_class.analyze("http://www.youtube.com/watch?v=9bZkp7q19f0").should == {:source=>'youtube', :uid=>'9bZkp7q19f0'}
		@dummy_class.analyze("http://lookbook.nu/look/5384932-Choies-Coat-Shirt-Romwe-Bag-Hat-Inspired-By-Freja-Beha").should == {:source => 'lookbook', :uid =>'5384932'}
		@dummy_class.analyze("http://www.shareasale.com/r.cfm?b=393018&u=314743&m=41271&afftrack=skim34712X927925Xea9dfabecfd3bfab249967985e2441f9&urllink=www.abc.com%2Fproduct%2Fadd-asa-dadsa").should == {:source => 'shareasale', :uid =>'skim34712X927925Xea9dfabecfd3bfab249967985e2441f9'}
		@dummy_class.analyze("http://www.fashiolista.com/item/12944315/").should == {:source => 'fashiolista', :uid =>'12944315'}
		@dummy_class.analyze("http://www.facebook.com/").should == {:source => 'facebook', :uid =>nil}
    end
end