module SiteguardLite
  module CustomSignature
    class Condition
      include ActiveModel::Validations

      attr_reader :key, :value, :comparison_methods

      validates :value, bytesize: { maximum: 1999 }

      def initialize(k, v, comparison_methods)
        @key = k
        @value = v
        @comparison_methods = comparison_methods
      end

      # siteguardlite-320-0_nginx.pdf, p.52
      # [有効・無効]<タブ>[動作]<タブ><タブ>[シグネチャ名]<タブ>[検査対象] <タブ>[比較方法]<タブ> [検査文字列]<タブ><タブ>[コメント]
      def to_text(rule, last: false)
        validate!

        [
          rule.enable_str,
          rule.action,
          '',
          rule.name,
          @key,
          comparison_str(rule, last),
          @value,
          '',
          rule.comment,
        ].join("\t")
      end

      def to_hash
        {
          key: @key,
          value: @value,
          comparison_methods: @comparison_methods,
        }
      end

      private

      def comparison_str(rule, last)
        str = @comparison_methods.join(',')

        if last && rule.exclusion_action && rule.signature
          str << ",#{rule.exclusion_action}(#{rule.signature})"
        end

        str
      end
    end
  end
end
