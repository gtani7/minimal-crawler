require 'net/http'
require 'CGI'
require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Spider
    def initialize()
	    @@startfile=119  ;		    @@endfile=272 ; ## BUG
	    @@dir_to_write="./fileposted_BUS"
	    @@categ=1623  ## Computer
	    @@categ_name="BUS"
	    @@host="http://ebooks.fileposted.com"
	  ##  @@connect = Net::HTTP.start('ted.com', 80)
	    @@headers_hash={"User-Agent" => "Mozilla/5.0 (Windows NT 6.2; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"}


    end


def run_thru	  	 
    (@@startfile..@@endfile).each do   	|fileno|
	fmtfileno=("%03d" % fileno) 
	request=  "/category/" +@@categ.to_s+"/page/"+fileno.to_s
	#referer="http://eexample.com/
	#this_hhash=@@headers_hash + {"Referer" => }
	respbody=open(@@host + request, @@headers_hash).read
	local_fname = "#{@@dir_to_write}/#{@@categ_name}"+fmtfileno +".html"

	unless File.exists?(local_fname) 
	    File.open(local_fname, 'w'){|file| file.write(respbody)}	
	    puts "\t...Success, saved to #{local_fname}"
	end
	sleep 4.0
    end # .each
end # runthru    

end # Spider cls


spider=Spider.new()
spider.run_thru()

