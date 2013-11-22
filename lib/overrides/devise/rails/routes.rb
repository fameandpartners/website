module ActionDispatch::Routing
  class Mapper
    def set_omniauth_path_prefix!(path_prefix)
      ::OmniAuth.config.path_prefix = path_prefix unless ::OmniAuth.config.path_prefix
    end
  end
end
