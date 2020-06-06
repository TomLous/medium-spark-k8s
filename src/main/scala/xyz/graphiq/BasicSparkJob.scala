package xyz.graphiq

import org.apache.spark.SparkConf
import org.apache.spark.sql._
import org.apache.spark.sql.functions._
import xyz.graphiq.model._

/**
  * Created by Tom Lous on 2019-10-20.
  * Copyright © 2019 GraphIQ.
  */
object BasicSparkJob extends App {

  val spark: SparkSession = SparkSession
    .builder()
    .config(
      new SparkConf().setIfMissing("master", "local[]")
    )
    .appName("BasicSparkJob")
    .getOrCreate()

  import spark.implicits._

  // define some paths
  val inputPath = args(0)
  val outputPath = args(1)


  // define movie dataset
  val movieSchema = Encoders.product[Movie].schema

  val moviesDataset = spark
    .read
    .option("header", true)
    .schema(movieSchema)
    .csv(s"$inputPath/movies.csv")
    .as[Movie]

  // define rating dataset
  val ratingSchema = Encoders.product[Rating].schema

  val ratingDataset = spark
    .read
    .option("header", true)
    .schema(ratingSchema)
    .csv(s"$inputPath/ratings.csv")
    .as[Rating]


  // combine and group and save
  ratingDataset
    .join(broadcast(moviesDataset), "movieId")
    .groupBy('movieId)
    .agg(
      first('title).as("title"),
      round(avg('rating), 2).as("averageRating"),
      count('rating).as("numberOfRatings")
    )
    .select('movieId, 'title, 'averageRating, 'numberOfRatings)
    .as[MovieRating]
    .repartition(20)
    .write
    .mode(SaveMode.Overwrite)
    .parquet(s"$outputPath/movie-ratings")

}
