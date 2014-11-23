
class Post
  attr_accessor :file_location, :permalink, :creation_datetime_obj, :formatted_time, :timestring, :content

  def create(new_post_name, post_type)

    # clean new_post_name
    if (new_post_name[-5..-1] == ".html")
      new_post_name = new_post_name[0..-5]
    elsif (new_post_name[-6..-1] == ".mdown")
      new_post_name = new_post_name[0..-6]
    elsif (new_post_name[-4..-1] == ".htm")
      new_post_name = new_post_name[0..-4]
    end
    
    new_post_name = new_post_name.strip.gsub(' ', '-').gsub('?', '').gsub('.', '').gsub('!', '').gsub(':', '').gsub('"', '').gsub("'", "").gsub(":", "-").gsub(";","-").gsub("(", "").gsub(")", "")


    # Add file extension
    if post_type == "html"
      new_post_name = new_post_name + ".html"
    elsif post_type == "markdown"
      new_post_name = new_post_name + ".mdown"
    end

    # Add current time
    # current_time = Time.new.in_timezone('America/New_York')
    current_time = Time.new.in_timezone($my_timezone)
    
    @file_name = current_time.strftime "%Y-%m-%dT%H+%M+%S-" + new_post_name

    # If you're getting date parsing error because of spaces turning up in your file names somehow
    # try uncommenting the line below
    # @file_name = @file_name.gsub(' ', '0')

    # create a blank file  
    new_post = File.new("../radiation_posts/#{@file_name}", 'w')
    new_post.close
  end

  def edit
    system "#{$my_text_editor_command} ../radiation_posts/#{@file_name}"
  end

  def get_datetime_object(file_location)
    # I just shove the full file_location into DateTime.parse, with a gsub for the time colons, and it works like magic
    Time.parse(file_location.gsub('+', ':')).in_timezone($my_timezone)
  end

  def get_formatted_timestamp(datetime_object)
    datetime_object.strftime "%l:%M%P, %A, %b %d, %Y"
  end

  def get_timestring(datetime_object)
    datetime_object.strftime "%Y-%m-%dT%H:%M:%S%z"
  end
end 
