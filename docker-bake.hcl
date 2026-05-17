variable "TAG" {
  default = "slim"
}

# === Version Pins (single source of truth) ===
variable "COMFYUI_VERSION" {
  default = "v0.20.1"
}
variable "MANAGER_SHA" {
  default = "66108ccdbc8c"
}
variable "KJNODES_SHA" {
  default = "4e1458c2417d"
}
variable "CIVICOMFY_SHA" {
  default = "555e984bbcb0"
}
variable "RUNPODDIRECT_SHA" {
  default = "8be7b2206b75"
}
# Regular image (cu128)
variable "TORCH_VERSION" {
  default = "2.7.1+cu128"
}
variable "TORCHVISION_VERSION" {
  default = "0.22.1+cu128"
}
variable "TORCHAUDIO_VERSION" {
  default = "2.7.1+cu128"
}
# 5090 image (cu130) — can diverge from regular when needed
variable "TORCH_VERSION_5090" {
  default = "2.11.0+cu130"
}
variable "TORCHVISION_VERSION_5090" {
  default = "0.26.0+cu130"
}
variable "TORCHAUDIO_VERSION_5090" {
  default = "2.11.0+cu130"
}
variable "FILEBROWSER_VERSION" {
  default = "v2.59.0"
}
variable "FILEBROWSER_SHA256" {
  default = "8cd8c3baecb086028111b912f252a6e3169737fa764b5c510139e81f9da87799"
}
variable "RGTHREE_SHA" {
  default = "738105af5fb14e96fbecaf406dc356e284797e8c"
}
variable "FLUXKLEIN_SHA" {
  default = "ce33bc8d5d1e5a00371357bccf4b51bd20550409"
}
variable "QWENMULTIANGLE_SHA" {
  default = "6f93d9b15a50c07c13411734723fe5cae287e7aa"
}
variable "VIDEOHELPERSUITE_SHA" {
  default = "3234937"
}

group "default" {
  targets = ["common", "dev"]
}

# Common settings for all targets (defaults to regular CUDA 12.8 / cu128)
target "common" {
  context    = "."
  dockerfile = "Dockerfile"
  platforms  = ["linux/amd64"]
  args = {
    COMFYUI_VERSION     = COMFYUI_VERSION
    MANAGER_SHA         = MANAGER_SHA
    KJNODES_SHA         = KJNODES_SHA
    CIVICOMFY_SHA       = CIVICOMFY_SHA
    RUNPODDIRECT_SHA    = RUNPODDIRECT_SHA
    RGTHREE_SHA         = RGTHREE_SHA 
    FLUXKLEIN_SHA       = FLUXKLEIN_SHA
    QWENMULTIANGLE_SHA  = QWENMULTIANGLE_SHA
    TORCH_VERSION       = TORCH_VERSION
    TORCHVISION_VERSION = TORCHVISION_VERSION
    TORCHAUDIO_VERSION  = TORCHAUDIO_VERSION
    FILEBROWSER_VERSION = FILEBROWSER_VERSION
    FILEBROWSER_SHA256  = FILEBROWSER_SHA256
    CUDA_VERSION_DASH   = "12-8"
    TORCH_INDEX_SUFFIX  = "cu128"
  }
}

# Regular ComfyUI image (CUDA 12.8 — default)
target "regular" {
  inherits = ["common"]
  tags = [
    "cirsiojir/comfyui:${TAG}-cuda12.8",
    "cirsiojir/comfyui:cuda12.8",
    "cirsiojir/comfyui:latest",
  ]
}

# Dev image for local testing
target "dev" {
  inherits = ["common"]
  tags = ["cirsiojir/comfyui:dev"]
  output = ["type=docker"]
}

# Dev push targets (for CI pushing dev tags, without overriding latest)
target "devpush" {
  inherits = ["common"]
  tags = ["cirsiojir/comfyui:dev-cuda12.8"]
}

target "devpush-cuda13" {
  inherits = ["common"]
  tags = ["cirsiojir/comfyui:dev-cuda13.0"]
  args = {
    TORCH_VERSION       = TORCH_VERSION_5090
    TORCHVISION_VERSION = TORCHVISION_VERSION_5090
    TORCHAUDIO_VERSION  = TORCHAUDIO_VERSION_5090
    CUDA_VERSION_DASH   = "13-0"
    TORCH_INDEX_SUFFIX  = "cu130"
  }
}

# CUDA 13.0 image (Blackwell / RTX 5090+)
target "cuda13" {
  inherits = ["common"]
  tags = [
    "cirsiojir/comfyui:${TAG}-cuda13.0",
    "cirsiojir/comfyui:cuda13.0",
  ]
  args = {
    TORCH_VERSION       = TORCH_VERSION_5090
    TORCHVISION_VERSION = TORCHVISION_VERSION_5090
    TORCHAUDIO_VERSION  = TORCHAUDIO_VERSION_5090
    CUDA_VERSION_DASH   = "13-0"
    TORCH_INDEX_SUFFIX  = "cu130"
  }
}
