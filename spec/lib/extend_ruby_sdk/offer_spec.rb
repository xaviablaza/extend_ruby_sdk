require "spec_helper"

RSpec.describe ExtendRubySdk::Offer do
  describe '.retrieve' do
    before do
      ExtendRubySdk.configure do |c|
        c.access_token = CONFIG[:access_token]
      end
    end
    context "product with plans" do
      it "retrieves a single offer with plan information", { vcr: { record: :once, match_requests_on: %i[method] } } do
        client = ExtendRubySdk::Client.new(sandbox: true)
        offer = described_class.retrieve(
          "2068262",
          client: client,
          store_id: "e6f902e9-9942-4fcb-9b23-29975ee18dfc"
        )

        expect(offer).to be_a ExtendRubySdk::Offer
      end
    end
    context "product with no plans" do
      it "retrieves a single offer with no plan information", { vcr: { record: :once, match_requests_on: %i[method] } } do
        client = ExtendRubySdk::Client.new(sandbox: true)
        offer = described_class.retrieve(
          "2324f800-7575-4c65-bd2c-588c89e8ab7f",
          client: client,
          store_id: "e6f902e9-9942-4fcb-9b23-29975ee18dfc"
        )

        expect(offer).to be_a ExtendRubySdk::Offer
      end
    end
  end
end
