module Rojam
  class LabelManager
    def initialize
      @labels = {}
    end

    def size
      @labels.size
    end

    def [](index)
      @labels[index] || newlabel(index)
    end

    private
    def newlabel(index)
      @labels[index] = Label.new
    end
  end
end
