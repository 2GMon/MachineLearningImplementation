import org.scalatest.FunSuite

import jp.mydns._2gmon.machinelearning.classifier._

class PerceptronSuite extends FunSuite {
  val trainData = List(List(1.0), List(0.5), List(-1.0), List(-1.5))
  val trainClass = List(1, 1, 2, 2)

  test("learn") {
    val perceptron = new Perceptron(0.5, List(List(0.5, 1.5), List(1.0, 1.0)))
    val learnedPerceptron = perceptron.learn(trainData, trainClass)
    assertResult(List(List(1.0, 1.75), List(0.5, 0.75))) {
      learnedPerceptron.weight
    }
  }

  test("classify") {
    val perceptron = new Perceptron(0.5, List(List(1.0, 1.75), List(0.5, 0.75)))
    assertResult(List(0, 0, 1, 1)) {
      perceptron.classify(trainData)
    }
  }
}
