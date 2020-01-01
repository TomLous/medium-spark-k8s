# Deploying Apache Spark Jobs on Kubernetes with Helm and Spark Operator

Repository accompanying the article on Medium:

[http://bit.ly/spark-k8s](http://bit.ly/spark-k8s)

## Intro: 

For each challenge there are many technology stacks that can provide the solution. I’m not claiming this approach is the holy grail of data processing, but this more the tale of my quest to combine tools that are widely supported in a maintainable fashion.
From the onset I’ve always tried to generate as much configuration as possible, because I’ve experienced it’s easy to drown in a sea of yaml-files, conf-files and incompatible versions in registries, repositories, CI/CD pipelines and deployments.
What I created was a sbt script that when triggered build a fat-jar, wrapped it in a docker-file and generated an image, and also updating the helm values of a chart with the new config. The image is pushed to the registry, the helm chart is augmented with environmental settings and pushed to chart museum.
I’ve deployed this both locally on minikube as remotely in Azure, but the Azure flow is maybe less generic to discuss, because the Azure Container Registry can be used for both the images and the helm charts. Also remote deployments are relying on terraform scripts and CI/CD pipelines that are too specific anyway. Do note that all infra is setup via brew on a mac. But it should be easy to find equivalents for other environments.

1. Kubernetes
1. Helm
1. Image Registry
1. Helm Chart Museum
1. Spark Operator
1. Spark App
1. sbt setup
1. Base Image setup
1. Helm config
1. Deploying
1. Conclusion

[Read more...](http://bit.ly/spark-k8s)