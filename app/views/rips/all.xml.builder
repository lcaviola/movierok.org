xml.instruct! :xml, :version => "1.0" 
xml.rips do
  for r in @rips
    xml.rip do
      xml.id r.id
      xml.omdb r.omdb
      xml.title r.movie.title
      xml.image r.movie.image
      xml.releaser r.releaser
      xml.parts do
        for p in r.parts
          xml.mrokhash p.mrokhash
        end
      end
    end
  end
end