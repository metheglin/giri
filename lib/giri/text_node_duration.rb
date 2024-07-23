# https://www.w3.org/TR/xmlschema-2/#duration
class Giri::TextNodeDuration < Giri::TextNodeString

  def components
    @components ||= begin
      _, years, months, days, time_part, hours, minutes, seconds = self.match(/\AP(\d+Y)?(\d+M)?(\d+D)?(T(\d+H)?(\d+M)?(\d+S)?)?\z/).to_a
      {
        years: years.to_i,
        months: months.to_i,
        days: days.to_i,
        hours: hours.to_i,
        minutes: minutes.to_i,
        seconds: seconds.to_i,
      }
    end
  end

  def duration_time
    components.reduce(0) do |acc,(k,v)|
      acc + v.public_send(k)
    end
  end
end
