RSpec.describe SiteguardLite::CustomSignature::TextLoader do
  describe '.load_text' do
    context 'when a rule have one conditions' do
      let(:text) { <<~'EOD'}
        ON	NONE		exclude-traversal-3	PARAM_VALUE	PCRE_CASELESS,EXCLUDE_OFFICIAL(^traversal-3$)	//img\\.example\\.com/etc/		画像URLの一部として/etc/が含まれるときはtraversal-3を除外する
      EOD

      it 'load correctly' do
        rules = SiteguardLite::CustomSignature::TextLoader.load(text)
        expect(rules).to be_kind_of Array
        expect(rules.length).to eq 1
        expect(rules[0].name).to eq 'exclude-traversal-3'
        expect(rules[0].comment).to eq '画像URLの一部として/etc/が含まれるときはtraversal-3を除外する'
        expect(rules[0].enable).to eq true
        expect(rules[0].exclusion_action).to eq 'EXCLUDE_OFFICIAL'
        expect(rules[0].signature).to eq '^traversal-3$'
        expect(rules[0].conditions.length).to eq 1
        expect(rules[0].conditions[0].key).to eq 'PARAM_VALUE'
        expect(rules[0].conditions[0].value).to eq '//img\\\\.example\\\\.com/etc/'
        expect(rules[0].conditions[0].comparison_methods).to eq ['PCRE_CASELESS']
      end
    end

    context 'when a rule have two conditions' do
      let(:text) { <<~'EOD' }
        ON	NONE		exclude-xss-try-1	URL	PCRE_CASELESS	^http://example\\.com		paramパラメータでxss-try-1を除外
        ON	NONE		exclude-xss-try-1	PARAM_NAME	PCRE_CASELESS,AND,EXCLUDE_OFFICIAL(^xss-try-1$)	^param$		paramパラメータでxss-try-1を除外
      EOD

      it 'load correctly' do
        rules = SiteguardLite::CustomSignature::TextLoader.load(text)
        expect(rules).to be_kind_of Array
        expect(rules.length).to eq 1
        expect(rules[0].name).to eq 'exclude-xss-try-1'
        expect(rules[0].comment).to eq 'paramパラメータでxss-try-1を除外'
        expect(rules[0].enable).to eq true
        expect(rules[0].exclusion_action).to eq 'EXCLUDE_OFFICIAL'
        expect(rules[0].signature).to eq '^xss-try-1$'
        expect(rules[0].conditions.length).to eq 2
        expect(rules[0].conditions[0].key).to eq 'URL'
        expect(rules[0].conditions[0].value).to eq '^http://example\\\\.com'
        expect(rules[0].conditions[0].comparison_methods).to eq ['PCRE_CASELESS']
        expect(rules[0].conditions[1].key).to eq 'PARAM_NAME'
        expect(rules[0].conditions[1].value).to eq '^param$'
        expect(rules[0].conditions[1].comparison_methods).to eq ['PCRE_CASELESS', 'AND']
      end
    end
  end
end
