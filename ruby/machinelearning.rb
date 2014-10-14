require 'find'

Find.find(File.expand_path("./")){|f|
  require f if File.extname(f) == ".rb"
}
