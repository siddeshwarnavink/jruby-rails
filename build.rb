# Created by Siddeshwar
#
# This build script tampers the build WAR file and:
# * Installs local version of JRuby
# * Injects script to install sassc into WAR

require 'fileutils'

require 'rubygems'
require 'zip'

TEMP_PATH = 'build_temp/'
WAR_FILE_PATH = 'jruby-rails-demo.war'
WAR_EXTRACT_PATH = "#{TEMP_PATH}war_extracts/"

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
  unless Dir.exist? TEMP_PATH
    Dir.mkdir TEMP_PATH
  end
  run_syscmd "Downloading #{name}", "cd #{TEMP_PATH} && curl -O #{url}"
end

def del_lib(pattern)
  Dir.glob("#{WAR_EXTRACT_PATH}WEB-INF/lib/*").each do |file|
    if file.match? pattern
      FileUtils.rm file
    end
  end
end

def copy_lib(name)
  FileUtils.cp "#{TEMP_PATH}#{name}", "#{WAR_EXTRACT_PATH}WEB-INF/lib/#{name}" 
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

run_syscmd "Warble build", "bundle exec warble executable war"
run_syscmd "Extract WAR", "mkdir -p #{WAR_EXTRACT_PATH} && unzip #{WAR_FILE_PATH} -d #{WAR_EXTRACT_PATH}"

temp_download "JRuby core", "https://repo1.maven.org/maven2/org/jruby/jruby-core/#{JRUBY_VERSION}/jruby-core-#{JRUBY_VERSION}.jar"
temp_download "JRuby stdlib", "https://repo1.maven.org/maven2/org/jruby/jruby-stdlib/#{JRUBY_VERSION}/jruby-stdlib-#{JRUBY_VERSION}.jar"

del_lib "jruby-core\..+\.jar"
del_lib "jruby-stdlib\..+\.jar"

copy_lib "jruby-core-#{JRUBY_VERSION}.jar"
copy_lib "jruby-stdlib-#{JRUBY_VERSION}.jar"

inject_script

Zip::File.open('out.war', create: true) do |warfile|
  Dir["#{WAR_EXTRACT_PATH}/**/*"].each do |file|
    warfile.add file.sub("#{WAR_EXTRACT_PATH}/", ""), file
  end
end

clear_temp
