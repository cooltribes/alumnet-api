class ContactImporter
  include ActiveModel::Model

  DEFAULT_OPTIONS = { headers: true, encoding: "ISO-8859-1" }

  def initialize(file, options = {})
    options = options.merge(DEFAULT_OPTIONS)
    @csv = CSV.read(file, options) if check_file(file)
  rescue => e
    errors.add(:main, e.message)
  end

  def contacts
    if valid?
      @contacts ||= @csv.map(&:to_h)
    else
      []
    end
  end

  def valid?
    check_contacts_count
    check_format_of_header
    errors.empty?
  end

  def count
    @csv.count if @csv
  end

  protected
    def check_file(file)
      # TODO: Usar el objecto file en vez de usar el path :Armando
      if file.split(".").last.downcase == "csv"
        true
      else
        errors.add(:file, 'The file extension is incorrect')
        false
      end
    end

    def check_contacts_count
      errors.add(:count, 'The file no contain any contact') if count == 0
    end

    def check_format_of_header
      if @csv && !@csv.headers.include?("name") && !@csv.headers.include?("email")
        errors.add(:headers, 'The format of header is not valid')
      end
    end
end