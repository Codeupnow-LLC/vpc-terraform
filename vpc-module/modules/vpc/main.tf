resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment}-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "default" {
  name        = "${var.environment}-sg"
  description = "Allow HTTP, HTTPS, SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-sg"
  }
}

#resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
#  name              = "/aws/vpc/${var.environment}-flow-logs"
#  retention_in_days = 7
#}

#resource "aws_iam_role" "flow_logs_role" {
#  name = "${var.environment}-vpc-flow-logs-role"

#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
 #     {
 #       Action = "sts:AssumeRole"
##        Effect = "Allow"
 #       Principal = {
 #         Service = "vpc-flow-logs.amazonaws.com"
 ##       }
 #     }
 #   ]
 ## })
#}

#resource "aws_iam_role_policy_attachment" "flow_logs_attach" {
 # role       = aws_iam_role.flow_logs_role.name
 # policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
##}

#resource "aws_flow_log" "vpc_logs" {
  ##log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  #log_destination_type = "cloud-watch-logs"
  #traffic_type         = "ALL"
  #vpc_id               = aws_vpc.main.id
  #iam_role_arn         = aws_iam_role.flow_logs_role.arn
#}
