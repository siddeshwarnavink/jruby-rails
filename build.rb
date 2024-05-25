# Created by Siddeshwar
#
# This build script tampers the build WAR file and:
# * Installs local version of JRuby
# * Injects script to install sassc into WAR

require 'fileutils'

require 'rubygems'
require 'zip'

TEMP_PATH = 'build_temp/'
CACHE_PATH = 'tmp/jar/'
WAR_FILE_PATH = 'jruby-rails-demo.war'
WAR_EXTRACT_PATH = "#{TEMP_PATH}war_extracts/"
OUT_PATH = 'out.war'

def run_syscmd(name, cmd)
  system cmd
  if $?.success?
    puts "✅ #{name} successful!"
  else 
    abort "😔 #{name} failed!"
    clear_temp
  end
end

def clear_temp
  run_syscmd 'Temp file cleanup', "rm -rf #{TEMP_PATH}"
  run_syscmd 'WAR file cleanup', "rm #{WAR_FILE_PATH}"
end

def temp_download(name, url)
  filename = url.split("/")[-1]
  unless Dir.exist? CACHE_PATH
    Dir.mkdir CACHE_PATH
  end
  unless File.exist? "#{CACHE_PATH}#{filename}"
    run_syscmd "Downloading #{filename}", "cd #{CACHE_PATH} && curl -O #{url}"
  else
    puts "ℹ️  Using #{name} from cache" 
  end
  FileUtils.cp "#{CACHE_PATH}#{filename}", "#{WAR_EXTRACT_PATH}WEB-INF/lib/#{filename}" 
end

def del_lib(pattern)
  Dir.glob("#{WAR_EXTRACT_PATH}WEB-INF/lib/*").each do |file|
    if file.match? pattern
      FileUtils.rm file
    end
  end
end

def copy_lib(name)
  FileUtils.cp "#{CACHE_PATH}#{name}", "#{WAR_EXTRACT_PATH}WEB-INF/lib/#{name}" 
end

def inject_script
  code = <<~HEREDOC
  # Code injection starts
  puts '💉 Executing injected code'
  system 'gem install sassc'
  if $?.success?
    puts "✅ Code injection successful!"
  else 
    abort "😔 Code injection failed!"
  end
  # Code injection ends
  HEREDOC

  File.open("#{WAR_EXTRACT_PATH}META-INF/init.rb", 'a') { |file| file.write(code) }
end

if File.exist? OUT_PATH
  run_syscmd 'Previous build cleanup', "rm #{OUT_PATH}"
end
unless Dir.exist? 'public/assets'
  run_syscmd 'Pre-compile assets', 'RAILS_ENV=production bin/rails assets:precompile'
end
run_syscmd 'Warble build', 'bundle exec warble executable war'
run_syscmd 'Extract WAR', "mkdir -p #{WAR_EXTRACT_PATH} && unzip #{WAR_FILE_PATH} -d #{WAR_EXTRACT_PATH}"

temp_download 'JRuby core', "https://repo1.maven.org/maven2/org/jruby/jruby-core/#{JRUBY_VERSION}/jruby-core-#{JRUBY_VERSION}.jar"
temp_download 'JRuby stdlib', "https://repo1.maven.org/maven2/org/jruby/jruby-stdlib/#{JRUBY_VERSION}/jruby-stdlib-#{JRUBY_VERSION}.jar"

del_lib "jruby-core\..+\.jar"
del_lib "jruby-stdlib\..+\.jar"

copy_lib "jruby-core-#{JRUBY_VERSION}.jar"
copy_lib "jruby-stdlib-#{JRUBY_VERSION}.jar"

inject_script

Zip::File.open(OUT_PATH, create: true) do |warfile|
  Dir["#{WAR_EXTRACT_PATH}/**/*"].each do |file|
    warfile.add file.sub("#{WAR_EXTRACT_PATH}/", ""), file
  end
end

clear_temp
