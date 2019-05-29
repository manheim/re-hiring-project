
module "cxhr" {
    source      =   "../../stack"

    environment =   "non-prod"
    local_shell =   "git-bash"
}