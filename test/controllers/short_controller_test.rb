require 'test_helper'

class ShortControllerTest < ActionDispatch::IntegrationTest
  test "short can be created" do
    json_string = {:url => "https://www.example.com", :shortcode => "example"}
    headers = { "CONTENT_TYPE" => "application/json" }
    headers2 = { 'Accept' => 'application/json' }
    post '/shorten', params: json_string, headers: headers, headers: headers2
    assert_response :success
  end

  test "short can be created with random shortcode" do
    json_string = {:url => "https://www.example.com", :shortcode => ""}
    headers = { "CONTENT_TYPE" => "application/json" }
    headers2 = { 'Accept' => 'application/json' }
    post '/shorten', params: json_string, headers: headers, headers: headers2
    assert_response :success
  end

  test "short can't be created" do
    json_string = {:url => "", :shortcode => "example"}
    headers = { "CONTENT_TYPE" => "application/json" }
    headers2 = { 'Accept' => 'application/json' }
    post '/shorten', params: json_string, headers: headers, headers: headers2
    assert_response 400
  end

  test "short can be redirect to url" do
    get '/'+Short.first.shortcode.to_s
    assert_response 302
  end

  test "short stats can show" do
    get '/'+Short.first.shortcode.to_s+'/stats'
    assert_response 200
  end
end
