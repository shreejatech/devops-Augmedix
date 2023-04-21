

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.service_name}-s3-bucket"
  # acl    = "private"
}

# resource "aws_s3_bucket_acl" "s3_bucket" {
#   bucket = aws_s3_bucket.s3_bucket.id
#   acl    = "private"
# }



resource "aws_db_instance" "rds_instance" {
  identifier             = "${var.service_name1}-rds-instance"
  engine                 = "mysql"
  instance_class         = "db.t2.micro"
  allocated_storage      = 10
  storage_type           = "gp2"
  name                   = "${var.service_name2}rds"
  username               = "root"
  password               = "password"
  skip_final_snapshot    = true
}

resource "aws_iam_role" "iam_role" {
  name = "${var.service_name}-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_policy" "iam_policy" {
  name        = "${var.service_name}-iam-policy"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = ["s3:*"]
        Resource  = [aws_s3_bucket.s3_bucket.arn]
      },
      {
        Effect    = "Allow"
        Action    = ["rds:*"]
        Resource  = [aws_db_instance.rds_instance.arn, "${aws_db_instance.rds_instance.arn}/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  policy_arn = aws_iam_policy.iam_policy.arn
  role       = aws_iam_role.iam_role.name
}

resource "aws_ssm_parameter" "s3_bucket_parameter" {
  name  = "/services/${var.service_name}/s3-bucket-name"
  value = aws_s3_bucket.s3_bucket.bucket
  type  = "String"
}

resource "aws_ssm_parameter" "rds_url_parameter" {
  name  = "/services/${var.service_name}/rds-url"
  value = aws_db_instance.rds_instance.endpoint
  type  = "String"
}

resource "aws_ssm_parameter" "rds_username_parameter" {
  name  = "/services/${var.service_name}/rds-username"
  value = aws_db_instance.rds_instance.username
  type  = "SecureString"
}

resource "aws_ssm_parameter" "rds_password_parameter" {
  name  = "/services/${var.service_name}/rds-password"
  value = aws_db_instance.rds_instance.password
  type  = "SecureString"
}

resource "aws_ssm_parameter" "iam_role_parameter" {
  name  = "/services/${var.service_name}/iam-role-name"
  value = aws_iam_role.iam_role.name
  type  = "String"
}
