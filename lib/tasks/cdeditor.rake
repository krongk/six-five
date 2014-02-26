#xj: to fix ckeditor work on no-digest version.
#https://github.com/galetahub/ckeditor
#https://github.com/galetahub/ckeditor/issues/307
require 'fileutils'
namespace :ckeditor do
  desc "Create nondigest versions of all ckeditor digest assets"
  task copy_nondigest_assets: :environment do
    fingerprint = /\-[0-9a-f]{32}\./
    for file in Dir["public/assets/ckeditor/**/*"]
      next unless file =~ fingerprint
      nondigest = file.sub fingerprint, '.'
      FileUtils.cp file, nondigest, verbose: true
    end
  end
end



