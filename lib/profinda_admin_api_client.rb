class ProfindaAdminApiClient < ProfindaApiClient

  ADMIN_CREDENTIALS = {
    user: 'admin@cooltribes.com',
    password: 'AlumNet2015'
  }

  ## Instance Methods
  def initialize
    authenticate(ADMIN_CREDENTIALS[:user], ADMIN_CREDENTIALS[:password])
  end

  def activate(uid)
    put("/admin/users/#{uid}/activate", { body: { active: true }.to_json })
    valid?
  end

  def suspend(uid)
    put("/admin/users/#{uid}/suspend", { body: { active: false }.to_json })
    valid?
  end

  def dictionary_objects_by_id(collection_ids)
    return [] if collection_ids.empty?
    dictionary = get("/admin/dictionary_objects", { query: { ids: collection_ids } })
    dictionary ? dictionary["entries"] : []
  end

end
