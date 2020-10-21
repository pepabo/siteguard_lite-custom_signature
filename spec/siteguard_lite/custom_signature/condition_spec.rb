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

  describe '#to_text' do
    let(:condition) { SiteguardLite::CustomSignature::Condition.new(key, value, comparison_methods) }
    let(:key) { 'URL' }
    let(:comparison_methods) { ['PCRE_CASELESS'] }
    let(:value) { 'value' }

    context 'when action is FILTER' do
      let(:rule) { SiteguardLite::CustomSignature::Rule.new(args) }
      let(:args) {
        {
          name: 'signature-name',
          action: 'FILTER',
          filter_lifetime: '300',
          comment: 'comment',
          exclusion_action: 'EXCLUDE_OFFICIAL',
          signature: '^.+$',
        }
      }

      subject { condition.to_text(rule) }
      it { is_expected.to match /#{args[:action]}:#{args[:filter_lifetime]}/ }
    end
  end
end
