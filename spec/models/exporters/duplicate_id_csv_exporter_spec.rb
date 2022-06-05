# frozen_string_literal: true

require 'rails_helper'

module Exporters
  describe DuplicateIdCsvExporter do
    before :each do
      clean_data(Field, FormSection, Lookup, Child)

      Lookup.create!(id: 'lookup-gender',
                     name: 'Gender',
                     lookup_values_en: [{ id: 'male', display_text: 'Male' }.with_indifferent_access,
                                        { id: 'female', display_text: 'Female' }.with_indifferent_access,
                                        { id: 'other', display_text: 'Other' }.with_indifferent_access])

      fields = [
        Field.new(
          name: 'registration_date',
          type: 'date_field',
          display_name_all: 'Registration Date'
        ),
        Field.new('name' => 'name_caregiver',
                  'type' => 'text_field',
                  'display_name_all' => 'Name of Caregiver'),
        Field.new('name' => 'unhcr_individual_no',
                  'type' => 'text_field',
                  'display_name_all' => 'proGres Individual ID'),
        Field.new('name' => 'cpims_id',
                  'type' => 'text_field',
                  'display_name_all' => 'CPIMS ID'),
        Field.new('name' => 'national_id_no',
                  'type' => 'text_field',
                  'display_name_all' => 'MOHA ID'),
        Field.new('name' => 'case_id',
                  'type' => 'text_field',
                  'display_name_all' => 'Case ID'),
        Field.new('name' => 'name',
                  'type' => 'text_field',
                  'display_name_all' => 'Child Name'),
        Field.new('name' => 'age',
                  'type' => 'numeric_field',
                  'display_name_all' => 'Age'),
        Field.new('name' => 'sex',
                  'type' => 'select_box',
                  'display_name_all' => 'Sex',
                  'option_strings_source' => 'lookup lookup-gender'),
        Field.new('name' => 'family_count_no',
                  'type' => 'numeric_field',
                  'display_name_all' => 'Family Size'),
        Field.new('name' => 'other_agency_id',
                  'type' => 'text_field',
                  'display_name_all' => 'Hospital code and patient number')
      ]
      form = FormSection.new(
        unique_id: 'form_section_test_for_export',
        parent_form: 'case',
        visible: true,
        order_form_group: 50,
        order: 15,
        order_subform: 0,
        editable: true,
        name_all: 'Form Section Test',
        description_all: 'Form Section Test',
        fields: fields
      )
      form.save!

      @child_cls = Child.clone
      @test_child = Child.new
    end

    describe 'export configuration' do
      before :each do
        clean_data(ExportConfiguration, SystemSettings)
        SystemSettings.create(default_locale: 'en')
      end

      context 'when no export configuration' do
        it 'exports all defined properties' do
          data = DuplicateIdCsvExporter.export([@test_child])
          parsed = CSV.parse(data)
          expect(parsed[0]).to eq([' ',
                                   'MOHA ID DEPRECATED',
                                   'National ID No',
                                   'Case ID',
                                   'Progress ID',
                                   'Child Name',
                                   'Age',
                                   'Sex',
                                   'Family Size',
                                   'Hospital code and patient number'])
        end
      end

      context 'when export configuration is the same as properties defined in the exporter' do
        before do
          ExportConfiguration.create(unique_id: 'export-test-same', name: 'Test Same Properties',
                                     export_id: 'duplicate_id',
                                     property_keys: %w[
                                       moha_id
                                       case_id
                                       progress_id
                                       child_name_last_first
                                       age
                                       sex_mapping_m_f_u
                                       family_size
                                       other_agency_id
                                     ])

          SystemSettings.any_instance.stub(:export_config_id).and_return('duplicate_id' => 'export-test-same')
        end

        it 'exports all defined properties' do
          data = DuplicateIdCsvExporter.export([@test_child])
          parsed = CSV.parse(data)
          expect(parsed[0]).to eq([' ',
                                   'MOHA ID DEPRECATED',
                                   'Case ID',
                                   'Progress ID',
                                   'Child Name',
                                   'Age',
                                   'Sex',
                                   'Family Size',
                                   'Hospital code and patient number'])
        end
      end

      context 'unsafe data' do
        it 'sanitizes unsafe data' do
          unsafe_record = Child.new(data: { name: '=10+10', age: 12, sex: 'male' })

          data = DuplicateIdCsvExporter.export([unsafe_record])
          parsed = CSV.parse(data)
          expect(parsed[1][5]).to eq("'=10+10")
        end
      end

      context 'when export configuration is different than properties defined in the exporter' do
        context 'and the configuration is in a different order' do
          before do
            ExportConfiguration.create(unique_id: 'export-test-different-order', name: 'Test Properties Order',
                                       export_id: 'duplicate_id',
                                       property_keys: %w[
                                         case_id
                                         progress_id
                                         moha_id
                                         family_size
                                         progress_id
                                         child_name_last_first
                                         age
                                         sex_mapping_m_f_u
                                       ])

            SystemSettings.any_instance.stub(:export_config_id)
                          .and_return('duplicate_id' => 'export-test-different-order')
          end

          it 'exports properties in the same order as the config' do
            data = DuplicateIdCsvExporter.export([@test_child])
            parsed = CSV.parse(data)
            expect(parsed[0]).to eq([' ',
                                     'Case ID',
                                     'Progress ID',
                                     'MOHA ID DEPRECATED',
                                     'Family Size',
                                     'Child Name',
                                     'Age',
                                     'Sex'])
          end
        end

        context 'and the configuration has less property keys than defined in the exporter' do
          before do
            ExportConfiguration.create(unique_id: 'export-test-less', name: 'Test Less Properties',
                                       export_id: 'duplicate_id',
                                       property_keys: %w[
                                         moha_id
                                         age
                                         sex_mapping_m_f_u
                                         family_size
                                       ])

            SystemSettings.any_instance.stub(:export_config_id).and_return('duplicate_id' => 'export-test-less')
          end

          it 'exports only properties defined in the config' do
            data = DuplicateIdCsvExporter.export([@test_child])
            parsed = CSV.parse(data)
            expect(parsed[0]).to eq([' ',
                                     'MOHA ID DEPRECATED',
                                     'Age',
                                     'Sex',
                                     'Family Size'])
          end
        end

        context 'and the configuration has more property keys than defined in the exporter' do
          before do
            ExportConfiguration.create(unique_id: 'export-test-more', name: 'Test More Properties',
                                       export_id: 'duplicate_id',
                                       property_keys: %w[
                                         moha_id
                                         extra_1
                                         case_id
                                         progress_id
                                         extra_2
                                         child_name_last_first
                                         age
                                         sex_mapping_m_f_u
                                         extra_3
                                         family_size
                                       ])

            SystemSettings.any_instance.stub(:export_config_id).and_return('duplicate_id' => 'export-test-more')
          end

          it 'exports only the properties defined in the exporter' do
            data = DuplicateIdCsvExporter.export([@test_child])
            parsed = CSV.parse(data)
            expect(parsed[0]).to eq([' ',
                                     'MOHA ID DEPRECATED',
                                     'Case ID',
                                     'Progress ID',
                                     'Child Name',
                                     'Age',
                                     'Sex',
                                     'Family Size'])
          end
        end

        context 'and the configuration is missing properties and has more property keys than defined in the exporter' do
          before do
            ExportConfiguration.create(unique_id: 'export-test-mixture', name: 'Test Some More Some Less Properties',
                                       export_id: 'duplicate_id',
                                       property_keys: %w[
                                         moha_id
                                         extra_1
                                         progress_id
                                         extra_2
                                         child_name_last_first
                                         sex_mapping_m_f_u
                                         extra_3
                                         family_size
                                       ])

            SystemSettings.any_instance.stub(:export_config_id).and_return('duplicate_id' => 'export-test-mixture')
          end

          it 'exports only properties defined in the config and in the exporter' do
            data = DuplicateIdCsvExporter.export([@test_child])
            parsed = CSV.parse(data)
            expect(parsed[0]).to eq([' ',
                                     'MOHA ID DEPRECATED',
                                     'Progress ID',
                                     'Child Name',
                                     'Sex',
                                     'Family Size'])
          end
        end
      end
    end
  end
end
