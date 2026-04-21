# my-project 2048_fully.yaml 
we need to give the access to cluster from service role 
#for that run the commands in cluster running server
aws eks create-access-entry \
    --cluster-name ekswithavinash \
    --principal-arn arn:aws:iam::982424467695:role/service-role/AWSCodePipelineServiceRole-ap-south-1-test123 \
    --type STANDARD
  #change your service IAM role present in pipeline <arn:aws:iam::982424467695:role/service-role/AWSCodePipelineServiceRole-ap-south-1-test123>

# mapp the plicy to the cluster 
aws eks associate-access-policy \
    --cluster-name ekswithavinash \
    --principal-arn arn:aws:iam::982424467695:role/service-role/AWSCodePipelineServiceRole-ap-south-1-test123 \
    --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy \
    --access-scope type=cluster
#change your service IAM role present in pipeline <arn:aws:iam::982424467695:role/service-role/AWSCodePipelineServiceRole-ap-south-1-test123>
