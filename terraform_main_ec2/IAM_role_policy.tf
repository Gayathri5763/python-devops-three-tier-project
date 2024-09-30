resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.iam_role.name
   # Just for testing purpose, don't try to give administrator access in production
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}