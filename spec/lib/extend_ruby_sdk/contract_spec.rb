require 'spec_helper'

RSpec.describe ExtendRubySdk::Contract do
  describe '.create' do
    before do
      ExtendRubySdk.configure do |c|
        c.access_token = CONFIG[:access_token]
      end
    end
    context 'product id does exist' do
      it 'returns a contract', { vcr: { record: :once, match_requests_on: %i[method] } } do
        client = ExtendRubySdk::Client.new(sandbox: true)
        contract = described_class.create(
          {
            "customer" => {
              "name" => "Bob Ross",
              "email" => "BobRoss@gmail.com",
              "phone" => "123-456-7890",
              "billingAddress" => {
                "address1" => "535 Mission Street",
                "address2" => "11th Floor",
                "city" => "San Francisco",
                "countryCode" => "US",
                "postalCode" => "94526",
                "provinceCode" => "CA"
              },
              "shippingAddress" => {
                "address1" => "535 Mission Street",
                "address2" => "11th Floor",
                "city" => "San Francisco",
                "countryCode" => "US",
                "postalCode" => "94526",
                "provinceCode" => "CA"
              }
            },
            "isTest" => true,
            "plan" => {
              # TODO: Get a planId that's valid
              "planId" => "",
              "purchasePrice" => {
                "currencyCode" => "USD",
                "amount" => 1999
              }
            },
            "poNumber" => "ABC-123",
            "product" => {
              "referenceId" => "SKU-123-456",
              "purchasePrice" => {
                "currencyCode" => "USD",
                "amount" => 1999
              }
            },
            "source" => {
              "agentId" => "partner1234",
              "channel" => "web",
              "integratorId" => "netsuite",
              "locationId" => "store573",
              "platform" => "magento"
            },
            "transactionDate" => 1563388069,
            "transactionId" => "99999999",
            "transactionTotal" => {
              "currencyCode" => "USD",
              "amount" => 1999
            },
            "terms" => {
              "termsId" => "154ebea0-6c1b-46a4-b166-03224633052",
              "version" => "1"
            }
          },
          client: client,
          store_id: 'e6f902e9-9942-4fcb-9b23-29975ee18dfc'
        )

        expect(contract).to be_a ExtendRubySdk::Contract
      end
    end
    context 'product id does not exist' do
      it 'returns an error result', { vcr: { record: :once, match_requests_on: %i[method] } } do
        client = ExtendRubySdk::Client.new(sandbox: true)
        contract = described_class.create(
          {
            "customer" => {
              "name" => "Bob Ross",
              "email" => "BobRoss@gmail.com",
              "phone" => "123-456-7890",
              "billingAddress" => {
                "address1" => "535 Mission Street",
                "address2" => "11th Floor",
                "city" => "San Francisco",
                "countryCode" => "US",
                "postalCode" => "94526",
                "provinceCode" => "CA"
              },
              "shippingAddress" => {
                "address1" => "535 Mission Street",
                "address2" => "11th Floor",
                "city" => "San Francisco",
                "countryCode" => "US",
                "postalCode" => "94526",
                "provinceCode" => "CA"
              }
            },
            "isTest" => true,
            "plan" => {
              "planId" => "10001-misc-elec-adh-replace-1y",
              "purchasePrice" => {
                "currencyCode" => "USD",
                "amount" => 1999
              }
            },
            "poNumber" => "ABC-123",
            "product" => {
              "referenceId" => "SKU-123-456",
              "purchasePrice" => {
                "currencyCode" => "USD",
                "amount" => 1999
              }
            },
            "source" => {
              "agentId" => "partner1234",
              "channel" => "web",
              "integratorId" => "netsuite",
              "locationId" => "store573",
              "platform" => "magento"
            },
            "transactionDate" => 1563388069,
            "transactionId" => "99999999",
            "transactionTotal" => {
              "currencyCode" => "USD",
              "amount" => 1999
            },
            "terms" => {
              "termsId" => "154ebea0-6c1b-46a4-b166-03224633052",
              "version" => "1"
            }
          },
          client: client,
          store_id: 'e6f902e9-9942-4fcb-9b23-29975ee18dfc'
        )

        expect(contract).to be_a ExtendRubySdk::ErrorResult
      end
    end
  end
end
