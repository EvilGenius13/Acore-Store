Rails.application.config.session_store :cookie_store, key: '_acore_store_session',
                                                      httponly: true,
                                                      secure: Rails.env.production?,
                                                      expire_after: 30.minutes