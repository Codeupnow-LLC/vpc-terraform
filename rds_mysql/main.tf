resource "aws_db_instance" "rds" {
  identifier              = var.db_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = var.port
  publicly_accessible     = var.publicly_accessible
  skip_final_snapshot     = true
  vpc_security_group_ids  = var.security_group_ids
  db_subnet_group_name    = var.subnet_group_name

  tags = var.tags
}
