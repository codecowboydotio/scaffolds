resource "aws_api_gateway_rest_api" "scaffold" {
  name = "${var.name-prefix}-${var.project}-api-gw"
  description = "scaffold webhook example"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-api-gw"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.scaffold.id
   parent_id   = aws_api_gateway_rest_api.scaffold.root_resource_id
   path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "proxy" {
   rest_api_id   = aws_api_gateway_rest_api.scaffold.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.scaffold.id
   resource_id = aws_api_gateway_method.proxy.resource_id
   http_method = aws_api_gateway_method.proxy.http_method
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.scaffold_webhook.invoke_arn
}




resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = aws_api_gateway_rest_api.scaffold.id
   resource_id   = aws_api_gateway_rest_api.scaffold.root_resource_id
   http_method   = "ANY"
   authorization = "NONE"
}
resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = aws_api_gateway_rest_api.scaffold.id
   resource_id = aws_api_gateway_method.proxy_root.resource_id
   http_method = aws_api_gateway_method.proxy_root.http_method
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.scaffold_webhook.invoke_arn
}


resource "aws_api_gateway_deployment" "scaffold" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]
   rest_api_id = aws_api_gateway_rest_api.scaffold.id
   stage_name  = "test"
}


resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.scaffold_webhook.function_name
   principal     = "apigateway.amazonaws.com"
# The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.scaffold.execution_arn}/*/*"
}

output "base_url" {
  value = aws_api_gateway_deployment.scaffold.invoke_url
}
output "url" {
  value = aws_api_gateway_deployment.scaffold.*
}
