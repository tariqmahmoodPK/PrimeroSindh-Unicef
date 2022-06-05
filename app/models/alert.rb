# frozen_string_literal: true

# Describes a record alert in Primero.
class Alert < ApplicationRecord
  belongs_to :record, polymorphic: true
  belongs_to :agency, optional: true
  belongs_to :user, optional: true
  validates :alert_for, presence: { message: 'errors.models.alerts.alert_for' }

  before_create :generate_fields

  def generate_fields
    self.unique_id ||= SecureRandom.uuid
  end

  # This allows us to use the property 'type' on Alert, normally reserved by ActiveRecord
  def self.inheritance_column
    'type_inheritance'
  end
end
