module Spira
  def settings
    @settings||={:some=>Thread.current.inspect}
  end
  module_function :settings
end

