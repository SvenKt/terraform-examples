terraform {
  required_providers {
    pgp = {
      source = "ekristen/pgp"
      version = "0.2.4"
    }
  }
}

#
# ATTENTION: STORES PASSWORD UNENCRYPTED IN TERRAFORM STATEFILE!
#

provider "aws"  {
  profile = "..."
  region = "..."
}

#
# CREATE ADMIN USER
#

resource "aws_iam_user" "my-admin" {
  name = "my-admin"
}

#
# CREATE ADMIN GROUP
#

resource "aws_iam_group" "admins" {
  name = "admins"
}

#
# CREATE PERMISSION POLICY
#

resource "aws_iam_policy" "admins" {
  name        = "admin-permissions"
  description = "admin perms"
  policy      = "{ ... }"
}


#
# ATTACH PERMISSION POLICY TO ADMIN GROUP
#

resource "aws_iam_policy_attachment" "admin-attach" {
  name       = "admin-attach"
  groups     = [aws_iam_group.admins.name]
  policy_arn = aws_iam_policy.admins.arn
}

#
# DEFINE ADMIN GROUP MEMBERS
#

resource "aws_iam_group_membership" "admins" {
  name = "tf-admin-group-membership"

  users = [
    aws_iam_user.tech-admin.name,
  ]

  group = aws_iam_group.admins.name
}

#
# CREATE ACCESS KEYS FOR PROGRAMMATIC ACCESS
#

resource "aws_iam_access_key" "my-admin" {
  user       = aws_iam_user.my-admin.name
  depends_on = [aws_iam_user.my-admin]
}


#
# CREATE PGP KEYPAIR FOR PASSWORD ENCRYPTION
#

resource "pgp_key" "my-admin" {
  name    = aws_iam_user.my-admin.name
  email   = "test@test.com"
  comment = "PGP Key for ${aws_iam_user.my-admin.name}"
}

#
# CREATE CONSOLE ACCESS PASSWORD 
# GETS ENCRYPTED BY PGP PUBLIC KEY

resource "aws_iam_user_login_profile" "admin-console-access" {
  user    = aws_iam_user.my-admin.name
  pgp_key                 = pgp_key.my-admin.public_key_base64
  password_reset_required = true
  depends_on = [aws_iam_user.my-admin, pgp_key.my-admin]
}

#
# DECRYPT PASSWORD
# GETS DECRYPTED BY PGP PRIVATE KEY

data "pgp_decrypt" "my-admin" {
  ciphertext          = aws_iam_user_login_profile.admin-console-access.encrypted_password
  ciphertext_encoding = "base64"
  private_key         = pgp_key.my-admin.private_key
}

#
# OUTPUT PASSWORD
#

output "password" {
    value = data.pgp_decrypt.my-admin.plaintext
    sensitive = true
}

# to show sensitive output enter: terraform output -json
