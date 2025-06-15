resource "aws_security_group" "mesadigital_security_group_pub" {
  name        = "mesadigital_security_group_pub"
  description = "Grupo de seguranca"
  vpc_id      = aws_vpc.mesadigital_vpc_1.id
}

resource "aws_security_group_rule" "mesadigital_rules_saida" {
  from_port         = 0
  protocol          = "-1" # qualquer protocolo
  security_group_id = aws_security_group.mesadigital_security_group_pub.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "mesadigital_rules_http_entrada_vendas" {
  from_port         = 8081
  protocol          = "tcp"
  security_group_id = aws_security_group.mesadigital_security_group_pub.id
  to_port           = 8081
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "mesadigital_rules_http_entrada_financeiro" {
  from_port         = 8082
  protocol          = "tcp"
  security_group_id = aws_security_group.mesadigital_security_group_pub.id
  to_port           = 8082
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "mesadigital_rules_http_entrada_operacoes" {
  from_port         = 8083
  protocol          = "tcp"
  security_group_id = aws_security_group.mesadigital_security_group_pub.id
  to_port           = 8083
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "mesadigital_rules_ssh_entrada" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.mesadigital_security_group_pub.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_key_pair" "mesadigital_keypair" {
  key_name   = "mesadigital"
  public_key = file("~/.ssh/mesadigital.pub")
}