Rails.application.config.assets.image_optim = {
  pngout: false,
  skip_missing_workers: true,
  nice: 20,
  optipng: {
    level: 7
  },
  jpegoptim: {
    max_quality: 90
  }
}
