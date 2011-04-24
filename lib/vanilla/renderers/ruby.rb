module Vanilla::Renderers
  # Snips that render_as "Ruby" should define a class.
  # The class should have instance methods for any HTTP request methods that the dynasnip
  # should respond to, i.e. get(), post(), and so on.
  # Alternatively, it can respond to 'handle'.
  #
  # The result of the method invocation always has #to_s called on it.
  # The last line of the content should be the name of that class, so that it
  # is returned by "eval" and we can instantiate it.
  # If the dynasnip needs access to the 'context' (i.e. probably the request
  # itself), it should be a subclass of Dynasnip (or define an initializer
  # that accepts the context as its first argument).
  class Ruby < Base
    def prepare(snip, part=:content, args=[], enclosing_snip=snip)
      @args = args
      @snip = snip
      @enclosing_snip = enclosing_snip
    end
    
    def process_text(content)
      handler_klass = eval(content, binding, @snip.name)
      instance = if handler_klass.ancestors.include?(Vanilla::Renderers::Base)
        handler_klass.new(app)
      else
        handler_klass.new
      end
      instance.enclosing_snip = @enclosing_snip if instance.respond_to?(:enclosing_snip)

      if app.request && (method = app.request.method) && instance.respond_to?(method)
        message = method
      else
        message = :handle
      end
      if @args.is_a?(Array)
        instance.send(message, *@args).to_s
      else
        instance.send(message, @args).to_s
      end
    end
  end
end
