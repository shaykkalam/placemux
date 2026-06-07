# 1. Create a Security Group (Firewall) for the Database
resource "aws_security_group" "db_sg" {
  name        = "${var.env_name}-postgres-sg"
  description = "Allow inbound traffic to PostgreSQL from within the VPC"
  vpc_id      = var.vpc_id

  # Inbound rule: Allow standard PostgreSQL traffic (Port 5432) from inside our network
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"] # Safe internal network range mapping
  }

  # Outbound rule: Allow the database to talk out if needed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_name}-postgres-sg"
  }
}

# 2. Group the network subnets for the database
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.env_name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.env_name}-db-subnet-group"
  }
}

# 3. Provision the Managed PostgreSQL Instance (AWS RDS)
resource "aws_db_instance" "postgres" {
  identifier             = "${var.env_name}-postgres-db"
  allocated_storage      = 20 # 20 GB storage (fits easily into AWS Free Tier)
  max_allocated_storage  = 100 # Auto-scales up to 100GB if needed
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro" # Lightweight, cost-effective instance
  db_name                = "placemux_${var.env_name}"
  
  # Credentials (In a production setup, these would pull from Secrets Manager)
  username               = "placemux_admin"
  password               = "SecurePassword123!" # We'll rotate this later
  
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  
  skip_final_snapshot    = true # Prevents AWS from hanging when we want to destroy it later
  publicly_accessible    = true # Enabled temporary access for backend migrations ease

  tags = {
    Environment = var.env_name
  }
}