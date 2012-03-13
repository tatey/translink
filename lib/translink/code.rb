module Translink
  module Code
    BRISBANE = ('100'..'499').to_a + ['LOOP', 'GLIDER']

    def self.brisbane? code
      BRISBANE.include? code.to_s
    end
  end
end
