God.watch do |w|
  w.name = "goodmood.cn.com"
  w.dir = "/alidata/www/six-five/script/export/"
  w.log = "/alidata/www/six-five/script/export/forager_goodmood.cn.log"
  w.start = "ruby forager_goodmood.cn.rb"

  w.keepalive(:interval => 10 , :memory_max => 300.megabytes, :cpu_max => 80.percent)
end
