module ExtendRubySdk
  class ErrorResult
    def initialize(code, message)
      @code = code
      @message = message
    end
    attr_reader :code, :message
  end
end
