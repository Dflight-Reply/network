resource "aws_rds_cluster" "pg_cluster" {
  cluster_identifier          = "pg-cluster"
  engine                      = "postgres"
  engine_version              = "17.1"
  database_name               = "mydatabase"
  allocated_storage           = 20
  master_username             = "postgres"
  db_cluster_instance_class   = "db.m5d.large"
  manage_master_user_password = true
  storage_type                = "gp3"
  ca_certificate_identifier   = "rds-ca-rsa2048-g1"
  availability_zones          = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]
  db_subnet_group_name        = aws_db_subnet_group.my_db_subnet_group.name
  vpc_security_group_ids      = var.data_sg
  skip_final_snapshot         = true

  tags = {
    Owner              = "g.sello@reply.it"
    Schedule           = "reply-office-hours"
    DateOfDecommission = "14/03/2025"
  }
  lifecycle {
    ignore_changes = [iops]
  }
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "My DB Subnet Group"
  }
}
