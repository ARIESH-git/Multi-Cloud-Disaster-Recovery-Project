resource "aws_instance" "app" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  tags = { Name = "App-Machine" }
}

resource "aws_instance" "tools" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  tags = { Name = "Tools-Machine" }
}

resource "aws_eip" "app_eip" {
  instance = aws_instance.app.id
  domain   = "vpc"
  tags = { Name = "app-eip" }
}

resource "aws_eip" "tools_eip" {
  instance = aws_instance.tools.id
  domain   = "vpc"
  tags = { Name = "tools-eip" }
}
