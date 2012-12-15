require 'fileutils'
require 'digest/md5'
require 'redcarpet'
require 'pygments'

PYGMENTS_CACHE_DIR = File.expand_path('../../_cache', __FILE__)
FileUtils.mkdir_p(PYGMENTS_CACHE_DIR)

class Redcarpet2Markdown < Redcarpet::Render::HTML
  def block_code(code, lang)
    lang = lang || "text"
    path = File.join(PYGMENTS_CACHE_DIR, "#{lang}-#{Digest::MD5.hexdigest code}.html")
    cache(path) do
      colorized = Pygments.highlight(code, :options => {:encoding => 'utf-8'})
      add_code_tags(colorized, lang)
    end
  end

  def add_code_tags(code, lang)
    code.sub(/<pre>/, "<pre><code class=\"#{lang}\">").
         sub(/<\/pre>/, "</code></pre>")
  end

  def cache(path)
    if File.exist?(path)
      File.read(path)
    else
      content = yield
      File.open(path, 'w') {|f| f.print(content) }
      content
    end
  end

  def xheader(text, level)
    if (@rlevel == nil)
      @title  = text
      @rlevel = level
      header << "<section id=\"title\">\n"
      header << "<h1>#{text}</h1>\n"
    else
      if (@rlevel - level >= 0)
        header << "</section>\n" * (@rlevel - level + 1)
        @toc << "</li>\n" + "</ul>\n</li>\n" * (@rlevel - level) unless @toc.empty?
      else
        @toc << "<ul>\n" + "<li>\n<ul>\n" * (level - @rlevel - 1)
      end
 
      id = text.downcase.gsub(/\ /, '-')
      header << "<section id=\"#{id}\">\n"
      header << "<h#{level}>#{text}</h#{level}>\n"
 
      @toc << "<li>\n"
      @toc << "<a href=\"\##{id}\">#{text}</a>"
 
      @rlevel  = level
    end
    header
  end
end

class Jekyll::MarkdownConverter
  def extensions
    Hash[ *@config['redcarpet']['extensions'].map {|e| [e.to_sym, true] }.flatten ]
  end

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet2Markdown.new(extensions), extensions)
  end

  def convert(content)
    return super unless @config['markdown'] == 'redcarpet2'
    markdown.render(content)
  end
end
