require 'spec_helper'

describe Format do
  it { should validate_presence_of(:class_name) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:method) }
end
