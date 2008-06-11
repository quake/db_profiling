require 'rubygems'
Gem::Specification.new do |s|
  s.name = 'db_profiling'
  s.version = '0.0.1'
  s.date = '2008-06-11'
  
  s.summary = "simple database query profiling tool"
    
  s.authors = ['Quake Wang']
  s.email = 'quake.wang@gmail.com'
  s.homepage = 'https://github.com/quake/db_profiling/wikis'
  
  s.has_rdoc = false
  s.extra_rdoc_files=["README"]
  
  s.files = Dir.glob("{lib}/**/*") 
end
