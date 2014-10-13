
class Blog   

  def compile(directory_location_of_posts)
  
    html_files = directory_location_of_posts + '*.html'

    # sort html files in reverse chron order by creation time
    html_files_sorted = Dir[html_files].sort_by{ |f| 
      File.basename(f)
    }.reverse
    puts "I should be sorting by basename"

    post_id = 0
    posts_array = []

    Dir.glob(html_files_sorted) do |file_location|

      file = File.new(file_location, "r")

  
      this_post = Post.new
      this_post.file_location = file_location

      # the following two lines could probably be refactored
      this_post.creation_datetime_obj = this_post.get_datetime_object(file_location)

      this_post.formatted_time = this_post.get_formatted_timestamp(this_post.creation_datetime_obj) #  .strftime "%l:%M%P, %A, %b %d, %Y"

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
      puts "Re-publishing #{post.file_location}"
    end

    return posts_array
  end

  def make_blog!(posts_array)
    @posts_array = posts_array

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

  def publish!(directory_location_of_posts)
    posts_array = self.compile(directory_location_of_posts)

    self.make_blog!(posts_array)

    puts "☢☢☢ Publishing was (probably) successful! ☢☢☢"
  end
  

end