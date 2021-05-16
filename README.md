# Simple Todo App with MongoDB, Express.js and Node.js
The ToDo app uses the following technologies and javascript libraries:
* MongoDB
* Express.js
* Node.js
* express-handlebars
* method-override
* connect-flash
* express-session
* mongoose
* bcryptjs
* passport
* docker & docker-compose

## What are the features?
You can register with your email address, and you can create ToDo items. You can list ToDos, edit and delete them. 

# How to use
First install the depdencies by running the following from the root directory:
```
npm install --prefix src/
```

To run this application locally you need to have an insatnce of MongoDB running. A docker-compose file has been provided in the root director that will run an insatnce of MongoDB in docker. TO start the MongoDB from the root direction run the following command:

```
docker-compose up -d
```

Then to start the application issue the following command from the root directory:
```
npm run start --prefix src/
```

The application can then be accessed through the browser of your choise on the following:

```
localhost:5000
```

## Testing

Basic testing has been included as part of this application. This includes unit testing (Models Only), Integration Testing & E2E Testing.

### Linting:
Basic Linting is performed across the code base. To run linting, execute the following commands from the root directory:

```
npm run test-lint --prefix src/
```

### Unit Testing
Unit Tetsing is performed on the models for each object stored in MongoDB, they will vdaliate the model and ensure that required data is entered. To execute unit testing execute the following commands from the root directory:

```
npm run test-unit --prefix src/
```

### Integration Testing
Integration testing is included to ensure the applicaiton can talk to the MongoDB Backend and create a user, redirect to the correct page, login as a user and register a new task. 

Note: MongoDB needs to be running locally for testing to work (This can be done by spinning up the mongodb docker container).

To perform integration testing execute the following commands from the root directory:

```
npm run test-integration --prefix src/
```

### E2E Tests
E2E Tests are included to ensure that the website operates as it should from the users perspective. E2E Tests are executed in docker containers. To run E2E Tests execute the following commands:

```
chmod +x scripts/e2e-ci.sh
./scripts/e2e-ci.sh
```

## Deployable Package
A command has been included that allows you to package up the application into a deployable artifact (tarball). To do this, from the root directory, enter the following command:

```
make pack
```
This command will pack the application into a tar and copy it into the `ansible/files` folder that can be used by ansible to deploy to a target machine. 


## Terraform
### Bootstrap
A set of bootstrap templates have been provided that will provision a DynamoDB Table, S3 Bucket & Option Group for DocumentDB in AWS. To set these up, ensure your AWS Programmatic credentials are set in your console and execute the following command from the root directory

```
make bootstrap
```

### Initalising your TF Repo
To initialise your terraform repo, run the following commands from your root directory

```
make tf-init
```

### Validate your TF Code
To validate & format your terraform repo, run the following command from your root directory

```
make tf-validate
```
## Solution

### Stage A

The overall goal is to implement AWS cloud deployments via terraform, including VPC, EC2, S3, load balancing, etc., as well as devops using circleCI, and a detailed description of the steps will appear below.

### Stage B

Q: Run the environment bootstrap templates & also generate an artifact that you can use in the next few steps (refer to the Readme &/or Makefile for both). 

Solution: The problem is the need to generate a deployable file and the use of a bootstrap template. As documented above, the goal can be accomplished by simply using the following command.

```bash
# make a deployable package
make pack
```

after this command, a tar file is generated in `ansible/file` folder. Just like this:

![generate-deploy-package](./assets/generate-deploy-package.png)

The next step will be to test the use of the template file with the following command: 

```bash
# test the template 
make bootstrap
```  

this is the terminal output.
![make-bootstrap](./assets/make-bootstrap.png)

Resources successfully created.
![resources-bucket](./assets/resources-bucket.png)

then the following command `make tf-init` and `make tf-validate` are also OK. No more screenshots here.

### Stage C

In this Stage, The things to do are "Create a VPC in terraform with 3 layers across 3 availability zones (9 subnets). Public, Private, and Data."

Use module is a better choice, so I user [AWS VPC Terraform module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) for a quick way.

The configuration file is defined in the vpc.tf file, executed by the following command：

```bash
# download the module and dependency
make tf-init
# confirm changes to be made
make tf-plan
# apply the change
cd infra && terraform apply
```

The VPC was created successfully and the screenshot is shown below: 
![vpc](./assets/vpc.png)
![vpc-subnets](./assets/vpc-subnets.png)






###### This project is licensed under the MIT Open Source License
