import org.scalatest.FunSuite

import jp.mydns._2gmon.machinelearning.classifier._

class PerceptronSuite extends FunSuite {
  test("learn") {
    val train_data  = List(List(1.0), List(0.5), List(-1.0), List(-1.5))
    val train_class = List(1, 1, 2, 2)
    val perceptron = new Perceptron(0.5, List(List(0.5, 1.5), List(1.0, 1.0)))
    val learnedPerceptron = perceptron.learn(train_data, train_class)
    assertResult(List(List(1.0, 1.75), List(0.5, 0.75))) {
      learnedPerceptron.weight
    }
  }
}
