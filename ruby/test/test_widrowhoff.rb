require 'minitest/unit'
require 'minitest/autorun'
require_relative '../machinelearning'

class TestPerceptron < MiniTest::Unit::TestCase
  def setup
    @train_data = [[1.0], [0.5], [-0.2], [-1.3]]
    @train_class = [1, 1, 2, 2]

    @widrowhoff = MachineLearning::WidrowHoff.new(0.2, [[0.2, 0.3], [0.5, 0.5]], 0.3)
  end

  def test_learn
    weight = @widrowhoff.learn(@train_data, @train_class)
    # 重みの差が0.01以下
    assert_in_delta  0.4976, weight[0][0], 0.01
    assert_in_delta  0.4899, weight[0][1], 0.01
    assert_in_delta  0.5,    weight[1][0], 0.01
    assert_in_delta -0.4372, weight[1][1], 0.01
  end

  def test_classify
    @widrowhoff.learn(@train_data, @train_class)
    classify_result = @widrowhoff.classify(@train_data)
    assert_equal @train_class, classify_result
  end
end
