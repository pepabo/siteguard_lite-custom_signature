RSpec.describe SiteguardLite::CustomSignature::Rule do
  let(:rule) { SiteguardLite::CustomSignature::Rule.new(args) }
  let(:args) {
    {
      name: 'signature-name',
      action: 'NONE',
      comment: 'comment',
      exclusion_action: 'EXCLUDE_OFFICIAL',
      signature: '^.+$',
    }
  }

  describe '.valid?' do
    subject { rule.valid? }

    describe 'name' do
      context 'when length is 29 characters' do
        before { args[:name] = 'a' * 29 }
        it { is_expected.to eq true }
      end

      context 'when length is 30 characters' do
        before { args[:name] = 'a' * 30 }
        it { is_expected.to eq false }
      end
    end

    describe 'action' do
      context 'when valid action value' do
        before { args[:action] = 'BLOCK' }
        it { is_expected.to eq true }
      end

      context 'when invalid action value' do
        before { args[:action] = 'ERROR' }
        it { is_expected.to eq false }
      end
    end

    describe 'signature' do
      context 'when length is 999 bytes' do
        before { args[:signature] = 'a' * 999 }
        it { is_expected.to eq true }
      end

      context 'when length is 1000 bytes' do
        before { args[:signature] = 'a' * 1000 }
        it { is_expected.to eq false }
      end

      context 'when blank' do
        before { args[:signature] = nil }
        it { is_expected.to eq true }
      end
    end
  end

  describe 'filter_lifetime' do
    subject { rule.filter_lifetime }

    context 'action is not FILTER' do
      before { args[:action] = 'BLOCK' }
      it { is_expected.to be_nil }
    end

    context 'action is FILTER' do
      before { args[:action] = 'FILTER' }

      context 'filter_lifetime is not set' do
        before { args[:filter_lifetime] = nil }
        it { is_expected.to eq 300 }
      end

      context 'filter_lifetime is set' do
        before { args[:filter_lifetime] = 500 }
        it { is_expected.to eq 500 }
      end
    end
  end
end
