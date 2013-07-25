namespace :test do
  desc "Run the GSTest Tests for iOS"
  task :ios do
    $ios_success = system("xctool -project GSTest/GSTest.xcodeproj -scheme 'GSTest' -sdk iphonesimulator test -test-sdk iphonesimulator")
  end
end

desc "Run the GSTest Tests for iOS"
task :test => ['test:ios'] do
  puts "\033[0;31m! iOS unit tests failed" unless $ios_success
  if $ios_success
    puts "\033[0;32m** All tests executed successfully"
  else
    exit(-1)
  end
end

task :default => 'test'