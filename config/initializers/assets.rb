# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += [ 'vendor/simple-line-icons/css/simple-line-icons.css',
                                                'vendor/device-mockups/device-mockups.min.css',
                                                'vendor/new-age.css',
                                                'vendor/bootstrap/css/bootstrap.min.css',
                                                'vendor/font-awesome/css/font-awesome.min.css',
                                                'vendor/bootstrap-switch/css/bootstrap-switch.min.css'

                                              ]
