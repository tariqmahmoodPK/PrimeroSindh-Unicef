namespace :add_locations do
  desc 'Adding default locations'
  task add_new_locations: :environment do
  next if Location.find_by(location_code: "BAL").present?
  locations = [
    Location.new(placename_en: 'Zone 1', location_code: 'ZONE01', admin_level: 1, type: 'zone', hierarchy_path: 'ZONE01'),

    Location.new(placename_en: 'I-8', location_code: 'ZONE0101', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0101'),
    Location.new(placename_en: 'I-9', location_code: 'ZONE0102', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0102'),
    Location.new(placename_en: 'I-10', location_code: 'ZONE0103', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0103'),
    Location.new(placename_en: 'I-11', location_code: 'ZONE0104', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0104'),
    Location.new(placename_en: 'I-12', location_code: 'ZONE0105', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0105'),
    Location.new(placename_en: 'I-13', location_code: 'ZONE0106', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0106'),
    Location.new(placename_en: 'H-8', location_code: 'ZONE0107', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0107'),
    Location.new(placename_en: 'H-9', location_code: 'ZONE0108', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0108'),
    Location.new(placename_en: 'H-10', location_code: 'ZONE0109', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0109'),
    Location.new(placename_en: 'H-11', location_code: 'ZONE0110', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0110'),
    Location.new(placename_en: 'H-12', location_code: 'ZONE0111', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0111'),
    Location.new(placename_en: 'H-13', location_code: 'ZONE0112', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0112'),
    Location.new(placename_en: 'G-5', location_code: 'ZONE0113', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0113'),
    Location.new(placename_en: 'G-6', location_code: 'ZONE0114', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0114'),
    Location.new(placename_en: 'G-7', location_code: 'ZONE0115', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0115'),
    Location.new(placename_en: 'G-8', location_code: 'ZONE0116', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0116'),
    Location.new(placename_en: 'G-9', location_code: 'ZONE0117', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0117'),
    Location.new(placename_en: 'G-10', location_code: 'ZONE0118', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0118'),
    Location.new(placename_en: 'G-11', location_code: 'ZONE0119', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0119'),
    Location.new(placename_en: 'G-12', location_code: 'ZONE0120', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0120'),
    Location.new(placename_en: 'G-13', location_code: 'ZONE0121', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0121'),
    Location.new(placename_en: 'G-14', location_code: 'ZONE0122', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0122'),
    Location.new(placename_en: 'F-6', location_code: 'ZONE0123', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0123'),
    Location.new(placename_en: 'F-7', location_code: 'ZONE0124', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0124'),
    Location.new(placename_en: 'F-8', location_code: 'ZONE0125', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0125'),
    Location.new(placename_en: 'F-9', location_code: 'ZONE0126', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0126'),
    Location.new(placename_en: 'F-10', location_code: 'ZONE0127', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0127'),
    Location.new(placename_en: 'F-11', location_code: 'ZONE0128', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0128'),
    Location.new(placename_en: 'F-12', location_code: 'ZONE0129', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0129'),
    Location.new(placename_en: 'F-13', location_code: 'ZONE0130', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0130'),
    Location.new(placename_en: 'F-14', location_code: 'ZONE0131', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0131'),
    Location.new(placename_en: 'Golra Village', location_code: 'ZONE0132', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE01.ZONE0132'),

    Location.new(placename_en: 'Zone 2', location_code: 'ZONE02', admin_level: 1, type: 'zone', hierarchy_path: 'ZONE02'),
    Location.new(placename_en: 'Zone 3', location_code: 'ZONE03', admin_level: 1, type: 'zone', hierarchy_path: 'ZONE03'),

    Location.new(placename_en: 'Saidpur', location_code: 'ZONE0301', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE03.ZONE0301'),
    Location.new(placename_en: 'Shah Allah Ditta', location_code: 'ZONE0302', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE03.ZONE0302'),
    Location.new(placename_en: 'Talhar', location_code: 'ZONE0303', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE03.ZONE0303'),
    Location.new(placename_en: 'Damn-e-Koh', location_code: 'ZONE0304', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE03.ZONE0304'),
    Location.new(placename_en: 'Peer Sohawa', location_code: 'ZONE0305', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE03.ZONE0305'),

    Location.new(placename_en: 'Zone 4', location_code: 'ZONE04', admin_level: 1, type: 'zone', hierarchy_path: 'ZONE04'),

    Location.new(placename_en: 'Shahzad Town', location_code: 'ZONE0401', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE04.ZONE0401'),
    Location.new(placename_en: 'Bani Gala', location_code: 'ZONE0402', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE04.ZONE0402'),
    Location.new(placename_en: 'Park View City', location_code: 'ZONE0403', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE04.ZONE0403'),
    Location.new(placename_en: 'Bahria Enclave', location_code: 'ZONE0404', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE04.ZONE0404'),
    Location.new(placename_en: 'Rawal Lake', location_code: 'ZONE0405', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE04.ZONE0405'),
    Location.new(placename_en: 'Simli Dam', location_code: 'ZONE0406', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE04.ZONE0406'),

    Location.new(placename_en: 'Zone 5', location_code: 'ZONE05', admin_level: 1, type: 'zone', hierarchy_path: 'ZONE05'),

    Location.new(placename_en: 'Bahria Town', location_code: 'ZONE0501', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE05.ZONE0501'),
    Location.new(placename_en: 'PWD', location_code: 'ZONE0502', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE05.ZONE0502'),
    Location.new(placename_en: 'Defence Housing Authority', location_code: 'ZONE0503', admin_level: 2, type: 'constituent', hierarchy_path: 'ZONE05.ZONE0503')
  ]
  Location.locations_by_code = locations.map { |l| [l.location_code, l] }.to_h

  locations.each(&:name_from_hierarchy)

  locations.each(&:save!)
  GenerateLocationFilesService.generate
  end
end
