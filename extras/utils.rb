class Utils
  #random generate strings
  #Use on site unique name
  def self.random_str(len)
    str = ""
    while str.length < len
      chr = OpenSSL::Random.random_bytes(1)
      ord = chr.unpack('C')[0]

      #          0            9              A            Z              a            z
      if (ord >= 48 && ord <= 57) || (ord >= 65 && ord <= 90) || (ord >= 97 && ord <= 122)
        str += chr
      end
    end

    return str
  end

  def silence_stream(*streams)
    on_hold = streams.collect {|stream| stream.dup }
    streams.each do |stream|
      stream.reopen("/dev/null")
      stream.sync = true
    end
    yield
  ensure
    streams.each_with_index do |stream, i|
      stream.reopen(on_hold[i])
    end
  end
end