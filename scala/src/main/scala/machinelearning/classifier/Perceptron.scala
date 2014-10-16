package jp.mydns._2gmon.machinelearning.classifier {
  class Perceptron(val rho : Double = 0.5, val weight : List[List[Double]] = Nil) extends Classifier {
    def discriminantFunction(data : List[Double], weight : List[Double]) : Double = {
      data.zip(weight).map(a => a._1 * a._2).fold(0.0)((a, b) => a + b)
    }

    def learn(trainData : List[List[Double]], trainClass : List[Int]) : Perceptron = {
      val biasTrainData = trainData.map(1.0 :: _)
      def initializeWeight(classNum : Int, dimension: Int) : List[List[Double]] = {
        (1 to classNum).map(_ => (1 to dimension).map(_ => scala.util.Random.nextDouble).toList).toList
      }

      def perceptronStep(data : List[Double], weightList : List[List[Double]]) : List[List[Double]] = {
        def updateWeight(classificationClass : Int, actualsClass : Int) : List[List[Double]] = {
          weightList.map(weight =>
              if (weight == weightList(classificationClass))
                weight.zip(data.map(_ * rho)).map(a => a._1 - a._2)
              else if (weight == weightList(actualsClass))
                weight.zip(data.map(_ * rho)).map(a => a._1 + a._2)
              else
                weight
              )
        }

        val discriminantResult = weightList.map(weight => discriminantFunction(data, weight));
        val classificationClass = discriminantResult.indexOf(discriminantResult.max);
        val actualsClass = trainClass.distinct.sorted.indexOf(trainClass(biasTrainData.indexOf(data)));

        if (classificationClass == actualsClass)
          weightList
        else
          updateWeight(classificationClass, actualsClass)
      }

      def processAllData(trainData : List[List[Double]], weightList : List[List[Double]]) : List[List[Double]] = {
        if (trainData == List())
          weightList
        else
          processAllData(trainData.tail, perceptronStep(trainData.head, weightList))
      }

      def convergenceTest(weight : List[List[Double]], updatedWeight : List[List[Double]]) : List[List[Double]] = {
        if (weight == updatedWeight)
          updatedWeight
        else
          convergenceTest(updatedWeight, processAllData(biasTrainData, updatedWeight))
      }

      val initialWeight =
        if (weight == Nil)
          initializeWeight(trainClass.distinct.length, biasTrainData.head.length)
        else
          weight
      new Perceptron(rho, convergenceTest(List(List()), initialWeight))
    }

    def classify(trainData : List[List[Double]]) : List[Int] = {
      val biasTrainData = trainData.map(1.0 :: _)
      (for (data <- biasTrainData) yield {
        val discriminantResult = weight.map(w => discriminantFunction(data, w))
        discriminantResult.indexOf(discriminantResult.max)
      }).toList
    }
  }
}
