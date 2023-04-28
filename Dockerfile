FROM swaffy/cloud-template-base:latest

RUN gem install aws_lambda_ric

COPY Gemfile Gemfile.lock Rakefile serverless.yml Dockerfile ./
RUN bundle config set --local without 'development test'
RUN bundle install

RUN mkdir -p /app
WORKDIR /app

COPY lib/ lib/

# You can overwrite command in `serverless.yml` template
ENTRYPOINT ["/usr/local/bin/aws_lambda_ric"]
CMD ["lib/lambda/handler.api_status"]