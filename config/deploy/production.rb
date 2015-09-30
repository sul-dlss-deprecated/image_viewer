server 'image-viewer-prod.stanford.edu', user: 'image_viewer', roles: %w(web db app)

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'production'
