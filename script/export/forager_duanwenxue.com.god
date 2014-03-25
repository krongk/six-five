God.watch do |w|
  w.name = "forager_duanwenxue.com"
  w.dir = "/alidata/www/six-five/script/export/"
  w.log = "/alidata/www/six-five/script/export/forager_duanwenxue.com.log"
  w.start = "ruby forager_duanwenxue.com.rb"
  # w.pid_file = "/home/xuejiang/projects/forager/tickets/23037/log/findlaw_forager.pid"
  # w.behavior(:clean_pid_file)
  w.keepalive(:interval => 10 , :memory_max => 300.megabytes, :cpu_max => 80.percent)
end
