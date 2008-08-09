xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "movierok.org"
    xml.description meta_description
    xml.link rss_url

    for rip in @rips
      xml.item do
        xml.title rip.movie.title
        xml.description meta_description(rip)
        xml.pubDate rip.created_at.to_s(:rfc822)
        xml.link rip_url(rip)
        xml.guid rip_url(rip)
      end
    end
  end
end