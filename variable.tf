variable "aws_region" {
  description = "Región AWS donde se desplegarán los recursos (excepto certificados ACM)"
  type        = string
  default     = "us-east-2"
}

variable "site_domain" {
  description = "Dominio completo del sitio (debe ser un subdominio de domain_base)"
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (lab, dev, prod). Se usa para etiquetado."
  type        = string
  default     = "lab"
}

variable "domain_base" {
  description = "Dominio base de la zona Route53 existente (ej. kernelops.dev)"
  type        = string
  default     = "kernelops.dev"
}