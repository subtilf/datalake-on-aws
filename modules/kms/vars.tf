variable "kms_desc"{
}

variable "key_usage"{
    default = "ENCRYPT_DECRYPT"
}

variable "type_key"{
    default = "SYMMETRIC_DEFAULT"
}

variable "tags"{
    type = map
}