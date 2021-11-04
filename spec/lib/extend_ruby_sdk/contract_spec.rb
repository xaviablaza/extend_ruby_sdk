require 'spec_helper'

RSpec.describe ExtendRubySdk::Contract do
  describe ".cancel" do
    before do
      ExtendRubySdk.configure do |c|
        c.access_token = CONFIG[:access_token]
      end
    end
    context "with valid contract id and not yet cancelled" do
      it "returns a cancelled contract", { vcr: { record: :once, match_requests_on: %i[method] } } do
        client = ExtendRubySdk::Client.new(sandbox: true)
        contract_id = "a148620e-406a-4600-8cb3-b40c37dbf0ea"
        commit = true
        contract = described_class.cancel(
          contract_id,
          client: client,
          store_id: 'e6f902e9-9942-4fcb-9b23-29975ee18dfc',
          commit: commit
        )

        expect(contract).to be_a ExtendRubySdk::Contract
        expect(contract.status).to eq("refund_requested")
        expect(contract.refunded_at).to be_nil
      end
    end
    context "with invalid contract id" do
      it "returns an error", { vcr: { record: :once, match_requests_on: %i[method] } } do
        client = ExtendRubySdk::Client.new(sandbox: true)
        contract_id = "invalid-contract-id"
        commit = false
        contract = described_class.cancel(
          contract_id,
          commit: commit,
          client: client,
          store_id: 'e6f902e9-9942-4fcb-9b23-29975ee18dfc'
        )

        expect(contract).to be_a ExtendRubySdk::ErrorResult
      end
    end
    context "with valid contract id and already cancelled" do
      it "returns a contract with refunded_at not nil", { vcr: { record: :once, match_requests_on: %i[method] } } do
        client = ExtendRubySdk::Client.new(sandbox: true)
        contract_id = "a148620e-406a-4600-8cb3-b40c37dbf0ea"
        commit = true
        contract = described_class.cancel(
          contract_id,
          commit: commit,
          client: client,
          store_id: 'e6f902e9-9942-4fcb-9b23-29975ee18dfc'
        )

        expect(contract).to be_a ExtendRubySdk::Contract
        expect(contract.status).to eq("refund_accepted")
        expect(contract.refunded_at).to_not be_nil
      end
    end
  end
  describe ".update" do
    before do
      ExtendRubySdk.configure do |c|
        c.access_token = CONFIG[:access_token]
      end
    end
    context "with valid contract id" do
      it "returns an updated contract", { vcr: { record: :once, match_requests_on: %i[method] } } do
        client = ExtendRubySdk::Client.new(sandbox: true)
        contract_id = "a148620e-406a-4600-8cb3-b40c37dbf0ea"
        contract = described_class.update(
          contract_id,
          data: {
            "customer": {
              "phone": "234-567-8901",
              "email": "user@gmail.com",
              "name": "Alex Doe",
              "billingAddress": {
                "address1": "1025 Sansome Street",
                "address2": "",
                "city": "San Francisco",
                "countryCode": "US",
                "postalCode": "94111",
                "provinceCode": "CA"
              },
              "shippingAddress": {
                "address1": "1025 Sansome Street",
                "address2": "",
                "city": "San Francisco",
                "countryCode": "US",
                "postalCode": "94111",
                "provinceCode": "CA"
              }
            },
            "product": {
              "serialNumber": "ABCD123456"
            }
          },
          client: client
        )

        expect(contract).to be_a(ExtendRubySdk::Contract)
      end
    end
  end
  describe '.create' do
    before do
      ExtendRubySdk.configure do |c|
        c.access_token = CONFIG[:access_token]
      end
    end
    context "with valid plan id and product id" do
      it "returns a contract", { vcr: { record: :once, match_requests_on: %i[method] } } do
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
              "planId" => "A1-AAWAT-1y",
              "purchasePrice" => {
                "currencyCode" => "USD",
                "amount" => 8_499
              }
            },
            "poNumber" => "ABC-123",
            "product" => {
              "referenceId" => "2068262",
              "purchasePrice" => {
                "currencyCode" => "USD",
                "amount" => 160_000
              }
            },
            "source" => {
              "agentId" => "partner1234",
              "channel" => "web",
              "integratorId" => "netsuite",
              "locationId" => "store573",
              "platform" => "magento"
            },
            "transactionDate" => 1_636_066_219,
            "transactionId" => "99999999",
            "transactionTotal" => {
              "currencyCode" => "USD",
              "amount" => 170_000
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
            "transactionDate" => 1_636_066_219,
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
    context 'no plan id' do
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
            "transactionDate" => 1_636_066_219,
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
            "transactionDate" => 1_636_066_219,
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
