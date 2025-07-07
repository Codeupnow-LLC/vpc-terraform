variable "db_identifier" {
  type = string
}

variable "engine" {
  type    = string
  default = "mysql"
}

variable "engine_version" {
  type    = string
  default = "8.0"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "port" {
  type    = number
  default = 3306
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_group_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
