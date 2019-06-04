json.set! :data do
  json.array! @contacts do |contact|
    json.partial! 'contacts/contact', contact: contact
    json.url  "
              #{link_to 'Show', contact }
              #{link_to 'Edit', edit_contact_path(contact)}
              #{link_to 'Destroy', contact, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end