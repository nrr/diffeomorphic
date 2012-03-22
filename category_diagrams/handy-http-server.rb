#! /usr/bin/env ruby

%w{rubygems sinatra pp}.map do |r|
  require r
end

lambda do
  content_type "text/plain"
  pp request
  "That sure is a thing."
end.tap do |x|
  [:get, :post].map do |m|
    self.send(m, %r{.*}, &x)
  end
end
