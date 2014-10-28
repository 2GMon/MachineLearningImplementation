require 'find'

require_relative './classifier'

Find.find(File.dirname(__FILE__) + "/classifier"){|f|
  require f if File.extname(f) == ".rb"
}
