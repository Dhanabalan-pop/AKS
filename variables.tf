//------------------------------------Service Principal---------------\\
variable "azure_subscription_id" {
  type        = string
  default     = "8e485c9b-6527-441b-a8c3-51058f8daf6e"
  description = "description"
}

variable "azure_client_id" {
  type        = string
  default     = "f28087fc-6a58-4c27-a657-352406c207df"
  description = "description"
}

variable "azure_client_secret" {
  type        = string
  default     = "V0-kUdG~a-o4ae64Qt~Ah0Pj6_VKo87P8m"
  description = "description"
}

variable "azure_tenant_id" {
  type        = string
  default     = "f37bc64f-a244-47ff-b13f-d5439eef9b08"
  description = "description"
}
//--------------------------------General Properties----------------\\
variable "rgname" {
  type    = string
  default = "RG-CMP-DEMO-SQL"
}
variable "sqlservername" {
  type    = string
  default = "cpm-demo-sql1"
}

variable "location" {
  type    = string
  default = "West US"
}
//-----------------------------------SQL CONFIGURATIONS-------------------\\
variable "username" {
  type    = string
  default = "adminuser"
}
variable "password" {
  type    = string
  default = "M@gento12345"
}
variable "dbname" {
  type    = string
  default = "cmpsqldemodb1"
}
variable "dbsize" {
  type    = string
  default = "10"
}
variable "staccountname" {
  type    = string
  default = "cmpdemostaccount"

}
variable "firewallrules" {
  type = list(any)
  default = [
    {
      startip = "10.0.0.1"
      endip   = "10.0.0.1"
    },
    {
      startip = "10.0.0.2"
      endip   = "10.0.0.2"
    }
  ]
}
//------------------------------------TAGS--------------------------\\
variable "owner" {
  type        = string
  default     = "Ali Arslan"
  description = "description"
}

variable "Environment" {
  type        = string
  default     = "Dev"
  description = "Enter storage account name"
}

variable "Buisness_unit" {
  type        = string
  default     = "HR"
  description = "Enter storage account name"
}

variable "Application" {
  type        = string
  default     = "DbServer"
  description = "Enter storage account name"
}

