// Creating ECR for docker image

resource "aws_ecr_repository" "particle_ecr" {
  name                 = "serverip"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "particle_ecr"
    Env  = "dev"
  }

}

# Lambda Execution Role
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })

  tags = {
    Name = "lambda_exec_role"
  }
}

# Basic Lambda execution + VPC permissions
resource "aws_iam_role_policy" "lambda_vpc_policy" {
  name = "lambda-vpc-access"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Resource = "*"
      }
    ]
  })
}

# Lambda Security Group
resource "aws_security_group" "lambda_sg" {
  name        = "lambda_sg"
  description = "Security group for Lambda"
  vpc_id      = aws_vpc.particle_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda_sg"
  }
}

# Lambda Function
resource "aws_lambda_function" "server_ip_lambda" {
  function_name = "ServerIPLambda"
  role          = aws_iam_role.lambda_exec_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.particle_ecr.repository_url}:latest"
  timeout       = 10
  memory_size   = 512

  vpc_config {
    subnet_ids = [
      aws_subnet.private_subnet1.id,
      aws_subnet.private_subnet2.id
    ]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  depends_on = [
    aws_iam_role_policy.lambda_vpc_policy
  ]
  # lifecycle {
  #   ignore_changes = [image_uri]
  # }
}

# REST API Gateway
resource "aws_api_gateway_rest_api" "server_ip_api" {
  name        = "ServerIPAPI"
  description = "API Gateway for triggering Lambda to return IP and Time"
}

resource "aws_api_gateway_resource" "root_path" {
  rest_api_id = aws_api_gateway_rest_api.server_ip_api.id
  parent_id   = aws_api_gateway_rest_api.server_ip_api.root_resource_id
  path_part   = "ip"
}

resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.server_ip_api.id
  resource_id   = aws_api_gateway_resource.root_path.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.server_ip_api.id
  resource_id             = aws_api_gateway_resource.root_path.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.server_ip_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.server_ip_api.id
  stage_name  = "dev"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.server_ip_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.server_ip_api.execution_arn}/*/*"
}
