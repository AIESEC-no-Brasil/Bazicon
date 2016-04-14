module EXPAHelper
  class << self
    def auth(email, password)
      expa = setup
      expa.auth(email, password)
    end

    private

    def setup
      expa = if EXPA.client.nil?
               EXPA.setup()
             else
               EXPA.client= nil
               EXPA.setup()
             end
    end
  end
end