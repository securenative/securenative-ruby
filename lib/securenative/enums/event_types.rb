module EventTypes
  LOG_IN = 'sn.user.login'.freeze
  LOG_IN_CHALLENGE = 'sn.user.login.challenge'.freeze
  LOG_IN_FAILURE = 'sn.user.login.failure'.freeze
  LOG_OUT = 'sn.user.logout'.freeze
  SIGN_UP = 'sn.user.signup'.freeze
  AUTH_CHALLENGE = 'sn.user.auth.challenge'.freeze
  AUTH_CHALLENGE_SUCCESS = 'sn.user.auth.challenge.success'.freeze
  AUTH_CHALLENGE_FAILURE = 'sn.user.auth.challenge.failure'.freeze
  TWO_FACTOR_DISABLE = 'sn.user.2fa.disable'.freeze
  EMAIL_UPDATE = 'sn.user.email.update'.freeze
  PASSWORD_REST = 'sn.user.password.reset'.freeze
  PASSWORD_REST_SUCCESS = 'sn.user.password.reset.success'.freeze
  PASSWORD_UPDATE = 'sn.user.password.update'.freeze
  PASSWORD_REST_FAILURE = 'sn.user.password.reset.failure'.freeze
  USER_INVITE = 'sn.user.invite'.freeze
  ROLE_UPDATE = 'sn.user.role.update'.freeze
  PROFILE_UPDATE = 'sn.user.profile.update'.freeze
  PAGE_VIEW = 'sn.user.page.view'.freeze
  VERIFY = 'sn.verify'.freeze
end