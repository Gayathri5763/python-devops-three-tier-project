resource "aws_iam_instance_profile" "main_profile" {
  name = "main_profile"
  role = aws_iam_role.iam_role.name
}