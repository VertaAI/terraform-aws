
resource "aws_iam_role" "role" {
  name = var.role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::493416687123:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "policy" {
  name        = var.role_name
  path        = "/"


  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ACMall",
      "Effect": "Allow",
      "Action": [
        "acm:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AutoscalingAll",
      "Effect": "Allow",
      "Action": [
        "autoscaling:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CloudwatchAll",
      "Effect": "Allow",
      "Action": [
        "cloudwatch:*",
        "logs:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "EC2all",
      "Effect": "Allow",
      "Action": [
        "ec2:AllocateAddress",
        "ec2:Create*",
        "ec2:Describe*",
        "ec2:ImportKeyPair",
        "ec2:RunInstances"
      ],
      "Resource": "*"
    },
    {
      "Sid": "EC2tag",
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "ec2:ResourceTag/verta.ai/managed": "true"
        }
      }
    },
    {
      "Sid": "EC2tag2",
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "ec2:ResourceTag/kubernetes.io/cluster/verta-mgt-${var.cluster_name}": "owned"
        }
      }
    },
    {
      "Sid": "Decode",
      "Effect": "Allow",
      "Action": [
        "sts:DecodeAuthorizationMessage"
      ],
      "Resource": "*"
    },
    {
      "Sid": "EC2arn",
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "arn:aws:ec2:*:*:*/verta-mgt-*"
    },
    {
      "Sid": "EC2GA",
      "Effect": "Allow",
      "Action": "ec2:DeleteSecurityGroup",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/AWSServiceName": "GlobalAccelerator"
        }
      }
    },
    {
      "Sid": "ECRAll",
      "Effect": "Allow",
      "Action": [
        "ecr:GetRegistryScanningConfiguration",
        "ecr:PutRegistryScanningConfiguration"
      ],
      "Resource": "*"
    },
    {
      "Sid": "ECRarn",
      "Effect": "Allow",
      "Action": [
        "ecr:*"
      ],
      "Resource": "arn:aws:ecr:*:*:repository/verta-mgt-*"
    },
    {
      "Sid": "EKSall",
      "Effect": "Allow",
      "Action": [
        "eks:*"
      ],
      "Resource": "arn:aws:eks:*:*:*/verta-mgt-*"
    },
    {
      "Sid": "GA",
      "Effect": "Allow",
      "Action": [
        "globalaccelerator:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "IAMarn",
      "Effect": "Allow",
      "Action": [
        "iam:*"
      ],
      "Resource": [
        "arn:aws:iam::*:policy/verta-mgt-*",
        "arn:aws:iam::*:role/verta-mgt-*",
        "arn:aws:iam::*:instance-profile/verta-mgt-*"
      ]
    },
    {
      "Sid": "IAMlinked",
      "Effect": "Allow",
      "Action": [
        "iam:CreateServiceLinkedRole",
        "iam:DeleteServiceLinkedRole",
        "iam:GetServiceLinkedRoleDeletionStatus"
      ],
      "Resource": "arn:aws:iam::*:role/aws-service-role/*.amazonaws.com/*"
    },
    {
      "Sid": "IAMoidc",
      "Effect": "Allow",
      "Action": [
        "iam:CreateOpenIDConnectProvider",
        "iam:GetOpenIDConnectProvider",
        "iam:DeleteOpenIDConnectProvider"
      ],
      "Resource": [
        "arn:aws:iam::*:oidc-provider/oidc.eks.*.amazonaws.com",
        "arn:aws:iam::*:oidc-provider/oidc.eks.*.amazonaws.com/id/*"
      ]
    },
    {
      "Sid": "IAMpass",
      "Effect": "Allow",
      "Action": [
        "iam:GetRole",
        "iam:PassRole"
      ],
      "Resource": "*"
    },
    {
      "Sid": "IAMtag",
      "Effect": "Allow",
      "Action": [
        "iam:*"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "iam:ResourceTag/verta.ai/managed": "true"
        }
      }
    },
    {
      "Sid": "LoadbalancingAll",
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:Create*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "LoadbalancingARN",
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:*"
      ],
      "Resource": "arn:aws:elasticloadbalancing:*:*:*/verta-mgt-*"
    },
    {
      "Sid": "RDSall",
      "Effect": "Allow",
      "Action": [
        "rds:Describe*"
      ],
      "Resource": "arn:aws:rds:*:*:*:*"
    },
    {
      "Sid": "RDSarn",
      "Effect": "Allow",
      "Action": [
        "*"
      ],
      "Resource": "arn:aws:rds:*:*:*:verta-mgt-*"
    },
    {
      "Sid": "S3arn",
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::verta-mgt-*",
        "arn:aws:s3:::verta-mgt-*/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
