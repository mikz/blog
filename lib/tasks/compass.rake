desc "Compile and compress sass styles"
task :styles do
  system 'compass',  'compile', '-e', 'production', '--force', '--output-style', 'compressed'
end
