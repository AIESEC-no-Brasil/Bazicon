module EXPAHelper
  class << self
    def auth(email, password)
      setup(email,password)
    end

    private

    def setup(email, password)
      expa = EXPA::Client.new
      expa.auth(email,password)
      EXPA.client=expa
    end
  end
end