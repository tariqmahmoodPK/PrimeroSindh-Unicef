module UNHCRMapping
  extend ActiveSupport::Concern

  included do
    # TODO: Leaving unhcr_export_opt_out until we fix or discard the UNHCR export.
    store_accessor :data,
      :unhcr_needs_codes, :unhcr_export_opt_out, :unhcr_export_opt_in

    before_save :map_protection_concerns_to_unhcr_codes

    searchable do
      boolean :unhcr_export_opt_in
    end
  end

  def map_protection_concerns_to_unhcr_codes
    if self.is_a? Child
      @system_settings ||= SystemSettings.current
      unhcr_mapping = @system_settings.unhcr_needs_codes_mapping if @system_settings.present?

      if unhcr_mapping.present?
        concerns = self.protection_concerns

        if unhcr_mapping.autocalculate == true && unhcr_mapping.mapping.present? && concerns.present?
          mapping = unhcr_mapping.mapping

          self.unhcr_needs_codes = concerns.map{ |concern| mapping[concern] }.compact.uniq
        else
          self.unhcr_needs_codes = nil
        end
      end
    end
  end

end
