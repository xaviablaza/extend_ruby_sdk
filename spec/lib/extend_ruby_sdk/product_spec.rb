require 'spec_helper'

RSpec.describe ExtendRubySdk::Product do
  describe '.retrieve' do
    before do
      ExtendRubySdk.configure do |c|
        c.access_token = CONFIG[:access_token]
      end
    end
    it 'retrieves a single product', { vcr: { record: :once, match_requests_on: %i[method] } } do
      client = ExtendRubySdk::Client.new(sandbox: true)
      product = described_class.retrieve(
        "2324f800-7575-4c65-bd2c-588c89e8ab7f",
        client: client,
        store_id: 'e6f902e9-9942-4fcb-9b23-29975ee18dfc'
      )

      expect(product).to be_a ExtendRubySdk::Product
    end
  end
  describe '.create' do
    before do
      ExtendRubySdk.configure do |c|
        c.access_token = CONFIG[:access_token]
      end
    end
    it 'creates a single product', { vcr: { record: :once, match_requests_on: %i[method] } } do
      client = ExtendRubySdk::Client.new(sandbox: true)
      product = described_class.create(
        {
          'brand' => 'Sample Brand',
          'category' => 'Sample Category',
          'description' =>'Sample Description',
          'imageUrl' => 'https://i.picsum.photos/id/946/200/300.jpg?hmac=4NmmK793hUBmx2qGX9mbsWLk9AF6kGjngYA9C-RMyJQ',
          'mfrWarranty' => {
            'parts' => 12,
            'labor' => 12,
            'url' => 'http://example.com'
          },
          'price' => {
            'currencyCode' => 'USD',
            'amount' => 1999
          },
          'title' => 'Explosive Tennis Balls',
          "referenceId" => "2324f800-7575-4c65-bd2c-588c89e8ab7f",
          'parentReferenceId' => "2324f800-7575-4c65-bd2c-588c89e8ab7f",
          'identifiers' => {
            'sku' => 'SAMPLE-SKU',
            'gtin' =>'012345678901234',
            'upc' => '0123456789012',
            'asin' => '0123456789',
            'barcode' => '123'
          }
        },
        client: client,
        store_id: 'e6f902e9-9942-4fcb-9b23-29975ee18dfc'
      )

      expect(product).to be_a ExtendRubySdk::Product
    end
  end
  describe '.delete' do
    before do
      ExtendRubySdk.configure do |c|
        c.access_token = CONFIG[:access_token]
      end
    end
    it 'deletes a single product', { vcr: { record: :once, match_requests_on: %i[method] } } do
      client = ExtendRubySdk::Client.new(sandbox: true)
      response = described_class.delete(
        "2324f800-7575-4c65-bd2c-588c89e8ab7f",
        client: client,
        store_id: 'e6f902e9-9942-4fcb-9b23-29975ee18dfc'
      )

      expect(response).to eq "success"
    end
    it 'fails to delete a single product', { vcr: { record: :once, match_requests_on: %i[method] } } do
      client = ExtendRubySdk::Client.new(sandbox: true)
      response = described_class.delete(
        "non_existent_reference_id",
        client: client,
        store_id: 'e6f902e9-9942-4fcb-9b23-29975ee18dfc'
      )

      expect(response[:code]).to eq "resource_not_found"
      expect(response[:message]).to eq "The resource requested cannot be found."
    end
  end
end
