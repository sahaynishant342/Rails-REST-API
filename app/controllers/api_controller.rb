class ApiController < ApplicationController

  # api_key to be passed in the request header
  def authenticate
    api_key = request.headers['X-Api-Key']

    if not api_key
      render status: :unauthorized, :json => { msg: 'no api key' }.to_json
      return
    end

    tenant = Tenant.where(api_key: api_key).first

    if tenant
      # TODO: find a better way to keep track of API hits
      tenant.api_count += 1
      tenant.save
    else
      render status: :unauthorized, :json => { msg: 'invalid api key' }.to_json
    end
  end

end
