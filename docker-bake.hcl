variable "TAG" {
  default = "slim"
}

# === Version Pins (single source of truth) ===
variable "COMFYUI_VERSION" {
  default = "v0.30.0"
}
variable "MANAGER_SHA" {
  default = "a2c41a2a21ffff3c8f1dfc6da2010967ef87538e"
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
  default = "4ee72c065db22c9d96c2427954dc69e7b908444b"
}
variable "CUSTOMSCRIPTS_SHA" {
  default = "609f3afaa74b2f88ef9ce8d939626065e3247469"
}
variable "QWENEDITUTILS_SHA" {
  default = "cdd4d028c6491d27a40092d7795158668cec9189"
}
variable "CONTROLNET_AUX_SHA" {
  default = "e8b689a513c3e6b63edc44066560ca5919c0576e"
}
variable "EXTRAMODELS_SHA" {
  default = "92f556ed4d3bec1a3f16117d2de10f195c36d68e"
}
variable "MEMORY_CLEANUP_SHA" {
  default = "58de13a6090e04408e343501ff8902c034d9f518"
}
variable "ACADEMIASD_SHA" {
  default = "62ee1dab070a8155cfd560619e58e9b10fdff08d"
}
variable "CRT_NODES_SHA" {
  default = "b59f7112009584c801aa3b32f8d9dcf3de9dfb4c"
}
variable "GGUF_SHA" {
  default = "6ea2651e7df66d7585f6ffee804b20e92fb38b8a"
}
variable "LAYERSTYLE_SHA" {
  default = "d94bef1ee5ed3656f5ff1bb2830a4ffd94f40935"
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
    COMFYUI_VERSION      = COMFYUI_VERSION
    MANAGER_SHA          = MANAGER_SHA
    KJNODES_SHA          = KJNODES_SHA
    CIVICOMFY_SHA        = CIVICOMFY_SHA
    RUNPODDIRECT_SHA     = RUNPODDIRECT_SHA
    RGTHREE_SHA          = RGTHREE_SHA 
    FLUXKLEIN_SHA        = FLUXKLEIN_SHA
    QWENMULTIANGLE_SHA   = QWENMULTIANGLE_SHA
    VIDEOHELPERSUITE_SHA = VIDEOHELPERSUITE_SHA 
    CUSTOMSCRIPTS_SHA    = CUSTOMSCRIPTS_SHA
    QWENEDITUTILS_SHA    = QWENEDITUTILS_SHA
    CONTROLNET_AUX_SHA   = CONTROLNET_AUX_SHA
    EXTRAMODELS_SHA      = EXTRAMODELS_SHA
    MEMORY_CLEANUP_SHA   = MEMORY_CLEANUP_SHA
    ACADEMIASD_SHA       = ACADEMIASD_SHA
    CRT_NODES_SHA        = CRT_NODES_SHA
    GGUF_SHA             = GGUF_SHA
    LAYERSTYLE_SHA       = LAYERSTYLE_SHA
    TORCH_VERSION        = TORCH_VERSION
    TORCHVISION_VERSION  = TORCHVISION_VERSION
    TORCHAUDIO_VERSION   = TORCHAUDIO_VERSION
    FILEBROWSER_VERSION  = FILEBROWSER_VERSION
    FILEBROWSER_SHA256   = FILEBROWSER_SHA256
    CUDA_VERSION_DASH    = "12-8"
    TORCH_INDEX_SUFFIX   = "cu128"
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
