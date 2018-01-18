module Simple
  include DevOn
  Config.on "simple" do
    custom do 
      setting "custom-setting"
    end
  end
end
