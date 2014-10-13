
# 1. Initializes with a directory location, 
# 2. takes timestamps and contents of all HTML files in that directory, 
# 3. Uses template to dump all contents into new HTML file (in reeverse, with timestamp along for the ride)
 
class Blog   

  # def initialize
  # end

  def compile(directory_location)
  
    html_files = directory_location + '*.html'

    # sort html files in reverse chron order by creation time
    html_files_sorted = Dir[html_files].sort_by{ |f| File.ctime(f) }.reverse
    puts "I should be using ctime"

    post_id = 0
    posts_array = []

    Dir.glob(html_files_sorted) do |html_file|

      file = File.new(html_file, "r")

      created_at_time = File.ctime(file)

      this_post = Post.new
      this_post.filename = html_file
      this_post.timestamp = created_at_time

      this_post.formatted_time = created_at_time.strftime "%l:%M%P, %A, %b %d, %Y"

      while (line = file.gets)
        if this_post.content
          this_post.content = this_post.content + line
        else 
          this_post.content = line;
        end
      end

      posts_array << this_post

      file.close

      post_id = post_id + 1
    end

    posts_array.each do |post|
      puts "Re-publishing #{post.filename}"
    end

    return posts_array
  end

  def make_blog!(posts_array)
    puts "Creating new blog.html..."
    template_doc= File.open("lib/templates/blog.html.erb", "r")

    template = ERB.new(template_doc.read)
    
    File.open("../public_html/blog.html", "w") do |f|
        f.write(
          template.result(binding) # result is an ERB method. bidning means we're passing all local variables to the template. 
        )
      f.close
    end
    
  end

  def publish!(directory_location)
    @posts_array = self.compile(directory_location)

    self.make_blog!(@posts_array)

    puts "☢☢☢ Publishing was (probably) successful! ☢☢☢"
  end
  

end