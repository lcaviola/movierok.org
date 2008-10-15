xml.instruct! :xml, :version => "1.0" 
xml.rips do
  for r in @rips
    xml.rip do
      xml.id r.id
      xml.titile r.movie.title
      xml.image r.movie.image
    end
  end
end