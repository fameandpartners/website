namespace :style_profiles do
  namespace :users do
    task :migrate => :environment do
      basic_styles = UserStyleProfile::BASIC_STYLES

      UserStyleProfile.all.each do |style_profile|
        total = 0
        factor = style_profile.attributes.slice(*basic_styles).values.sum / 10.0

        basic_styles.each do |attribute|
          points = (style_profile.send(attribute) / factor).round(2)

          if total >= 10
            points = 0
          elsif (points + total) > 10
            points = (10.0 - total).round(2)
          elsif basic_styles.last.eql?(attribute) && (total + points) < 10
            points = (10.0 - total).round(2)
          end

          style_profile.send("#{attribute}=", points)
          total = (total + points).round(2)
        end

        style_profile.save
      end
    end
  end

  namespace :products do
    task :migrate => :environment do
      basic_styles = UserStyleProfile::BASIC_STYLES

      ProductStyleProfile.all.each do |style_profile|
        total = 0
        factor = style_profile.attributes.slice(*basic_styles).values.sum / 10.0

        next if factor.eql?(0.0)

        basic_styles.each do |attribute|
          points = (style_profile.send(attribute) / factor).round

          if total >= 10
            points = 0
          elsif (points + total) > 10
            points = 10 - total
          elsif basic_styles.last.eql?(attribute) && (total + points) < 10
            points = 10 - total
          end

          style_profile.send("#{attribute}=", points)
          total += points
        end

        style_profile.save
      end
    end
  end
end
