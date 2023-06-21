# Use this code snippet in your app.
# If you need more information about configurations or implementing the sample code, visit the AWS docs:
# https://aws.amazon.com/developer/language/ruby/

require 'aws-sdk-secretsmanager'

def get_rds_connection
  client = Aws::SecretsManager::Client.new(region: 'ap-northeast-1')

  begin
    get_secret_value_response = client.get_secret_value(secret_id: 'RdsConnection')
  rescue StandardError => e
    # For a list of exceptions thrown, see
    # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
    raise e
  end

  secret = get_secret_value_response.secret_string
end

rds_connection = get_rds_connection
db_config = JSON.parse(rds_connection)

ENV['DB_HOST'] = db_config['host']
ENV['DB_USERNAME'] = db_config['username']
ENV['DB_PASSWORD'] = db_config['password']
ENV['DB_NAME'] = db_config['dbname']
