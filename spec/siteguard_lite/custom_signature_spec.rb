require 'tempfile'

RSpec.describe SiteguardLite::CustomSignature do
  it 'has a version number' do
    expect(SiteguardLite::CustomSignature::VERSION).not_to be nil
  end

  let(:sig) { SiteguardLite::CustomSignature.new }

  describe '.load_yaml' do
    let(:yaml) { File.read('spec/fixtures/sig_custom.yaml') }

    it 'load yaml format data' do
      rules = SiteguardLite::CustomSignature.load_yaml(yaml)
      expect(rules).to be_kind_of Array
      expect(rules.length).to eq 5
    end
  end

  describe '.load_text' do
    let(:text) { File.read('spec/fixtures/sig_custom.txt') }

    it 'load text format data' do
      rules = SiteguardLite::CustomSignature.load_text(text)
      expect(rules).to be_kind_of Array
      expect(rules.length).to eq 5
    end
  end

  describe '.dump_yaml' do
    let(:text) { File.read('spec/fixtures/sig_custom.txt') }
    let(:rules) { SiteguardLite::CustomSignature.load_text(text) }

    it 'dump as yaml format' do
      yaml = SiteguardLite::CustomSignature.dump_yaml(rules)
      expect(yaml).to be_kind_of String
    end
  end

  describe '.dump_text' do
    let(:yaml) { File.read('spec/fixtures/sig_custom.yaml') }
    let(:rules) { SiteguardLite::CustomSignature.load_yaml(yaml) }

    it 'dump as text format' do
      text = SiteguardLite::CustomSignature.dump_text(rules)
      expect(text).to be_kind_of String
    end

    context 'when load and dump' do
      let(:text) { File.read('spec/fixtures/sig_custom.txt') }
      let(:rules) { SiteguardLite::CustomSignature.load_text(text) }

      it 'is same' do
        expect(SiteguardLite::CustomSignature.dump_text(rules)).to eq text
      end
    end
  end

    # .txt --load_text/dump_yaml--> .yaml --load_yaml/dump_text--> .txt
  context 'when convert text format data back through yaml format' do
    let(:text1) { File.read('spec/fixtures/sig_custom.txt') }

    it 'is same' do
      rules1 = SiteguardLite::CustomSignature.load_text(text1)
      text2 = ''
      Tempfile.create do |yaml_file|
        File.write(yaml_file, SiteguardLite::CustomSignature.dump_yaml(rules1))
        rules2 = SiteguardLite::CustomSignature.load_yaml(File.read(yaml_file.path))
        text2 = SiteguardLite::CustomSignature.dump_text(rules2)
      end
      expect(text2).to eq text1
    end
  end
end
