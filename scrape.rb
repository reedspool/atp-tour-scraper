require 'kimurai'

$filename = "tournament_titles.csv";

class ATPTourSpider < Kimurai::Base
  @name = "ATP Tour Spider"
  @engine = :selenium_chrome
  @config = {
    before_request: { delay: 1..4 }
  }
  @start_urls = []

  (0..10000).each do |n|
    @start_urls << "https://www.atptour.com/en/scores/archive/pickledonkeyknife/#{n}/2019/results"
  end

  #throw "File #{$filename} would be overwritten" if File.exist?($filename)

  @@file = File.new($filename, "w");
  @@file << "\"id\", \"title\"\n";

  def parse(response, url:, data: {})
    title_parts = response.xpath("//title").text.split('|')
    title = title_parts.length == 4 ? title_parts[0] : "N/A"
    id = url.split('/')[7]

    # Remove newlines, and only take the name from the tour
    @@file << "\"#{id}\", \"#{title.strip}\"\n"
  end
end

ATPTourSpider.crawl!