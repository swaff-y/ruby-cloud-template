[![Build status](https://badge.buildkite.com/edf556f89423b7feeb4a78aec414b0259ebd4579732b24054c.svg)](https://buildkite.com/swaff-y/cloud-temp?branch=main) ![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/swaff-y/ruby-cloud-template)

# ruby-cloud-template

This repository is a comprehensive solution for building and deploying a robust REST API using AWS, Ruby, and MongoDB. It utilizes an efficient build pipeline with Buildkite to streamline the development process and supports the deployment of both development and production branches. The deployment process is powered by Serverless, ensuring seamless integration with AWS infrastructure.

The project follows the Model-View-Controller (MVC) architecture, providing a structured and scalable codebase. The MVC pattern separates the concerns of data management (Model), user interface (View), and application logic (Controller), resulting in a highly maintainable and extensible codebase.

## Key Features:
- **AWS Integration:** Leveraging the power of Amazon Web Services, the repository enables seamless deployment and management of your REST API.
- **Ruby Programming Language:** Built using the Ruby programming language, the repository takes advantage of its elegant syntax, flexibility, and extensive community support.
- **MongoDB Database:** The repository utilizes MongoDB, a scalable and high-performance NoSQL database, for efficient data storage and retrieval.
- **Build Pipeline with Buildkite:** The build pipeline, integrated with Buildkite, automates the build and testing processes, ensuring reliable and error-free code deployment.
- **Serverless Deployment:** By utilizing Serverless, the repository enables hassle-free deployment to AWS, eliminating the need for manual configuration and reducing operational overhead.

This repository serves as an ideal solution for developers looking to build REST APIs with a focus on scalability, maintainability, and efficiency. Whether you're starting a new project or enhancing an existing one, this repository provides a solid foundation for building powerful and reliable APIs.


## Stack Overview
- Ruby
- AWS Lambda
- AWS API Gateway
- AWS Cloudfront
- AWS Cloudwatch
- MongoDb
- Sinatra
- Docker
- Github
- Serverless
- rspec

## File Structure - ruby-cloud-template

The GitHub repository [swaff-y/ruby-cloud-template](https://github.com/swaff-y/ruby-cloud-template) follows a typical structure for a Ruby project with cloud deployment. The file structure is as follows:

```
ruby-cloud-template/
├── .buildkite/
│   ├── scripts/
│   │   ├── build_and_test.sh
│   │   ├── deploy.sh
│   │   ├── postman.sh
│   │   └── remove.sh
|   └── pipeline.yml
├── bin/
│   └── server.rb
├── lib/
│   ├── controllers/
│   │   ├── person.rb
│   │   ├── status.rb
│   │   └── swagger.rb
│   ├── exceptions/
│   │   └── exceptions.rb
│   ├── lambda/
│   │   ├── handler.rb
│   │   ├── parameters.rb
│   │   ├── request_body.rb
│   │   ├── responses.rb
│   │   └── security.rb
│   ├── models/
│   │   ├── base.rb
│   │   └── person.rb
│   ├── processors/
│   │   ├── base.rb
│   │   ├── fullname_processor.rb
│   │   └── swagger_processor.rb
│   ├── tasks/
│   │   ├── aws_login.rb
│   │   ├── coverage.rb
│   │   ├── deploy.rb
│   │   ├── postman.rb
│   │   └── swagger.rb
│   ├── validation/
│   │   ├── person.rb
│   │   ├── schema_validation.rb
│   │   └── status.rb
│   ├── config.rb
│   └── responses.rb
├── spec/
│   ├── controllers/
│   │   ├── person_spec.rb
│   │   ├── shared_context_spec.rb
│   │   ├── status_spec.rb
│   │   └── swagger_spec.rb
│   ├── exceptions/
│   │   └── exceptions_spec.rb
│   ├── fixtures/
│   │   ├── postman_failure_result.txt
│   │   ├── postman_success_result.txt
│   │   ├── postRequest.json
│   │   └── putRequest.json
│   ├── lambda/
│   │   ├── handler_spec.rb
│   │   ├── parameters_spec.rb
│   │   ├── request_body_spec.rb
│   │   ├── responses_spec.rb
│   │   └── security_spec.rb
│   ├── models/
│   │   ├── base_spec.rb
│   │   ├── person_spec.rb
│   │   ├── shared_context_spec.rb
│   │   └── status_spec.rb
│   ├── processors/
│   │   ├── base_processor_spec.rb
│   │   ├── fullname_processor_spec.rb
│   │   └── swagger_processor_spec.rb
│   ├── tasks/
│   │   ├── aws_login_spec.rb
│   │   ├── coverage_spec.rb
│   │   ├── deploy_spec.rb
│   │   ├── postman_spec.rb
│   │   └── swagger_spec.rb
│   ├── validation/
│   │   ├── person_spec.rb
│   │   ├── schema_validation_spec.rb
│   │   └── status_spec.rb
│   ├── config_spec.rb
│   ├── event_shared_context_spec.rb
│   ├── mongo_client_context_spec.rb
│   ├── config_spec.rb
│   ├── responses_spec.rb
│   └── spec_helper.rb
├── .rspec
├── .rubocop.yml
├── CHANGELOG.md
├── Dockerfile
├── Dockerfile-base
├── Dockerfile-test
├── Gemfile
├── Gemfile.lock
├── package-lock.json
├── package.json
├── postman_collection.json
├── Rakefile
├── README.md
└── serverless.yml
```

Here's a breakdown of the file structure:

- `.buildkite/`: Directory containing buildkite configuration files.
  - `scripts/`: Directory containing buildkite shell scripts for pipeline.
    - `build_and_test.sh`: Shell script file defining the build and test workflow.
    - `deploy.sh`: Shell script file defining the deploy workflow.
    - `postman.sh`: Shell script file defining the postman workflow.
    - `remove.sh`: Shell script file defining the remove from AWS workflow.
  - `pipeline.yml/`: YAML file defining the build workflow for the project.
  
- `bin/`: Directory containing the sinatra server script.
  - `server.rb`: RUBY file to start the sinatra server.

- `lib/`: Directory containing the application specific code.
  - `controlers/`: Directory for Ruby controller files that handle the application's logic.
  - `exceptions/`: Directory for Ruby exception files that handle the application's errors.
  - `lambda/`: Directory for Ruby AWS entry files that handle the application's AWS lambdas.
  - `models/`: Directory for Ruby model files representing the application's data.
  - `processors/`: Directory for Ruby processor files representing the application's processors.
  - `tasks/`: Directory for Ruby task files representing the application's rake tasks.
  - `validation/`: Directory for Ruby validation files representing the application's validations.
  - `config.rb`: RUBY file to host the applications config variables.
  - `responses.rb`: RUBY file to host the applications API responses. This template uses Jsend format

- `spec/`: Directory containing the application's test files.

- `.rspec`: File containing rspec configurations.

- `.rubocop`: File containing rubocop configurations.

- `.ruby-version`: File containing applications ruby version.

- `CHANGELOG.md`: Markdown file containing applications changes.

- `Dockefile`: File containing applications docker build.
  
- `Dockefile-base`: File containing applications base docker build.
  
- `Dockefile-test`: File containing applications test docker build.

- `Gemfile`: File specifying the Ruby gem dependencies required by the application.

- `Gemfile.lock`: File generated by Bundler to lock the specific versions of the gems installed.
  
- `package-lock.json`: File generated by package.json to lock the specific versions of the node packages installed.

- `package.json`: File specifying the node package dependencies required by the application (serverless).
  
- `postman_collection.json`: File specifying the postman collection with tests.

- `Rakefile`: Ruby file defining custom rake tasks for the project.

- `README.md`: Markdown file containing information and instructions about the repository.
  
- `serverless.yml`: YAML file containing the AWS cloudfront build.



The file structure provided above gives an overview of the organization and components of the `swaff-y/ruby-cloud-template` GitHub repository.

## Running locally

## Build actions

## Mongo DB databases
- Dev database
- Prod databse

## Buildkite
### Setting Up a Buildkite Pipeline

To set up a Buildkite pipeline, follow these steps:

1. **Sign up for Buildkite**: Go to the Buildkite website ([https://buildkite.com/](https://buildkite.com/)) and sign up for an account if you haven't already.

2. **Create a Buildkite pipeline**: Once you're logged in, click on "New Pipeline" to create a new pipeline.

3. **Connect your repository**: Select the version control system (e.g., GitHub, Bitbucket, GitLab) where your repository is hosted. Authenticate with your account and select the repository you want to connect.

4. **Configure your pipeline**: Buildkite provides a YAML-based pipeline configuration file (usually named `buildkite.yml`) to define your pipeline's steps and actions. Create this file in the root directory of your repository.

5. **Define pipeline steps**: In the `buildkite.yml` file, define the steps of your pipeline. These steps typically include tasks like building the code, running tests, and deploying the application. Each step can be customized with specific commands and environment settings.

6. **Commit and push the configuration file**: Commit the `buildkite.yml` file to your repository and push the changes. Buildkite will automatically detect the new file and use it to configure your pipeline.

7. **Configure build triggers**: Configure the trigger rules for your pipeline. This specifies when and under what conditions the pipeline should be triggered. You can set triggers based on branch names, tags, or specific events in your version control system.

8. **Configure agents**: Buildkite uses agents to execute the pipeline steps. Agents can be hosted on your own infrastructure or provided by Buildkite. Configure the agents based on your requirements, such as the number of concurrent builds, operating system, and environment.

9. **Save and activate the pipeline**: Once you've configured all the necessary settings, save the pipeline configuration. Activate the pipeline to make it active and ready to run.

10. **Test and iterate**: Trigger a build to test your pipeline. Monitor the build output, logs, and any potential issues. Iterate on your pipeline configuration as needed to refine and improve the build process.

By following these steps, you'll be able to set up a Buildkite pipeline to automate your build, test, and deployment processes.

## AWS
### Description
### Setup

[changelog-link]: ./CHANGELOG.md
[changelog-badge]: https://img.shields.io/badge/changelog%20version-0.1.1-blue.svg