module PartialObject
  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
    def initialize(args = {})
      @_args = args
    end

    def partial(args = {})
      self.class.new(@_args.merge(args))
    end
  end

  module ClassMethods
    def required_parameter(*parameter_names)
      parameter_names.each do |parameter_name|
        define_method(parameter_name){
          raise ArgumentError.new("the argument #{parameter_name} is required") unless @_args.has_key? parameter_name
          @_args[parameter_name]
        }
      end
    end

    def optional_parameter(*parameter_names)
      parameter_names.each do |parameter_name|
        define_method(parameter_name){
          @_args[parameter_name]
        }
      end
    end
  end
end
