# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "Learn_Terraform"
resource "github_repository" "Learn_Terraform" {
  allow_auto_merge            = false
  allow_forking               = true
  allow_merge_commit          = true
  allow_rebase_merge          = true
  allow_squash_merge          = true
  allow_update_branch         = false
  archive_on_destroy          = null
  archived                    = false
  auto_init                   = false
  delete_branch_on_merge      = false
  description                 = "This repository created to learn Terraform"
  etag                        = "W/\"78bb258653d1660b16eddc82759321cb00c2391643e027c6fd288d36df6a6630\""
  fork                        = "false"
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  homepage_url                = null
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "Learn_Terraform"
  squash_merge_commit_message = "COMMIT_MESSAGES"
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  topics                      = []
  visibility                  = "public"
  web_commit_signoff_required = false
  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }
}
