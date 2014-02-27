=begin
  See: https://github.com/hmans/slodown

  Usage:
  Markdowner.to_html(self.content)
    => formatter.complete
  
  Markdowner.to_html(self.content, { :markdown => true })
    => formatter.markdown

  Markdowner.to_html(self.content, { :coderay => true })
    => coderay(formatter.complete.to_s)

  Markdowner.to_html(self.content, { :coderay => true, :markdown => true })
    => coderay(formatter.markdown.to_s)
=end
class Markdowner
  # opts[:coderay] do highlight code.
  def self.coderay(text)
    text.gsub!(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
      code, lang = $3, $2
      code = code.to_s.gsub(/&lt;/, '<').gsub(/&gt;/, '>')
      CodeRay.scan(code, lang || :ruby).div(:css => :class)
    end
    text
  end

  def self.to_html(text, opts = {})
    if text.blank?
      return ""
    end

    formatter = Slodown::Formatter.new(text)

    if !!opts[:markdown]
      formatter = formatter.markdown
    end

    if !!opts[:autolink]
      formatter = formatter.autolink
    end

    if !!opts[:sanitize]
      formatter = formatter.sanitize
    end

    if opts.reject{|k| k == :coderay }.empty?
      formatter = formatter.complete
    end

    if !!opts[:coderay]
      formatter = coderay(formatter.to_s)
    end

    html = formatter.to_s

    # change <h1> headings to just emphasis tags
    html.gsub!(/<(\/)?h([^>]+)>/) {|_| "<#{$1}strong>" }

    # fix links that got the trailing punctuation appended to move it outside
    # the link
    html.gsub!(/<a ([^>]+)([\.\!\,])">([^>]+)([\.\!\,])<\/a>/) {|_|
      if $2.to_s == $4.to_s
        "<a #{$1}\" target='_blank'>#{$3}</a>#{$2}"
      else
        _
      end
    }

    # make links have rel=nofollow
    html.gsub!(/<a href/, "<a rel=\"nofollow\" href")

    # make @username link to that user's profile
    # if !opts[:disable_profile_links]
    #   html.gsub!(/\B\@([\w\-]+)/) do |u|
    #     if User.find_by_username(u[1 .. -1])
    #       "<a href=\"/u/#{u[1 .. -1]}\">#{u}</a>"
    #     else
    #       u
    #     end
    #   end
    # end

    html
  end
end
