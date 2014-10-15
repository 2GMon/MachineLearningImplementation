require 'minitest/unit'
require 'minitest/autorun'
require_relative '../classifier/perceptron'

class TestPerceptron < MiniTest::Unit::TestCase
  def setup
    @perceptron = MachineLearning::Perceptron.new(0.5, [[0.5, 1.5], [1.0, 0.5]])
  end

  def test_learn
    train_data = [[1.0], [-0.5], [-1.0], [-1.5]]
    train_class = [1, 1, 2, 2]
    weight = @perceptron.learn(train_data, train_class)
    assert_equal [[1.0, 1.5], [0.5, 0.5]], weight
  end
end
