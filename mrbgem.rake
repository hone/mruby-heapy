MRuby::Gem::Specification.new('mruby-heapy') do |spec|
  spec.license = 'MIT'
  spec.author  = 'MRuby Developer'
  spec.summary = 'mruby-heapy'
  spec.bins    = ['mruby-heapy']

  spec.add_dependency 'mruby-print', :core => 'mruby-print'
  spec.add_dependency 'mruby-mtest', :mgem => 'mruby-mtest'
  spec.add_dependency 'mruby-json',  :mgem => 'mruby-json'
  spec.add_dependency 'mruby-string-ext', :core => 'mruby-string-ext'
end
