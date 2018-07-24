require "active_model"
require "yaml"

require "siteguard_lite/custom_signature/version"
require "siteguard_lite/custom_signature/bytesize_validator"
require "siteguard_lite/custom_signature/rule"
require "siteguard_lite/custom_signature/condition"
require "siteguard_lite/custom_signature/yaml_dumper"
require "siteguard_lite/custom_signature/yaml_loader"
require "siteguard_lite/custom_signature/text_dumper"
require "siteguard_lite/custom_signature/text_loader"

module SiteguardLite
  module CustomSignature
    class << self
      def load_yaml(yaml)
        YamlLoader.load(yaml)
      end

      def load_text(text)
        TextLoader.load(text)
      end

      def dump_yaml(rules)
        YamlDumper.dump(rules)
      end

      def dump_text(rules)
        TextDumper.dump(rules)
      end
    end
  end
end
