FROM swaffy/cloud-template-base:latest
RUN apt-get install libssl
RUN apt-get install libssl-dev
FROM public.ecr.aws/lambda/ruby:latest

# You can overwrite command in `serverless.yml` template
CMD ["lib/lambda/handler.api_status"]