# IRSA role — allows pod ServiceAccount to access AWS Secrets Manager
resource "aws_iam_role" "spoonacular_irsa" {
  name = "spoonacular-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = module.eks.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          ("${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub") = "system:serviceaccount:default:spoonacular-sa"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "spoonacular_secrets" {
  role       = aws_iam_role.spoonacular_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}