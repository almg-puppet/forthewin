require 'spec_helper'
describe 'forthewin' do

  context 'with defaults for all parameters' do
    it { should contain_class('forthewin') }
  end
end
