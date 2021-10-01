# frozen_string_literal: true


module ExtendRubySdk
  class Product
    class << self
      # Returns information about a product.
      #
      # @param client [ExtendRubySdk::Client] client instance
      # @param store_id [String] unique identifier for a store on Extend
      # @param id [String] the unique reference id passed to Extend when
      #   creating a product
      def retrieve(id, client:, store_id:)
        product = client.get(path_with_id(store_id, id)).with_indifferent_access
        build product
      end

      # This will create a product if it doesn't exist or update a product that
      # does exist.
      #
      # @param data [Hash]
      # @see https://developers.helloextend.com/2021-04-01#tag/Products/paths/~1stores~1{storeId}~1products/post
      #   for request body schema
      # @param client [ExtendRubySdk::Client] client instance
      # @param store_id [String] unique identifier for a store on Extend
      def create(data, client:, store_id:)
        product = client.post(path(store_id), data).with_indifferent_access
        build product
      end

      # This will delete a product on Extend.
      #
      # @param id [String] the unique reference id to delete
      # @param client [ExtendRubySdk::Client] client instance
      # @param store_id [String] unique identifier for a store on Extend
      def delete(id, client:, store_id:)
        response = client.delete(path_with_id(store_id, id))

        if response.code == 200
          response.body
        else
          response.with_indifferent_access
        end
      end

      private

      def build(product)
        new(
          product[:brand],
          product[:category],
          product[:description],
          product[:imageUrl],
          product[:mfrWarranty],
          product[:price],
          product[:title],
          product[:referenceId],
          product[:parentReferenceId],
          product[:identifiers],
          product[:enabled],
          product[:status],
          product[:createdAt],
          product[:updatedAt],
          product[:deletedAt]
        )
      end

      def path(store_id)
        "stores/#{store_id}/products"
      end

      def path_with_id(store_id, id)
        "#{path(store_id)}/#{id}"
      end
    end

    def initialize(
      brand,
      category,
      description,
      image_url,
      mfr_warranty,
      price,
      title,
      reference_id,
      parent_reference_id,
      identifiers,
      enabled,
      status,
      created_at,
      updated_at,
      deleted_at
    )
      @brand = brand
      @category = category
      @description = description
      @image_url = image_url
      @mfr_warranty = mfr_warranty
      @price = price
      @title = title
      @reference_id = reference_id
      @parent_reference_id = parent_reference_id
      @identifiers = identifiers
      @enabled = enabled
      @status = status
      @created_at = created_at
      @updated_at = updated_at
      @deleted_at = deleted_at
    end
    attr_reader :brand, :category, :description, :image_url, :mfr_warranty, :price, :title, :reference_id, :parent_reference_id, :identifiers, :enabled, :status, :created_at, :updated_at, :deleted_at
  end
end
