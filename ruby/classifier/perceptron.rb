require_relative '../classifier.rb'

module MachineLearning
  class Perceptron < Classifier
    def initialize(rho = 0.5, weight = nil)
      @rho = rho
      @weight = weight
    end

    def learn(train_data, train_class)
      bias_train_data = add_bias(train_data)
      if @weight
        weight = @weight
      else
        weight = initialize_weight(bias_train_data[0].size, train_class.uniq.size)
      end

      classify_correctly_all = false
      until classify_correctly_all
        classify_correctly_all = true
        bias_train_data.each_with_index do |data, i|
          discriminant_results = weight.map do |w|
            discriminant_function(data, w)
          end

          classification_class = discriminant_results.index(discriminant_results.max)
          actuals_class = train_class.uniq.sort.index(train_class[i])
          unless classification_class == actuals_class
            classify_correctly_all = false
            weight = update_weight(weight, data, @rho, classification_class, actuals_class)
          end
        end
      end
      @weight = weight
    end

    def clasify(test_data)
      bias_test_data = add_bias(test_data)
      bias_test_data.each_with_index do |data, i|
        puts "data: #{data.to_s}"
        print "discriminant_function_results: "
        r = @weight.map do |w|
          discriminant_function(data, w)
        end.to_s
        puts r
        puts
      end
    end

    private
    def add_bias(data)
      data.map { |d| [1.0] + d }
    end

    def initialize_weight(dimension, class_size)
      Array.new(class_size).map do |elem|
        Array.new(dimension).map { rand }
      end
    end

    def discriminant_function(data, weight)
      data.zip(weight).reduce(0) { |sum, arr| sum + arr[0] * arr[1] }
    end

    def update_weight(weight, data, rho, classification_class, actuals_class)
      weight[actuals_class] = weight[actuals_class].zip(data.map { |i| rho * i }).map { |i| i[0] + i[1] }
      weight[classification_class] = weight[classification_class].zip(data.map { |i| rho * i }).map { |i| i[0] - i[1] }
      weight
    end
  end
end
