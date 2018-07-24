module SiteguardLite
  module CustomSignature
    class YamlLoader
      def self.load(yaml)
        y = ::YAML.load(yaml)
        rules = []
        y['rules'].each do |r|
          rule = SiteguardLite::CustomSignature::Rule.new(
            name: r['name'],
            comment: r['comment'],
            exclusion_action: r['exclusion_action'],
            signature: r['signature']
          )
          r['conditions'].each do |c|
            rule.add_condition(c['key'], c['value'], c['comparison_methods'])
          end
          rules << rule
        end
        rules
      end
    end
  end
end
