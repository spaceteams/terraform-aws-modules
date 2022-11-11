package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestComplex(t *testing.T) {

	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "./complex",
		Upgrade:      true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	bucketId := terraform.Output(t, terraformOptions, "bucket_id")
	assert.Contains(t, bucketId, "spaceteams-project-sandbox-complex")

	loggingBucketId := terraform.Output(t, terraformOptions, "logging_bucket_id")
	assert.Equal(t, loggingBucketId, "spaceteams-project-sandbox-logging")

}
