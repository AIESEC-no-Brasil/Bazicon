RSpec::Matchers.define :expose do |variable|
  match do |controller|
    expect(controller).to respond_to variable
  end

  chain :as do |test|
    expect(controller.send variable).to eq test
  end

  chain :as_collection do |test|
    expect(controller.send variable).to match_array test
  end

  chain :as_a_new do |test|
    expect(controller.send variable).to be_a_new(test)
  end
end
