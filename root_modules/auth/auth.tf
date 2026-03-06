module "auth" {
  source = "../../modules/auth"

  enable_auth      = true
  user_pool_prefix = "aws-assessment"
  env              = "prod"
  users = {
    gkyrillos = {
      username = "gkyrillos"
      email    = "kyrillosgr@live.com"
    }
  }
}
