# Taken from https://gist.github.com/JonRowe/867423bab8201b1f852b

RSpec.configure do |config|
   config.register_ordering :global do |examples|
     acceptance, unit = examples.partition { |ex| ex.metadata[:feature] }
     unit + acceptance
  end
end
