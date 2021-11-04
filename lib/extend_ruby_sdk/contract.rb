# frozen_string_literal: true


module ExtendRubySdk
  class Contract
    class << self
      # When a customer buys an extended warranty or protection plan for their
      # product, they are purchasing a warranty Contract. Your store needs to
      # record all new warranty plan purchases with Extend so we can create a
      # new contract and deliver it to the customer. You will also need to
      # record any warranty returns / refunds so we can cancel the contract and
      # account for the refunded amount.
      #
      # You can record the warranty plan purchase by creating a new warranty
      # contract.
      def create(data, client:, store_id:)
        contract = client.post(path(store_id), data).with_indifferent_access
        build contract
      end

      def update(contract_id, data:, client:)
        contract = client.put(contract_path(contract_id), data).with_indifferent_access
        build contract
      end

      def cancel(contract_id, client:, store_id:, commit: true)
        contract = client.post(
          cancel_path(store_id, contract_id),
          query: { "commit" => commit }
        ).with_indifferent_access
        build contract
      end
      alias refund cancel

      private

      def cancel_path(store_id, contract_id)
        "#{path(store_id)}/#{contract_id}/refund"
      end

      def contract_path(contract_id)
        "contracts/#{contract_id}"
      end

      def path(store_id)
        "stores/#{store_id}/contracts"
      end

      def build(contract)
        return ErrorResult.new(contract[:code], contract[:message]) if contract.has_key?(:code)

        new(
          contract[:id],
          contract[:customer],
          contract[:plan],
          contract[:poNumber],
          contract[:product],
          contract[:source],
          contract[:transactionDate],
          contract[:transactionId],
          contract[:transactionTotal],
          contract[:terms],
          contract[:isTest],
          contract[:refundAmount],
          contract[:status],
          contract[:refundedAt],
          contract[:createdAt],
          contract[:updatedAt]
        )
      end
    end

    def initialize(
      id,
      customer,
      plan,
      po_number,
      product,
      source,
      transaction_date,
      transaction_id,
      transaction_total,
      terms,
      is_test,
      refund_amount,
      status,
      refunded_at,
      created_at,
      updated_at
    )
      @id = id
      @customer = customer
      @plan = plan
      @po_number = po_number
      @product = product
      @source = source
      @transaction_date = transaction_date
      @transaction_id = transaction_id
      @transaction_total = transaction_total
      @terms = terms
      @is_test = is_test
      @refund_amount = refund_amount
      @status = status
      @refunded_at = refunded_at
      @created_at = created_at
      @updated_at = updated_at
    end
    attr_reader :id, :customer, :plan, :po_number, :product, :source, :transaction_date, :transaction_id, :transaction_total, :terms, :is_test, :refund_amount, :status, :refunded_at, :created_at, :updated_at
  end
end
