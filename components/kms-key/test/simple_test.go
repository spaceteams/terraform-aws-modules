package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestSimple(t *testing.T) {

	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "./simple",
		Upgrade:      true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	keyArn := terraform.Output(t, terraformOptions, "key_arn")
	assert.Contains(t, keyArn, "arn:aws:kms:eu-central-1")

	alias := terraform.Output(t, terraformOptions, "alias_name")
	assert.Equal(t, alias, "alias/spaceteams-project-staging-simple")

}
