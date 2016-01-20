require 'spec_helper'
describe 'uplink' do

  context 'with defaults for all parameters' do
    it { should contain_class('uplink') }
  end
end
