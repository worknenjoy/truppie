json.array!(@bank_accounts) do |bank_account|
  json.extract! bank_account, :id, :bankNumber, :agencyNumber, :agencyCheckNumber, :accountNumber, :accountCheckNumber, :type, :doc_type, :doc_number, :fullname, :organizer_id, :uid
  json.url bank_account_url(bank_account, format: :json)
end
