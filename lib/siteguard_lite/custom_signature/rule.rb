module SiteguardLite
  module CustomSignature
    class Rule
      include ActiveModel::Validations

      attr_reader :name, :action, :comment, :enable, :conditions
      attr_accessor :exclusion_action, :signature, :action, :filter_lifetime

      validates :name, bytesize: { maximum: 29 }
      validates :signature, bytesize: { maximum: 999 }
      validates :action, inclusion: %w(BLOCK NONE WHITE FILTER)

      def initialize(args)
        @name = args[:name]
        @comment = args[:comment]
        @exclusion_action = args[:exclusion_action]
        @signature = args[:signature]
        @action = args[:action] || 'NONE'
        @filter_lifetime = args[:filter_lifetime] || '300' # default 300sec

        @enable = true

        @conditions = []
      end

      def add_condition(k, v, comparison_methods)
        @conditions << SiteguardLite::CustomSignature::Condition.new(k, v, comparison_methods)
      end

      def enable_str
        @enable ? 'ON' : 'OFF'
      end

      def to_text
        validate!

        texts = []
        last_idx = @conditions.length - 1
        @conditions.each_with_index do |condition, idx|
          texts << condition.to_text(self, last: idx == last_idx)
        end
        texts.join("\n")
      end

      def to_hash
        {
          name: @name,
          action: @action,
          filter_lifetime: @filter_lifetime,
          comment: @comment,
          exclusion_action: @exclusion_action,
          signature: @signature,
          conditions: @conditions.map { |c| c.to_hash },
        }
      end

      def to_action_filter(action)
        action.include?('FILTER') ? 'FILTER' : action
      end

      def to_filter_lifetime(filter_lifetime)
        filter_lifetime.include?('FILTER') ? filter_lifetime.delete('FILTER:') : nil
      end
    end
  end
end
