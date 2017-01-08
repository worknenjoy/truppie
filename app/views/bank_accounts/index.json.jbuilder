json.array!(@bank_accounts) do |bank_account|
  json.extract! bank_account, :id, :marketplace_id, :bank_number, :agency_number, :agency_check_number, :account_number, :account_check_number, :type, :doc_type, :doc_number, :fullname, :active
  json.url bank_account_url(bank_account, format: :json)
end
