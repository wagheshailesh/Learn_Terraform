#Challange - Create a file in local machine using Terraform with content "Hello World"

resource "null_resource" "MyFile" {
  provisioner "local-exec" {
    command = "echo 'Message:${upper("Hello World")}' > challange.txt"
  }
}