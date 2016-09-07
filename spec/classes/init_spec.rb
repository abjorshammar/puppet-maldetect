require 'spec_helper'
describe 'maldetect' do
  context 'with default values for all parameters' do
    it { should contain_class('maldetect') }
  end
end
