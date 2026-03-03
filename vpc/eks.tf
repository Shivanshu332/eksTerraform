resource "aws_iam_role" "eks_cluster_demo_role" {
    name = "cluster-eks-demo-role"
    tags = {

    }
    assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "eks.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-AmazonEKSClusterPolicy" {
    role = aws_iam_role.eks_cluster_demo_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "eks_cluster_demo" {
    name = "eks-demo-cluster"
    role_arn = aws_iam_role.eks_cluster_demo_role.arn
    vpc_config {
      subnet_ids = [
        aws_subnet.eks_public_subnet.id,
        aws_subnet.eks_public_subnet-1b.id,
        aws_subnet.eks_private_subnet.id,
        aws_subnet.eks_private_subnet-1b.id
      ]
    }
    depends_on = [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy]
}