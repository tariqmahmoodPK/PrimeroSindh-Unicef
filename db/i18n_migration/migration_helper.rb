module MigrationHelper
  def generate_keyed_value(value)
    if value.present?
      if value.is_a?(String)
        value =
            value.gsub(/\r\n?/, "\n").split("\n")
                .map{|v| v.present? ? {id: v.parameterize.underscore, display_text: v}.with_indifferent_access : nil}
                .compact
      elsif value.is_a?(Array)
        if value.first.is_a?(String)
          value = value.map{|v| v.present? ? {id: v.parameterize.underscore, display_text: v}.with_indifferent_access : nil}.compact
        elsif value.first.is_a?(Hash)
          value
        end
      end
    end
  end

  def translate_keyed_value(value, base_value)
    return [] if value.blank? || base_value.blank?
    if value.is_a?(String)
      value =
        value.gsub(/\r\n?/, "\n").split("\n")
          .map.with_index{|v, i| (v.present? && base_value[i].present?) ? {id: base_value[i][:id], display_text: v}.with_indifferent_access : nil}
          .compact
    elsif value.is_a?(Array)
      if value.first.is_a?(String)
        value = value.map.with_index{|v, i| (v.present? && base_value[i].present?) ? {id: base_value[i][:id], display_text: v}.with_indifferent_access : nil}.compact
      elsif value.first.is_a?(Hash)
        value
      end
    end
  end

  #Only the current configured locales to be used when creating new fields
  def create_locales
    I18n.available_locales.each do |locale|
      yield(locale)
    end
  end

  #List of possible locales that are not part of the list of locales configured for the current system
  def locales_to_discard
    Primero::Application::LOCALES - I18n.available_locales
  end

  #Throw away locale specific property data that isn't among one of the configured locales
  def discard_locales(object_hash, key)
    locales_to_discard.each{|locale| object_hash.delete("#{key}_#{locale}")}
  end

  def get_fields(form_section)
    field_types = ['select_box', 'tick_box', 'radio_button', 'subform']
    form_section.fields.select{|f| field_types.include?(f.type) || f.is_location? }
  end

  def get_option_list(field, locations)
    field.options_list(nil, nil, locations, true)
  end

  def get_value(value, options)
    if value.present? && options.present?
      if value.is_a?(Array)
        value = options.select{|option| value.include?(option['display_text'])}
               .map{|option| option['id']}
        value if value.present?
      else
        option = options.select{|option| option['display_text'] == value}.first
        option['id'] if option.present?
      end
    end
  end

  def get_field_options(prefix)
    fields = {}
    prefix = 'case' if prefix == 'child'
    locations = Location.all_names

    FormSection.find_by_parent_form(prefix).each do |fs|
      i18n_fields = get_fields(fs)

      i18n_fields.each do |field|
        if field.subform_section.present?
          fields[field.name] = {} unless fields[field.name].present?
          sub_fields = get_fields(field.subform_section)
          sub_fields.each do |sf|
            sub_options = get_option_list(sf, locations)
            fields[field.name][sf.name] = sub_options if sub_options.present?
          end
        else
          options = get_option_list(field, locations)
          fields[field.name] = options if options.present?
        end
      end
    end

    fields
  end

  def create_or_update_lookup(lookup_hash)
    lookup_id = lookup_hash[:id]
    lookup = Lookup.get lookup_id

    if lookup.nil?
      puts "Creating lookup #{lookup_id}"
      Lookup.create! lookup_hash
    else
      puts "Updating lookup #{lookup_id}"
      lookup.update_attributes lookup_hash
    end
  end
end
