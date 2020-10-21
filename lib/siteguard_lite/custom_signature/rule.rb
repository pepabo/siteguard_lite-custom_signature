module SiteguardLite
  module CustomSignature
    class Rule
      include ActiveModel::Validations

      attr_reader :name, :comment, :enable, :conditions, :filter_lifetime
      attr_accessor :action, :exclusion_action, :signature

      validates :name, bytesize: { maximum: 29 }
      validates :signature, bytesize: { maximum: 999 }
      validates :filter_lifetime, format: { with: /\A\d+\z/ }, allow_nil: true
      validates :action, inclusion: %w(BLOCK NONE WHITE FILTER)

      def initialize(args)
        @name = args[:name]
        @comment = args[:comment]
        @exclusion_action = args[:exclusion_action]
        @signature = args[:signature]
        @action = args[:action] || 'NONE'

        if @action == 'FILTER'
          @filter_lifetime = args[:filter_lifetime] || '300'
        else
          @filter_lifetime = nil
        end

        @enable = true

        @conditions = []
      end

      def add_condition(k, v, comparison_methods)
        @conditions << SiteguardLite::CustomSignature::Condition.new(k, v, comparison_methods)
      end

      def enable_str
        @enable ? 'ON' : 'OFF'
      end

      def action_str
        @action == 'FILTER' ? "#{@action}:#{@filter_lifetime}" : @action
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
    end
  end
end
