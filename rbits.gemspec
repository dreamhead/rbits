require 'rubygems'

SPEC = Gem::Specification.new do |s|
	s.name		= 'rbits'
	s.version	= '0.1'
	s.author	= 'Ye Zheng'
	s.email		= 'dreamhead.cn@gmail.com'
	s.homepage	= 'http://dreamhead.blogbus.com'
	s.platform	= Gem::Platform::RUBY
	s.summary	= 'A library for easy access binary'
	s.files		= Dir.glob("{lib, spec}/**/*")
	s.require_path	= 'lib'
end
