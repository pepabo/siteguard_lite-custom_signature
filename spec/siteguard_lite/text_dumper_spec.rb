RSpec.describe SiteguardLite::CustomSignature::TextDumper do
  describe '.dump' do
    let(:rule_hash) {
      {
        name: 'name',
        comment: 'comment',
        exclusion_action: 'EXCLUDE_OFFICIAL',
        signature: '^.+$',
      }
    }
    let(:rule) { SiteguardLite::CustomSignature::Rule.new(rule_hash) }

    subject { SiteguardLite::CustomSignature::TextDumper.dump([rule]) }

    context 'when a rule is valid' do
      it 'not raise error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when a rule is invalid' do
      before { rule_hash[:name] = 'a' * 30 }
      it 'raise error' do
        expect { subject }.to raise_error ActiveModel::ValidationError
      end
    end

    context "when a rule's condition is invalid" do
      before { rule.add_condition('URL', 'a' * 2000, ['PCRD_CASELESS']) }
      it 'raise error' do
        expect { subject }.to raise_error ActiveModel::ValidationError
      end
    end
  end
end
