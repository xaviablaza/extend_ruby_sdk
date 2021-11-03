# frozen_string_literal: true


module ExtendRubySdk
  class Offer
    class << self
      # Retrieves information about an offer.
      # Returns warranty plans and pricing for a specific product.
      #
      # @param id [String] the unique reference id passed to Extend when
      #   creating a product
      # @param client [ExtendRubySdk::Client] Client instance. You should
      #   initialize this instance with a client_ip if it is available.
      # @param store_id [String] unique identifier for a store on Extend
      def retrieve(id, client:, store_id:)
        offer = client.get(path(id, store_id: store_id)).with_indifferent_access
        build offer
      end

      private

      def build(offer)
        new(
          offer[:plans], # Hash(String, String | Array)
          offer[:product], # Hash(String, String | Integer)
          offer[:marketing] # Hash(String, Hash(String, String | Object)
        )
      end

      def path(product_id, store_id:)
        "offers?storeId=#{store_id}&productId=#{product_id}"
      end
    end

    def initialize(
      plans,
      product,
      marketing
    )
      @plans = plans
      @product = product
      @marketing = marketing
    end
    attr_reader :plans, :product, :marketing
  end
end
