{
  "AWSEBDockerrunVersion": "1",
  "Image": {
    "Name": "<AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<NAME>:<TAG>",
    "Update": "true"
  },
  "Ports": [
    {
      "ContainerPort": "3000"
    }
  ],
  "Volumes": [
    {
      "HostDirectory": "/tmp",
      "ContainerDirectory": "/tmp"
    }
  ]
  "Logging": "/app/log"
}
