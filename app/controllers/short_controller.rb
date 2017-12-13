class ShortController < ApplicationController
  skip_before_action :verify_authenticity_token
  protect_from_forgery prepend: true
  before_action :short_params, :only => [:create]

  def create
    unless $params['shortcode'].present?
      charset = Array('A'..'Z') + Array('a'..'z') + Array('0'..'9')
      $params['shortcode'] = Array.new(6) { charset.sample  }.join
    end
    if !($params['shortcode'] =~ /^[0-9a-zA-Z_]{4,}$/)
      render status: 422, json: {
        message: "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$."
      }.to_json
    end
    if Short.find_by(shortcode: $params['shortcode'])
      render status: 409, json: {
        message: "The the desired shortcode is already in use. Shortcodes are case-sensitive."
      }.to_json
    end
    if Short.new($params).save
      render status: 200, json: {
        shortcode: $params['shortcode']
      }.to_json
    end
  end

  def show
    unless short =  Short.find_by(shortcode: params[:shortcode])
      render status: 404, json: {
        message: "The shortcode cannot be found in the system"
      }.to_json
    else
      log = Log.new
      log.short = short
      log.seen = DateTime.now
      log.save
      render status: 302, location: short['url'].to_s, layout: false, json: {
        Location: short['url']
      }
    end
  end

  def stat
    unless short = Short.find_by(shortcode: params[:shortcode])
      render status: 404, json: {
        message: "The shortcode cannot be found in the system"
      }.to_json
    else
      log = Log.where(short: short).order('seen DESC')
      redirectCount = log.count
      lastSeenDate = (redirectCount == 0) ? nil : log.first['created_at']
      render status: 200, json: {
        startDate: short['created_at'],
        lastSeenDate: lastSeenDate,
        redirectCount: redirectCount
      }
    end
  end

  private
  def short_params
    $params = params.permit("url", "shortcode")
    unless $params['url'].present?
      render status: 400, json: {
        message: "url is not present"
      }.to_json
    end
  end
end
