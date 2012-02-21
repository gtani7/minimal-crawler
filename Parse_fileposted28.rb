#!/usr/bin/env ruby

require 'open-uri'
DIR2SCRAPE='fileposted_COMP';      

TIMENOW=Time.now();     YEARINSECS=365*24*60*60
                    ## GETOPT: should set DEPTH, DIR2SCRAPE in optparse 

module CSVutils
	def stripwww(urlstring)
        return '' if urlstring.nil?
        canonicalurl=CGI.unescape(urlstring)
        return canonicalurl if canonicalurl !~ /^http:/
		canonicalurl.sub!(/:\/\/www\./,'://')
		canonicalurl=canonicalurl.split(/#/)[0]  ## python: named anchor used to id each fuzzyman blog entry
		if canonicalurl[-1]==?/        ## changed in 1.9?
            canonicalurl=canonicalurl[0...-1]
		end
		return canonicalurl
	end
end
#
                                                    ## GETOPT:: <title> abov

starttime=Time.now              ##
class DelicParser
    include CSVutils
	attr_accessor(:htmlfilename, :re_vecoftags)
            ###### regexes
	@@re_url_desc=Regexp.new('<h6><a href="/book/(.*)" title')
        @@today=Time.now.strftime("%d_%m_%Y_%I_%p");
        @@headers_hash={"User-Agent" => "Mozilla/5.0 (Windows NT 6.2; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"}
	@@bk_title=Regexp.new('<div id="book_title">(.*?)</div>')
	@@bk_auth=Regexp.new('<span>Autor</span></td><td class="right-b-detalis-prodpage"><a href="http://ebooks.fileposted.com/author(.*?)</a></td></tr>')
	@@bk_categ=Regexp.new('<span>Categories</span></td><td class="right-b-detalis-prodpage"><a href="http://ebooks.fileposted.com/category/(.*?)</a></td></tr>')
	@@bk_isbn=Regexp.new('<span>ISBN</span></td><td class="right-b-detalis-prodpage">(.*?)</td></tr>')   ## capture 2 flds with <br>between
	@@bk_pages=Regexp.new('<span>Pages</span></td><td class="right-b-detalis-prodpage">(.*?)</td></tr>')
	@@bk_publr=Regexp.new('<span>Publisher</span></td><td class="right-b-detalis-prodpage"><a href="http://ebooks.fileposted.com/publisher/(.*?)</td></tr>')
	@@csvsep="~~~~"
    
    def initialize(htmlfilename)
        @out_fname= "fposted_scr_"+DIR2SCRAPE+"_"+@@today+".txt"	    ## GETOPT
        @@outfile=File.open(@out_fname,"a+");
        @htmlfilename=htmlfilename;        puts "@htmlfilename: "+ @htmlfilename.chomp
        @infile_arr_of_lines=IO.readlines(@htmlfilename)
        puts "l 46: @infile_arr_of_lines.size:: "+@infile_arr_of_lines.size.to_s.chomp          ##debug
	@counter_56=0; 
    end

    def re_parse
	@infile_arr_of_lines.each do |oneline|
	    @@re_url_desc.match oneline
	    if $1	    
	    	@counter_56+=1
		next if 0== @counter_56 % 2
		req_url="http://exampled.com/book/"+ $1
	#	puts "l 57: urlstub: " + $1			# DBG
	#	puts "l 58: getting file: "+req_url		#DEBg
		respbody=open(req_url, @@headers_hash).read
		puts "l 60: size respbody: " + respbody.size.to_s		#DEBg

		@@bk_title.match respbody
		bk_title= $1
		bk_title="TITLE Not Avail" if !bk_title

		@@bk_auth.match respbody ; bk_auth= $1
		bk_auth="Author Not Avail" if !bk_auth

		@@bk_categ.match respbody ; bk_categ= $1
		bk_categ="Category Not Avail" if !bk_categ

		@@bk_isbn.match respbody ; bk_isbn= $1 
		bk_isbn="ISBN Not Avail" if !bk_isbn

		@@bk_pages.match respbody ; bk_pages= $1
		bk_pages="Pages Not Avail" if !bk_pages

		@@bk_publr.match respbody  ; bk_publr= $1
		bk_publr ="Publisher Not Avail" if !bk_publr
		puts "l 69: title: " + bk_title			###### DBG
		puts "l 74: HTML file: " + @htmlfilename
		puts
	#	
		@@outfile.write( bk_title + @@csvsep + bk_auth + @@csvsep + bk_categ + @@csvsep + bk_isbn + @@csvsep + bk_pages + @@csvsep  + bk_publr + @@csvsep + @htmlfilename + "\n" ) 

	    	sleep(2.2)				######     edit
	    end        # if urlstub
        end      ## @infile_arr_of
	#@@outfile.close()			## 
    end  ## def #re_parse()
    
end    #class
        ##
Dir.chdir(".\\" + DIR2SCRAPE )  ##GETOPT

dirfile=Dir["*.html"]			## edit for file extensn
p "l 169: len(dirfile): " + dirfile.size.to_s
p File.new(dirfile[0]).mtime                                   ## DEBUG

count_delic_pages=Dir["*.html"].size
p "total delic pages to scr: "+ count_delic_pages.to_s

Dir["*.html"].each_with_index do |onehtmlfile, index|    ## edit this line : file ext
    puts "\n#{Time.now}: "+ onehtmlfile                                
    dc=DelicParser.new(onehtmlfile)
    dc.re_parse
    sleep(0.15)   ## 3/26/07: was: 0.5
end

###     cleanups: File, threads, database, netwk resources
p "\n#{Time.now}: "
p "#{Time.now- starttime} seconds: Finished!"
#end


       
