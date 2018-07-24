RSpec.describe SiteguardLite::CustomSignature::Condition do
  describe '.valid?' do
    let(:condition) { SiteguardLite::CustomSignature::Condition.new(key, value, comparison_methods) }
    let(:key) { 'URL' }
    let(:comparison_methods) { ['PCRE_CASELESS'] }

    subject { condition.valid? }

    describe 'value' do
      context 'when length is 1999 bytes' do
        let(:value) { 'v' * 1999 }
        it { is_expected.to eq true }
      end

      context 'when length is 2000 bytes' do
        let(:value) { 'v' * 2000 }
        it { is_expected.to eq false }
      end
    end
  end
end
