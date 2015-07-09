require 'find'
require 'base64'
require 'json'

t = 'std'
min_zoom = 0
max_zoom = 18
ext = 'png'

out = File.open("#{t}.serialtiles", 'w')
out.print "JSONBREAKFASTTIME\n"
out.print JSON.dump({:tilejson => ''}), "\n"
min_zoom.upto(max_zoom) {|z|
  Find.find(z.to_s) {|path| 
    next unless path.end_with?(ext)
    (z, x, y) = path.split('/').map{|v| v.to_i}
    out.print JSON.dump({:z => z, :x => x, :y => y, 
      :mtime => File.mtime(path), 
      :buffer => Base64.strict_encode64(File.open(path).read)}), "\n"
  }
}
out.close
