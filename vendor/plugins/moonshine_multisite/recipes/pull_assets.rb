def pull_asset(remote, local)
  basename = File.basename(remote)
  dirname = File.dirname(remote)
  run "cd #{dirname} && tar -czf #{basename}.tar.gz #{basename}"
  download "#{remote}.tar.gz", "#{local}.tar.gz"
  cmd = "cd #{File.dirname(local)} && tar xfz #{local}.tar.gz"
  puts cmd
  system cmd
end

task :pull_assets do
  role :app, 'pat.powertochange.org'
  set :user, 'deploy'
  set :host, 'pat.powertochange.org'

  # pat
  pull_asset '/var/www/pat.powertochange.org/shared/public/event_groups',
    '/var/www/pat.powertochange.org/shared/public/event_groups'
  pull_asset '/var/www/dev.pat.powertochange.org/shared/public/event_groups',
    '/var/www/pat.dev.powertochange.org/shared/public/event_groups'
  # mpdtool
  pull_asset '/var/www/mpdtool.powertochange.org/shared/public/mpd_letter_images',
    '/var/www/mpdtool.powertochange.org/shared/public/mpd_letter_images'
  pull_asset '/var/www/dev.mpdtool.powertochange.org/shared/public/mpd_letter_images',
    '/var/www/mpdtool.dev.powertochange.org/shared/public/mpd_letter_images'
  # pulse
  pull_asset '/var/www/pulse.campusforchrist.org/shared/public/emu.profile_pictures',
    '/var/www/pulse.campusforchrist.org/shared/public/emu.profile_pictures'
  pull_asset '/var/www/moose.campusforchrist.org/shared/public/emu_dev.profile_pictures',
    '/var/www/pulse.dev.campusforchrist.org/shared/public/emu_dev.profile_pictures'
  pull_asset '/var/www/emu.campusforchrist.org/shared/public/emu_stage.profile_pictures',
    '/var/www/pulse.staging.campusforchrist.org/shared/public/emu_stage.profile_pictures'
end
