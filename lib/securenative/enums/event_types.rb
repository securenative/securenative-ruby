# frozen_string_literal: true

module SecureNative
  module EventTypes
    LOG_IN = 'sn.user.login'
    LOG_IN_CHALLENGE = 'sn.user.login.challenge'
    LOG_IN_FAILURE = 'sn.user.login.failure'
    LOG_OUT = 'sn.user.logout'
    SIGN_UP = 'sn.user.signup'
    AUTH_CHALLENGE = 'sn.user.auth.challenge'
    AUTH_CHALLENGE_SUCCESS = 'sn.user.auth.challenge.success'
    AUTH_CHALLENGE_FAILURE = 'sn.user.auth.challenge.failure'
    TWO_FACTOR_DISABLE = 'sn.user.2fa.disable'
    EMAIL_UPDATE = 'sn.user.email.update'
    PASSWORD_REST = 'sn.user.password.reset'
    PASSWORD_REST_SUCCESS = 'sn.user.password.reset.success'
    PASSWORD_UPDATE = 'sn.user.password.update'
    PASSWORD_REST_FAILURE = 'sn.user.password.reset.failure'
    USER_INVITE = 'sn.user.invite'
    ROLE_UPDATE = 'sn.user.role.update'
    PROFILE_UPDATE = 'sn.user.profile.update'
    PAGE_VIEW = 'sn.user.page.view'
    VERIFY = 'sn.verify'
  end
end
