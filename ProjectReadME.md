
PreRequisites:

1) Have an AWS Console Account

2) Have Terraform Installed

3) Make sure the AWS CLI is connected to Terraform

4) Have Git and Github Installed


Steps:

1) **Create an S3 Bucket:** Start by creating an S3 bucket to store your website files. The bucket name should be globally unique across all AWS accounts.

2) **Configure Bucket for Static Website Hosting:** In the S3 Bucket properties, enable static website hosting and specify the default index document (e.g. "index.html") and optional error document (e.g. "eror.html")

3) **Upload Website Files:** Upload your static website files (HTML, CSS, JS, images, etc) to the S3 bucket. Make sure to set appropriate permissions (e.g. "public-read") for the objects to make them publically accessible.

4) **Enable Public Access:** Allow public access to the S3 bucket and its objects by configuring the bucket policy or Access Control Lists (ACLs).

5) **Testing The Website:** Once the setup is complete, you can test the static website by accessing it through the S3 bucket website URL

