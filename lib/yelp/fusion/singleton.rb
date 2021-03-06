module Yelp
  module Fusion
    module Singleton
      REQUEST_CLASSES = [Yelp::Fusion::Endpoint::Search,
                         Yelp::Fusion::Endpoint::Business,
                         Yelp::Fusion::Endpoint::Phone,
                         Yelp::Fusion::Endpoint::Review,
                         Yelp::Fusion::Endpoint::Transaction,
                         Yelp::Fusion::Endpoint::Match].freeze

      private

      # This goes through each endpoint class and creates singleton methods
      # on the client that query those classes. We do this to avoid possible
      # namespace collisions in the future when adding new classes
      def define_request_methods
        REQUEST_CLASSES.each do |request_class|
          endpoint_instance = request_class.new(self)
          create_methods_from_instance(endpoint_instance)
        end
      end

      # Loop through all of the endpoint instances' public singleton methods to
      # add the method to client
      def create_methods_from_instance(instance)
        instance.public_methods(false).each do |method_name|
          add_method(instance, method_name)
        end
      end

      # Define the method on the client and send it to the endpoint instance
      # with the args passed in
      def add_method(instance, method_name)
        define_singleton_method(method_name) do |*args|
          instance.public_send(method_name, *args)
        end
      end
    end
  end
end
