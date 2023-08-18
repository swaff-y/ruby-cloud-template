#!/usr/bin/env ruby

require 'sinatra'
require_relative '../lib/lambda/handler'

get /.*/ do
  request_path = request.path_info
  pwd = File.dirname(__FILE__).gsub(/\/bin/, "")
  sls = YAML.load_file("#{pwd}/serverless.yml")
  functions = sls['functions'].keys
  functions.each do |key|
    func = sls.dig('functions', key)
    path = func&.dig('events', 0, 'http', 'path')
    match = match_path(path, request_path)
      
    if match
      params.merge!(match)
      event = create_event(params, request)
      return send(key.to_sym, { event: event, context: 'context' })
    end
  end
  JSON.generate({ error: 'route does not exist' })
end

post /.*/ do
  request_path = request.path_info
  pwd = File.dirname(__FILE__).gsub(/\/bin/, "")
  sls = YAML.load_file("#{pwd}/serverless.yml")
  functions = sls['functions'].keys
  functions.each do |key|
    func = sls.dig('functions', key)
    path = func&.dig('events', 0, 'http', 'path')
    match = match_path(path, request_path)
      
    if match
      params.merge!(match)
      event = create_event(params, request)
      return send(key.to_sym, { event: event, context: 'context' })
    end
  end
  JSON.generate({ error: 'route does not exist' })
end

put /.*/ do
  request_path = request.path_info
  pwd = File.dirname(__FILE__).gsub(/\/bin/, "")
  sls = YAML.load_file("#{pwd}/serverless.yml")
  functions = sls['functions'].keys
  functions.each do |key|
    func = sls.dig('functions', key)
    path = func&.dig('events', 0, 'http', 'path')
    match = match_path(path, request_path)
      
    if match
      params.merge!(match)
      event = create_event(params, request)
      return send(key.to_sym, { event: event, context: 'context' })
    end
  end
  JSON.generate({ error: 'route does not exist' })
end

delete /.*/ do
  request_path = request.path_info
  pwd = File.dirname(__FILE__).gsub(/\/bin/, "")
  sls = YAML.load_file("#{pwd}/serverless.yml")
  functions = sls['functions'].keys
  functions.each do |key|
    func = sls.dig('functions', key)
    path = func&.dig('events', 0, 'http', 'path')
    match = match_path(path, request_path)
      
    if match
      params.merge!(match)
      event = create_event(params, request)
      return send(key.to_sym, { event: event, context: 'context' })
    end
  end
  JSON.generate({ error: 'route does not exist' })
end

def match_path(path, requested_path)
  return false if path.nil?

  return false if requested_path.nil?

  path_arr = path.split("/")
  requested_path_arr = requested_path.split("/")
  params = {}

  if path_arr.length == requested_path_arr.length
    path_arr.each_with_index do |value, index|
      if value.match(/{.*}/)
        params[value.gsub(/{/, '').gsub(/}/, '').to_sym] = requested_path_arr[index]
      elsif value != requested_path_arr[index]
        return false
      end
    end
  else
    return false
  end

  params
end

def create_event(params, request)
{
  'resource' => request.env['REQUEST_PATH'],
  'path' => request.env['REQUEST_PATH'],
  'httpMethod' => request.env['REQUEST_METHOD'],
  'headers' => {
    'Authorization' => request.env['HTTP_AUTHORIZATION'],
    'content-type' => request.env['CONTENT_TYPE'],
    'Host' => request.env['HTTP_HOST'],
    'User-Agent' => request.env['HTTP_USER_AGENT'],
  },
  'queryStringParameters' => request.env['rack.request.query_hash'],
  'pathParameters' => get_path_params(request.env['rack.request.query_hash'], params),
  'requestContext' => {},
  'body' => request&.body&.read
}
end

def get_path_params(path_params, params)
  ret_hash = {}

  params.keys.each do |key| 
    ret_hash[key] = params[key] unless path_params.has_key? key
  end

  ret_hash
end

# {
#   "resource": "/categories",
#   "path": "/categories",
#   "httpMethod": "GET",
#   "headers": {
#     "Authorization":"",
#     "Accept": "*/*",
#     "CloudFront-Forwarded-Proto": "https",
#     "CloudFront-Is-Desktop-Viewer": "true",
#     "CloudFront-Is-Mobile-Viewer": "false",
#     "CloudFront-Is-SmartTV-Viewer": "false",
#     "CloudFront-Is-Tablet-Viewer": "false",
#     "CloudFront-Viewer-ASN": "135887",
#     "CloudFront-Viewer-Country": "AU",
#     "content-type": "application/json",
#     "Host": "api.swaff.name",
#     "User-Agent": "curl/7.77.0",
#     "Via": "2.0 f5f7422e3d360428143f88538f4ecb8e.cloudfront.net (CloudFront)",
#     "X-Amz-Cf-Id": "SyLr0AyogucRRq7yw-w62T6I92o7econqfv_in_0DilWWZ8Sm2LXAw==",
#     "X-Amzn-Trace-Id": "Root=1-63c3e172-45d69e135be9d0b74098d946",
#     "X-Forwarded-For": "149.167.35.134, 64.252.187.83",
#     "X-Forwarded-Port": "443",
#     "X-Forwarded-Proto": "https"
#   },
#   "multiValueHeaders": {
#     "Accept": [ "*/*" ],
#     "CloudFront-Forwarded-Proto": [ "https" ],
#     "CloudFront-Is-Desktop-Viewer": [ "true" ],
#     "CloudFront-Is-Mobile-Viewer": [ "false" ],
#     "CloudFront-Is-SmartTV-Viewer": [ "false" ],
#     "CloudFront-Is-Tablet-Viewer": [ "false" ],
#     "CloudFront-Viewer-ASN": [ "135887" ],
#     "CloudFront-Viewer-Country": [ "AU" ],
#     "content-type": [ "application/json" ],
#     "Host": [ "api.swaff.name" ],
#     "User-Agent": [ "curl/7.77.0" ],
#     "Via": [
#       "2.0 f5f7422e3d360428143f88538f4ecb8e.cloudfront.net (CloudFront)"
#     ],
#     "X-Amz-Cf-Id": [ "SyLr0AyogucRRq7yw-w62T6I92o7econqfv_in_0DilWWZ8Sm2LXAw==" ],
#     "X-Amzn-Trace-Id": [ "Root=1-63c3e172-45d69e135be9d0b74098d946" ],
#     "X-Forwarded-For": [ "149.167.35.134, 64.252.187.83" ],
#     "X-Forwarded-Port": [ "443" ],
#     "X-Forwarded-Proto": [ "https" ]
#   },
#   "queryStringParameters": null,
#   "multiValueQueryStringParameters": null,
#   "pathParameters": null,
#   "stageVariables": null,
#   "requestContext": {
#     "resourceId": "soamk4",
#     "resourcePath": "/categories",
#     "httpMethod": "GET",
#     "extendedRequestId": "eyAp3FL5SwMF8-w=",
#     "requestTime": "15/Jan/2023:11:20:18 +0000",
#     "path": "/categories",
#     "accountId": "572131386763",
#     "protocol": "HTTP/1.1",
#     "stage": "dev",
#     "domainPrefix": "api",
#     "requestTimeEpoch": 1673781618127,
#     "requestId": "fbd96b5b-8de6-4ae6-813c-a31f09b672fd",
#     "identity": {
#       "cognitoIdentityPoolId": null,
#       "accountId": null,
#       "cognitoIdentityId": null,
#       "caller": null,
#       "sourceIp": "149.167.35.134",
#       "principalOrgId": null,
#       "accessKey": null,
#       "cognitoAuthenticationType": null,
#       "cognitoAuthenticationProvider": null,
#       "userArn": null,
#       "userAgent": "curl/7.77.0",
#       "user": null
#     },
#     "domainName": "api.swaff.name",
#     "apiId": "6kprmguyfd"
#   },
#   "body": null,
#   "isBase64Encoded": false
# }