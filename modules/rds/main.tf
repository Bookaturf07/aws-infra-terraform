resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "bookaturf-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "bookaturf-db-subnet-group"
  }
}

resource "aws_db_instance" "db" {
  identifier            = "bookaturf-rds-instance"
  instance_class        = "db.t3.micro"
  engine                = "postgres"
  allocated_storage     = 20
  storage_type          = "gp2"
  username              = "bat"
  password              = "bat12345"  # Change this to a more secure method (e.g., use AWS Secrets Manager)
  db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [var.rds_security_group_id]
  multi_az             = false
  publicly_accessible  = false  # Ensure that the RDS instance is not publicly accessible
  skip_final_snapshot  = true   # To avoid snapshot costs (only if you're okay with losing data on deletion)
}

resource "aws_db_parameter_group" "default" {
  name        = "bookaturf-db-parameter-group"
  family      = "postgres13"  # Adjust for the version you're using
  description = "Default parameter group for bookaturf"
}
