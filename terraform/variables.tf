variable "iam_user_name" {
  description = "Name of the IAM user"
  default     = "spotify-streaming-user"
  type        = string
}

variable "iam_role_name" {
  description = "Name of the IAM role"
  default     = "spotify-streaming-role"
  type        = string
}
variable "region" {
  description = "Project region"
  default     = "eu-central-1"
  type        = string
}

variable "bucket" {
  description = "Name of the S3 bucket"
  default     = "spotify-streaming"
  type        = string
}

variable "kafka_key_name" {
  description = "Name of the key to access the kafka instance"
  default     = "spotify-stream-kafka-key"
  type        = string
}

variable "spotify_client_id" {
  description = "Spotify API client id"
  type        = string
}

variable "spotify_client_secret" {
  description = "Spotify API client secret"
  type        = string
}

variable "spotify_redirect_uri" {
  description = "Spotify API redirect URI"
  default     = "http://localhost:7777/callback"
  type        = string
}
  
}
