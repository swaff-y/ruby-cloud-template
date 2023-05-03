FROM public.ecr.aws/lambda/ruby:latest

RUN yum update -y
RUN yum install -y openssl-devel mongodb-org make gcc

COPY Gemfile Gemfile.lock Rakefile Dockerfile ./
RUN bundle config set --local without 'development test'
ENV GEM_HOME=${LAMBDA_TASK_ROOT}
RUN bundle install

ENV STAGE kaos

COPY lib/ lib/

CMD ["lib/lambda/handler.api_status"]