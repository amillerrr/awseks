resource "aws_iam_role" "flaskapp" {
  name = "eks-cluster-flaskapp"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts.AssumeRole"
        }
    ]
  }
  POLICY
}

resource "aws_iam_role_policy_attachment" "flaskapp_amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.flaskapp.name
}

resource "aws_eks_cluster" "flaskapp" {
  name     = "flaskapp"
  role_arn = aws_iam_role.flaskapp.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private_us_west_2a,
      aws_subnet.private_us_west_2b,
      aws_subnet.public_us_west_2a,
      aws_subnet.public_us_west_2b
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.flaskapp_amazon_eks_cluster_policy]
}
