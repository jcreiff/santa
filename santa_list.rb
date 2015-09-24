class SantaList
  attr_reader :santas

  def initialize(santas)
    @santas = santas
  end

  def input_to_list
    santas.split("\n").map{|s| s.split(" ")}
  end

  def list_check  #uses array from input_to_list
    size = input_to_list.count/2
    input_to_list.group_by{|name| name[1]}.each do |k, v|
      raise ArgumentError, "Assignment Impossible" if v.count > size
    end
  end
end
