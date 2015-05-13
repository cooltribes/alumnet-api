class ContactImporter
  include ActiveModel::Model

  DEFAULT_OPTIONS = { headers: true }

  validate :contacts_count, :format_of_header

  def initialize(file, options = {})
    options = options.merge(DEFAULT_OPTIONS)
    @csv = CSV.read(file, options)
  end

  def contacts
    if valid?
      @contacts ||= @csv.map(&:to_h)
    else
      []
    end
  end

  def count
    @csv.count
  end

  protected
    def contacts_count
      errors.add(:count, 'The file no contain any contact') if count == 0
    end

    def format_of_header
      unless @csv.headers.include?("name") && @csv.headers.include?("email")
        errors.add(:headers, 'The format of header is not valid')
      end
    end
end