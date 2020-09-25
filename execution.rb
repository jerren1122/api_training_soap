require 'savon'
require 'nokogiri/xml'

class Execution
  include Nokogiri::XML
  attr_accessor(:wsdl, :client)

  def initialize
    @wsdl = "http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso?WSDL"
    @client = Savon.client(wsdl: wsdl)
  end

  def condition_response(response)
    Nokogiri::XML.parse(response.to_s).text.split("").keep_if{|value| value.match(/(\w| )/)}.join.strip
  end

  def currency(isoCode)
    operation = "currency_name"
    xml ={"sCurrencyISOCode" => "#{isoCode}"}
    response = client.call(operation.to_sym, message: xml)
    condition_response(response)
  end

  def list_of_currency_codes
    operation = "list_of_currencies_by_code"
    response = client.call(operation.to_sym)
    counter = 0
    condition_response(response).split(' ').join(' ')
  end
end

exec = Execution.new
puts exec.currency("CAD")
puts exec.list_of_currency_codes




