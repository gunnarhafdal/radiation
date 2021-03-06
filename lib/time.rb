class Time
  
   # tzstring e.g. 'America/Los_Angeles'

  def in_timezone(tzstring)
    if tzstring == '' || tzstring == nil
      e = Time.new
    else
      tz = TZInfo::Timezone.get tzstring
      p = tz.period_for_utc self
      e = self.localtime(p.utc_offset)

      if e.isdst
        e = e + 60*60
      end
    end
     e
  end

end