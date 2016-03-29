class ConvertPageVariables < ActiveRecord::Migration
  def up
    Revolution::Page.all.each do |p|
      v = p.variables
      v[:pids] = v[:pids].join(',') if v.has_key?(:pids) && !(v[:pids].is_a? String)
      v =  Hash[ v.map { |key, value| [key, value.to_s] } ]
      p.variables = v
      p.save!
    end
  end

  def down
  end
end
