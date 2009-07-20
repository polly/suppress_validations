module SuppressValidations
  def self.included(klass)
    ActiveRecord::Base.class_eval do
      extend ClassMethods
      alias_method :original_valid?, :valid?

      def valid?
        if self.class.validations_disabled?
          true
        else
          original_valid?
        end
      end
    end

    klass.send :include, InstanceMethods
  end
  
  module ClassMethods
    def disable_validations!
      @@validations_disabled = true
    end
    
    def enable_validations!
      @@validations_disabled = false
    end

    def validations_disabled?
      @@validations_disabled ||= false
    end
  end

  module InstanceMethods
    def suppress_validations
      ActiveRecord::Base.disable_validations!
      ret = yield
      ActiveRecord::Base.enable_validations!

      return ret
    end
  end
end
