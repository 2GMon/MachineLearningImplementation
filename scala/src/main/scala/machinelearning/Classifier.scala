package jp.mydns._2gmon.machinelearning.classifier {
  abstract class Classifier {
    def learn(trainData : List[List[Double]], trainClass : List[Int])
    def classify(data : List[List[Double]])
  }
}
