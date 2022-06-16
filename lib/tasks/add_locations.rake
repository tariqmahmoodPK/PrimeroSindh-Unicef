namespace :add_locations do
  desc 'Adding default locations'
  task add_new_locations: :environment do
  next if Location.find_by(location_code: "BAL").present?
  locations = [
    Location.new(placename_en: 'Larkana', location_code: 'LAR', admin_level: 1, type: 'district', hierarchy_path: 'LAR'),

    Location.new(placename_en: 'Bakrani', location_code: 'LAR01', admin_level: 2, type: 'tehsil', hierarchy_path: 'LAR.LAR01'),
    Location.new(placename_en: 'Dokri', location_code: 'LAR02', admin_level: 2, type: 'tehsil', hierarchy_path: 'LAR.LAR02'),
    Location.new(placename_en: 'Larkana', location_code: 'LAR03', admin_level: 2, type: 'tehsil', hierarchy_path: 'LAR.LAR03'),
    Location.new(placename_en: 'Rato Dero', location_code: 'LAR04', admin_level: 2, type: 'tehsil', hierarchy_path: 'LAR.LAR04'),

    Location.new(placename_en: 'Kashmore', location_code: 'KASH', admin_level: 1, type: 'district', hierarchy_path: 'KASH'),

    Location.new(placename_en: 'Kandhkot', location_code: 'KASH01', admin_level: 2, type: 'tehsil', hierarchy_path: 'KASH.KASH01'),
    Location.new(placename_en: 'kashmore', location_code: 'KASH02', admin_level: 2, type: 'tehsil', hierarchy_path: 'KASH.KASH02'),
    Location.new(placename_en: 'Tangwani', location_code: 'KASH03', admin_level: 2, type: 'tehsil', hierarchy_path: 'KASH.KASH03'),

    Location.new(placename_en: 'Shikarpur', location_code: 'SHI', admin_level: 1, type: 'district', hierarchy_path: 'SHI'),

    Location.new(placename_en: 'Garhi Yasin', location_code: 'SHI01', admin_level: 2, type: 'tehsil', hierarchy_path: 'SHI.SHI01'),
    Location.new(placename_en: 'Khanpur', location_code: 'SHI02', admin_level: 2, type: 'tehsil', hierarchy_path: 'SHI.SHI02'),
    Location.new(placename_en: 'Lakhi', location_code: 'SHI03', admin_level: 2, type: 'tehsil', hierarchy_path: 'SHI.SHI03'),
    Location.new(placename_en: 'Shikarpur', location_code: 'SHI04', admin_level: 2, type: 'tehsil', hierarchy_path: 'SHI.SHI04'),

    Location.new(placename_en: 'Jacobabad', location_code: 'JAC', admin_level: 1, type: 'district', hierarchy_path: 'JAC'),

    Location.new(placename_en: 'Garhi Khairo', location_code: 'JAC01', admin_level: 2, type: 'tehsil', hierarchy_path: 'JAC.JAC01'),
    Location.new(placename_en: 'Jacobabad', location_code: 'JAC02', admin_level: 2, type: 'tehsil', hierarchy_path: 'JAC.JAC02'),
    Location.new(placename_en: 'Thul', location_code: 'JAC03', admin_level: 2, type: 'tehsil', hierarchy_path: 'JAC.JAC03'),

    Location.new(placename_en: 'Kambar Shahdadkot', location_code: 'KS', admin_level: 1, type: 'district', hierarchy_path: 'KS'),

    Location.new(placename_en: 'Kambar', location_code: 'KS01', admin_level: 2, type: 'tehsil', hierarchy_path: 'KS.KS01'),
    Location.new(placename_en: 'Kubo Saeed Khan', location_code: 'KS02', admin_level: 2, type: 'tehsil', hierarchy_path: 'KS.KS02'),
    Location.new(placename_en: 'Miro Khan', location_code: 'KS03', admin_level: 2, type: 'tehsil', hierarchy_path: 'KS.KS03'),
    Location.new(placename_en: 'Nasirabad', location_code: 'KS04', admin_level: 2, type: 'tehsil', hierarchy_path: 'KS.KS04'),
    Location.new(placename_en: 'Shahdadkot', location_code: 'KS05', admin_level: 2, type: 'tehsil', hierarchy_path: 'KS.KS05'),
    Location.new(placename_en: 'Sujawal Junejo', location_code: 'KS06', admin_level: 2, type: 'tehsil', hierarchy_path: 'KS.KS06'),
    Location.new(placename_en: 'Warah', location_code: 'KS07', admin_level: 2, type: 'tehsil', hierarchy_path: 'KS.KS07'),

    Location.new(placename_en: 'Sukkur', location_code: 'SUK', admin_level: 1, type: 'district', hierarchy_path: 'SUK'),

    Location.new(placename_en: 'New Sukkur', location_code: 'SUK01', admin_level: 2, type: 'tehsil', hierarchy_path: 'SUK.SUK01'),
    Location.new(placename_en: 'Pano Aqil', location_code: 'SUK02', admin_level: 2, type: 'tehsil', hierarchy_path: 'SUK.SUK02'),
    Location.new(placename_en: 'Rohri', location_code: 'SUK03', admin_level: 2, type: 'tehsil', hierarchy_path: 'SUK.SUK03'),
    Location.new(placename_en: 'Salehpat', location_code: 'SUK04', admin_level: 2, type: 'tehsil', hierarchy_path: 'SUK.SUK04'),
    Location.new(placename_en: 'Sukkur', location_code: 'SUK05', admin_level: 2, type: 'tehsil', hierarchy_path: 'SUK.SUK05'),

    Location.new(placename_en: 'Ghotki (At Mirpur Mathelo)', location_code: 'GT', admin_level: 1, type: 'district', hierarchy_path: 'GT'),

    Location.new(placename_en: 'Daharki', location_code: 'GT01', admin_level: 2, type: 'tehsil', hierarchy_path: 'GT.GT01'),
    Location.new(placename_en: 'Ghotki', location_code: 'GT02', admin_level: 2, type: 'tehsil', hierarchy_path: 'GT.GT02'),
    Location.new(placename_en: 'Khangarh (Khanpur)', location_code: 'GT03', admin_level: 2, type: 'tehsil', hierarchy_path: 'GT.GT03'),
    Location.new(placename_en: 'Mirpur Mathelo', location_code: 'GT04', admin_level: 2, type: 'tehsil', hierarchy_path: 'GT.GT04'),
    Location.new(placename_en: 'Ubauro', location_code: 'GT05', admin_level: 2, type: 'tehsil', hierarchy_path: 'GT.GT05'),

    Location.new(placename_en: 'Khairpur', location_code: 'KP', admin_level: 1, type: 'district', hierarchy_path: 'KP'),

    Location.new(placename_en: 'Faiz Ganj', location_code: 'KP01', admin_level: 2, type: 'tehsil', hierarchy_path: 'KP.KP01'),
    Location.new(placename_en: 'Gambat', location_code: 'KP02', admin_level: 2, type: 'tehsil', hierarchy_path: 'KP.KP02'),
    Location.new(placename_en: 'Khairpur', location_code: 'KP03', admin_level: 2, type: 'tehsil', hierarchy_path: 'KP.KP03'),
    Location.new(placename_en: 'Kingri', location_code: 'KP04', admin_level: 2, type: 'tehsil', hierarchy_path: 'KP.KP04'),
    Location.new(placename_en: 'Kot Diji', location_code: 'KP05', admin_level: 2, type: 'tehsil', hierarchy_path: 'KP.KP05'),
    Location.new(placename_en: 'Mirwah', location_code: 'KP06', admin_level: 2, type: 'tehsil', hierarchy_path: 'KP.KP06'),
    Location.new(placename_en: 'Nara', location_code: 'KP07', admin_level: 2, type: 'tehsil', hierarchy_path: 'KP.KP07'),
    Location.new(placename_en: 'Sobhodero', location_code: 'KP08', admin_level: 2, type: 'tehsil', hierarchy_path: 'KP.KP08'),

    Location.new(placename_en: 'Shaheed Benazirabad', location_code: 'SB', admin_level: 1, type: 'district', hierarchy_path: 'SB'),

    Location.new(placename_en: 'Daur', location_code: 'SB01', admin_level: 2, type: 'tehsil', hierarchy_path: 'SB.SB01'),
    Location.new(placename_en: 'Nawab Shah', location_code: 'SB02', admin_level: 2, type: 'tehsil', hierarchy_path: 'SB.SB02'),
    Location.new(placename_en: 'Qazi Ahmed', location_code: 'SB03', admin_level: 2, type: 'tehsil', hierarchy_path: 'SB.SB03'),
    Location.new(placename_en: 'Rato', location_code: 'SB04', admin_level: 2, type: 'tehsil', hierarchy_path: 'SB.SB04'),

    Location.new(placename_en: 'Naushahro Feroze', location_code: 'NF', admin_level: 1, type: 'district', hierarchy_path: 'NF'),

    Location.new(placename_en: 'Bhiria', location_code: 'NF01', admin_level: 2, type: 'tehsil', hierarchy_path: 'NF.NF01'),
    Location.new(placename_en: 'Kandioro', location_code: 'NF02', admin_level: 2, type: 'tehsil', hierarchy_path: 'NF.NF02'),
    Location.new(placename_en: 'Mehrabpur', location_code: 'NF03', admin_level: 2, type: 'tehsil', hierarchy_path: 'NF.NF03'),
    Location.new(placename_en: 'Moro', location_code: 'NF04', admin_level: 2, type: 'tehsil', hierarchy_path: 'NF.NF04'),
    Location.new(placename_en: 'Naushahro Feroze', location_code: 'NF05', admin_level: 2, type: 'tehsil', hierarchy_path: 'NF.NF05'),

    Location.new(placename_en: 'Sanghar', location_code: 'SG', admin_level: 1, type: 'district', hierarchy_path: 'SG'),

    Location.new(placename_en: 'Jam Nawaz Ali', location_code: 'SG01', admin_level: 2, type: 'tehsil', hierarchy_path: 'SG.SG01'),
    Location.new(placename_en: 'Khipro', location_code: 'SG02', admin_level: 2, type: 'tehsil', hierarchy_path: 'SG.SG02'),
    Location.new(placename_en: 'Sanghar', location_code: 'SG03', admin_level: 2, type: 'tehsil', hierarchy_path: 'SG.SG03'),
    Location.new(placename_en: 'Shahdadpur', location_code: 'SG04', admin_level: 2, type: 'tehsil', hierarchy_path: 'SG.SG04'),
    Location.new(placename_en: 'Sinjhoro', location_code: 'SG05', admin_level: 2, type: 'tehsil', hierarchy_path: 'SG.SG05'),
    Location.new(placename_en: 'Tando Adam', location_code: 'SG06', admin_level: 2, type: 'tehsil', hierarchy_path: 'SG.SG06'),

    Location.new(placename_en: 'Hyderabad', location_code: 'HB', admin_level: 1, type: 'district', hierarchy_path: 'HB'),

    Location.new(placename_en: 'Hyderabad City', location_code: 'HB01', admin_level: 2, type: 'tehsil', hierarchy_path: 'HB.HB01'),
    Location.new(placename_en: 'Hyderabad', location_code: 'HB02', admin_level: 2, type: 'tehsil', hierarchy_path: 'HB.HB02'),
    Location.new(placename_en: 'Latifabad', location_code: 'HB03', admin_level: 2, type: 'tehsil', hierarchy_path: 'HB.HB03'),
    Location.new(placename_en: 'Qasimabad', location_code: 'HB04', admin_level: 2, type: 'tehsil', hierarchy_path: 'HB.HB04')
  ]
  Location.locations_by_code = locations.map { |l| [l.location_code, l] }.to_h

  locations.each(&:name_from_hierarchy)

  locations.each(&:save!)
  GenerateLocationFilesService.generate
  end
end
