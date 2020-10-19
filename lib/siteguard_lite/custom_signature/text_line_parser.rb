module SiteguardLite
  module CustomSignature
    class TextLineParser
      # siteguardlite-320-0_nginx.pdf, p.52
      # [有効・無効]<タブ>[動作]<タブ><タブ>[シグネチャ名]<タブ>[検査対象] <タブ>[比較方法]<タブ> [検査文字列]<タブ><タブ>[コメント]
      def parse(line)
        fields = line.split("\t")
        {
          enable: enable(fields[0]),
          action: fields[1],
          filter_lifetime: fields[2],
          name: fields[3],
          comment: fields[8],
          exclusion_action: exclusion_action(fields[5]),
          signature: signature(fields[5]),
          condition: {
            key: fields[4],
            comparison_methods: comparison_methods(fields[5]),
            value: fields[6],
          }
        }
      end

      private

      def enable(str)
        str == 'ON'
      end

      def exclusion_action(comparison_str)
        parse_comparison_str(comparison_str)[:exclusion_action]
      end

      def signature(comparison_str)
        parse_comparison_str(comparison_str)[:signature]
      end

      def comparison_methods(comparison_str)
        parse_comparison_str(comparison_str)[:comparison_methods]
      end

      def parse_comparison_str(str)
        return @parsed_comarison_str if @parsed_comparison_str

        result = {
          comparison_methods: [],
          exclusion_action: nil,
          signature: nil,
        }

        # TODO: Make it possible to handle other comparison methods and exclusion actions
        str.split(',').each do |part|
          case part
          when /\AEXCLUDE_OFFICIAL\((.+)\)\z/
            result[:exclusion_action] = 'EXCLUDE_OFFICIAL'
            result[:signature] = Regexp.last_match(1)
          else
            result[:comparison_methods] << part
          end
        end

        @parsed_comarison_str = result
      end
    end
  end
end
