#!/usr/bin/env ruby

require 'open-uri'
DIR2SCRAPE='fp_eng_DONE';      

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
	@@csvsep="~~~~"
    
    def initialize(htmlfilename)
        #@out_fname= "fposted_scr_"+DIR2SCRAPE+"_"+@@today+".txt"	    ## GETOPT
        #@@outfile=File.open(@out_fname,"a+");
        @htmlfilename=htmlfilename;        puts "@htmlfilename: "+ @htmlfilename.chomp
        @infile_arr_of_lines=IO.readlines(@htmlfilename)
        puts "l 46: @infile_arr_of_lines.size:: "+@infile_arr_of_lines.size.to_s.chomp          ##debug
	@counter_56=0; 
    end

    def re_parse
	@infile_arr_of_lines.each do |oneline|
		@counter_56 +=1
		splitln=oneline.split(@@csvsep)
		if 7!=splitln.size
		    puts "not 7 fields: Line "+	@counter_56.to_s
		end	
		if (splitln[3] !~ /\d+<br>\d+/ && splitln[3] !~ /Not Avail/)
		    puts "Prob w/ISBN field formattg: Line "+	@counter_56.to_s
		end	
        end      ## @infile_arr_of
	#@@outfile.close()			## 
    end  ## def #re_parse()
    
end    #class
        ##
Dir.chdir(".\\" + DIR2SCRAPE )  ##GETOPT

dirfile=Dir["PT*.txt"]			## edit for file extensn
p "l 169: len(dirfile): " + dirfile.size.to_s
p File.new(dirfile[0]).mtime                                   ## DEBUG

count_delic_pages=Dir["*.txt"].size
p "total delic pages to scr: "+ count_delic_pages.to_s

Dir["PT*.txt"].each_with_index do |onehtmlfile, index|    ## edit this line : file ext
    puts "\n#{Time.now}: "+ onehtmlfile                                
    dc=DelicParser.new(onehtmlfile)
    dc.re_parse
    sleep(0.15)   ## 3/26/07: was: 0.5
end

###     cleanups: File, threads, database, netwk resources
p "\n#{Time.now}: "
p "#{Time.now- starttime} seconds: Finished!"
#end


       
