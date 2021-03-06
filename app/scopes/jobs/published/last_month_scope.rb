# frozen_string_literal: true

module Jobs
  module Published
    # TODO: documentation is missing for this class
    # We should consider addig some documentation here
    class LastMonthScope < BaseScope
      def call
        scope
          .where('created_at::date < ?', TimeUtility.last_week)
          .where('created_at::date >= ?', TimeUtility.last_month)
      end
    end
  end
end
