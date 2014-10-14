require_relative '../machinelearning'

def read_data_file(file_path)
  File.open(file_path) do |f|
    f.map { |line| line.chomp.split(/[ \t]+/).map { |num| num.to_f } }
  end
end

def read_class_file(file_path)
  File.open(file_path) do |f|
    f.map { |line| line.chomp.to_i }
  end
end

train_data  = read_data_file(File.dirname(__FILE__) + "/train_data.txt")
train_class = read_class_file(File.dirname(__FILE__) + "/train_class.txt")

perceptron = MachineLearning::Perceptron.new()
perceptron.learn(train_data, train_class)
perceptron.clasify(train_data)
