FROM swaffy/cloud-template-base:latest
RUN apt-get install libssl
RUN apt-get install libssl-dev
FROM public.ecr.aws/lambda/ruby:latest


COPY Gemfile Gemfile.lock Rakefile serverless.yml Dockerfile ./
RUN bundle install

COPY lib/ lib/

# You can overwrite command in `serverless.yml` template
CMD ["handler.api_status"]