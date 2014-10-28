module MachineLearning
  class WidrowHoff < Classifier
    def initialize(rho = 0.5, weight = nil, threshold = 0.1)
      @rho = rho
      @weight = weight
      @threshold = threshold
    end

    def learn(train_data, train_class)
      bias_train_data = add_bias(train_data)
      if @weight
        weight = @weight
      else
        weight = initialize_weight(bias_train_data[0].size, train_class.uniq.size)
      end
      @uniq_class = train_class.uniq.sort

      # 最急降下法
      loop do
        dJ = Array.new(weight.size)
        dJ = dJ.map{Array.new(bias_train_data[0].size, 0)}
        bias_train_data.each_with_index do |data, i|
          discriminant_results = weight.map { |w|
            discriminant_function(data, w)
          }

          supervised_vector = generate_supervised_vector(@uniq_class.size, @uniq_class.index(train_class[i]))

          # 誤差計算
          errors = discriminant_results.zip(supervised_vector).map { |arr|
            arr[0] - arr[1]
          }
          # 微分結果計算
          j = errors.map { |e|
            data.map { |d|
              e * d
            }
          }
          dJ = dJ.zip(j).map { |arr|
            arr[0].zip(arr[1]).map { |arrr|
              arrr[0] + arrr[1]
            }
          }
        end
        convergence = true
        dJ.each do |j|
          j.each do |jj|
            convergence = false if jj > @threshold
          end
        end
        break if convergence
        # 重み更新
        weight = weight.zip(dJ).map { |arr|
          arr[0].zip(arr[1]).map { |arrr|
            arrr[0] - @rho * arrr[1]
          }
        }
      end
      @weight = weight
    end

    def classify(test_data)
      bias_test_data = add_bias(test_data)
      bias_test_data.map do |data|
        discriminant_result = @weight.map do |w|
          discriminant_function(data, w)
        end
        @uniq_class[discriminant_result.index(discriminant_result.max)]
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

    def generate_supervised_vector(class_size, actual_class)
      supervised_vector = Array.new(class_size, 0)
      supervised_vector[actual_class] = 1
      supervised_vector
    end
  end
end
