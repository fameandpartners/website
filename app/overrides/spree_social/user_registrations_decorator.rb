Deface::Override.all[:"spree/user_registrations/new"].delete('add_socials_to_login_extras')
Deface::Override.all[:"spree/user_registrations/new"].delete('remove_new_customer_if_sessionomniauth')
Deface::Override.all[:"spree/user_sessions/new"].delete('add_socials_to_login_extras')
