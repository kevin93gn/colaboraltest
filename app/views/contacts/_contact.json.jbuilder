json.extract! contact, :id, :first_name, :last_name, :email, :enterprise, :job, :linkedin_url, :consultant, :category, :status, :created_at, :updated_at
json.url contact_url(contact, format: :json)
