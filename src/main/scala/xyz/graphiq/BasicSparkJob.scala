package xyz.graphiq

import org.apache.spark.sql.SparkSession

/**
  * Created by Tom Lous on 2019-10-20.
  * Copyright © 2019 GraphIQ.
  */
object BasicSparkJob extends App{

  implicit lazy val spark: SparkSession = SparkSession
    .builder()
    .master("local[*]")
    .appName("BasicSparkJob")
    .getOrCreate()



}
