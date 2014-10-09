set :rails_env, 'production'
set :rack_env, 'production'

role :app, 'deploy@transhealth.directory'
role :web, 'deploy@transhealth.directory'
role :db,  'deploy@transhealth.directory', :primary => true
