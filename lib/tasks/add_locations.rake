namespace :add_locations do
  desc 'Adding default locations'
  task add_new_locations: :environment do
  next if Location.find_by(location_code: "BAL").present?

  locations = [
    Location.new(placename_en: 'Sindh', location_code: 'SIN', admin_level: 1, type: 'province', hierarchy_path: 'SIN'),
    Location.new(placename_en: 'Larkana', location_code: 'LAR01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.LAR01'),

    Location.new(placename_en: 'Bakrani', location_code: 'LAR0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.LAR01.LAR0101'),
    Location.new(placename_en: 'Dokri', location_code: 'LAR02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.LAR01.LAR02'),
    Location.new(placename_en: 'Larkana', location_code: 'LAR03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.LAR01.LAR03'),
    Location.new(placename_en: 'Rato Dero', location_code: 'LAR04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.LAR01.LAR04'),

    Location.new(placename_en: 'Kashmore', location_code: 'KASH01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.KASH01'),

    Location.new(placename_en: 'Kandhkot', location_code: 'KASH0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KASH01.KASH0101'),
    Location.new(placename_en: 'kashmore', location_code: 'KASH02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KASH01.KASH02'),
    Location.new(placename_en: 'Tangwani', location_code: 'KASH03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KASH01.KASH03'),

    Location.new(placename_en: 'Shikarpur', location_code: 'SHI01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.SHI01'),

    Location.new(placename_en: 'Garhi Yasin', location_code: 'SHI0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SHI01.SHI0101'),
    Location.new(placename_en: 'Khanpur', location_code: 'SHI02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SHI01.SHI02'),
    Location.new(placename_en: 'Lakhi', location_code: 'SHI03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SHI01.SHI03'),
    Location.new(placename_en: 'Shikarpur', location_code: 'SHI04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SHI01.SHI04'),

    Location.new(placename_en: 'Jacobabad', location_code: 'JAC01', admin_level: 1, type: 'district', hierarchy_path: 'SIN.JAC01'),

    Location.new(placename_en: 'Garhi Khairo', location_code: 'JAC0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.JAC01.JAC0101'),
    Location.new(placename_en: 'Jacobabad', location_code: 'JAC02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.JAC01.JAC02'),
    Location.new(placename_en: 'Thul', location_code: 'JAC03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.JAC01.JAC03'),

    Location.new(placename_en: 'Kambar Shahdadkot', location_code: 'KS01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.KS01'),

    Location.new(placename_en: 'Kambar', location_code: 'KS0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KS01.KS0101'),
    Location.new(placename_en: 'Kubo Saeed Khan', location_code: 'KS02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KS01.KS02'),
    Location.new(placename_en: 'Miro Khan', location_code: 'KS03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KS01.KS03'),
    Location.new(placename_en: 'Nasirabad', location_code: 'KS04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KS01.KS04'),
    Location.new(placename_en: 'Shahdadkot', location_code: 'KS05', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KS01.KS05'),
    Location.new(placename_en: 'Sujawal Junejo', location_code: 'KS06', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KS01.KS06'),
    Location.new(placename_en: 'Warah', location_code: 'KS07', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KS01.KS07'),

    Location.new(placename_en: 'Sukkur', location_code: 'SUK01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.SUK01'),

    Location.new(placename_en: 'New Sukkur', location_code: 'SUK0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SUK01.SUK0101'),
    Location.new(placename_en: 'Pano Aqil', location_code: 'SUK02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SUK01.SUK02'),
    Location.new(placename_en: 'Rohri', location_code: 'SUK03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SUK01.SUK03'),
    Location.new(placename_en: 'Salehpat', location_code: 'SUK04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SUK01.SUK04'),
    Location.new(placename_en: 'Sukkur', location_code: 'SUK05', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SUK01.SUK05'),

    Location.new(placename_en: 'Ghotki (At Mirpur Mathelo)', location_code: 'GT01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.GT01'),

    Location.new(placename_en: 'Daharki', location_code: 'GT0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.GT01.GT0101'),
    Location.new(placename_en: 'Ghotki', location_code: 'GT02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.GT01.GT02'),
    Location.new(placename_en: 'Khangarh (Khanpur)', location_code: 'GT03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.GT01.GT03'),
    Location.new(placename_en: 'Mirpur Mathelo', location_code: 'GT04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.GT01.GT04'),
    Location.new(placename_en: 'Ubauro', location_code: 'GT05', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.GT01.GT05'),

    Location.new(placename_en: 'Khairpur', location_code: 'KP01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.KP01'),

    Location.new(placename_en: 'Faiz Ganj', location_code: 'KP0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KP01.KP0101'),
    Location.new(placename_en: 'Gambat', location_code: 'KP02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KP01.KP02'),
    Location.new(placename_en: 'Khairpur', location_code: 'KP03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KP01.KP03'),
    Location.new(placename_en: 'Kingri', location_code: 'KP04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KP01.KP04'),
    Location.new(placename_en: 'Kot Diji', location_code: 'KP05', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KP01.KP05'),
    Location.new(placename_en: 'Mirwah', location_code: 'KP06', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KP01.KP06'),
    Location.new(placename_en: 'Nara', location_code: 'KP07', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KP01.KP07'),
    Location.new(placename_en: 'Sobhodero', location_code: 'KP08', admin_level: 2, type: 'tehsil', hierarchy_path: 'SIN.KP01.KP08'),

    Location.new(placename_en: 'Shaheed Benazirabad', location_code: 'SB01', admin_level: 2, type: 'district', hierarchy_path: 'SB01'),

    Location.new(placename_en: 'Daur', location_code: 'SB0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SB01.SB0101'),
    Location.new(placename_en: 'Nawab Shah', location_code: 'SB02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SB01.SB02'),
    Location.new(placename_en: 'Qazi Ahmed', location_code: 'SB03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SB01.SB03'),
    Location.new(placename_en: 'Rato', location_code: 'SB04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SB01.SB04'),

    Location.new(placename_en: 'Naushahro Feroze', location_code: 'NF01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.NF01'),

    Location.new(placename_en: 'Bhiria', location_code: 'NF0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.NF01.NF0101'),
    Location.new(placename_en: 'Kandioro', location_code: 'NF02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.NF01.NF02'),
    Location.new(placename_en: 'Mehrabpur', location_code: 'NF03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.NF01.NF03'),
    Location.new(placename_en: 'Moro', location_code: 'NF04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.NF01.NF04'),
    Location.new(placename_en: 'Naushahro Feroze', location_code: 'NF05', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.NF01.NF05'),

    Location.new(placename_en: 'Sanghar', location_code: 'SG01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.SG01'),

    Location.new(placename_en: 'Jam Nawaz Ali', location_code: 'SG0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SG01.SG0101'),
    Location.new(placename_en: 'Khipro', location_code: 'SG02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SG01.SG02'),
    Location.new(placename_en: 'Sanghar', location_code: 'SG03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SG01.SG03'),
    Location.new(placename_en: 'Shahdadpur', location_code: 'SG04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SG01.SG04'),
    Location.new(placename_en: 'Sinjhoro', location_code: 'SG05', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SG01.SG05'),
    Location.new(placename_en: 'Tando Adam', location_code: 'SG06', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SG01.SG06'),

    Location.new(placename_en: 'Hyderabad', location_code: 'HB01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.HB01'),

    Location.new(placename_en: 'Hyderabad City', location_code: 'HB0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.HB01.HB0101'),
    Location.new(placename_en: 'Hyderabad', location_code: 'HB02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.HB01.HB02'),
    Location.new(placename_en: 'Latifabad', location_code: 'HB03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.HB01.HB03'),
    Location.new(placename_en: 'Qasimabad', location_code: 'HB04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.HB01.HB04'),

    Location.new(placename_en: 'Jamshoro', location_code: 'JM01', admin_level: 2, type: 'district', hierarchy_path: 'JM01'),

    Location.new(placename_en: 'Kotri', location_code: 'JM0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.JM01.JM0101'),
    Location.new(placename_en: 'Manjhand', location_code: 'JM02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.JM01.JM02'),
    Location.new(placename_en: 'Sehwan', location_code: 'JM03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.JM01.JM03'),
    Location.new(placename_en: 'Thano Bula Khan', location_code: 'JM04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.JM01.JM04'),

    Location.new(placename_en: 'Dadu', location_code: 'DD01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.DD01'),

    Location.new(placename_en: 'Dadu', location_code: 'DD0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.DD01.DD0101'),
    Location.new(placename_en: 'Johi', location_code: 'DD02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.DD01.DD02'),
    Location.new(placename_en: 'Khairpur Nathan Shah', location_code: 'DD03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.DD01.DD03'),
    Location.new(placename_en: 'Mehar', location_code: 'DD04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.DD01.DD04'),

    Location.new(placename_en: 'Matiari', location_code: 'MT01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.MT01'),

    Location.new(placename_en: 'Hala', location_code: 'MT0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.MT01.MT0101'),
    Location.new(placename_en: 'Matiari', location_code: 'MT02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.MT01.MT02'),
    Location.new(placename_en: 'Saeedabad', location_code: 'MT03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.MT01.MT03'),

    Location.new(placename_en: 'Tando Allahyar', location_code: 'TA01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.TA01'),

    Location.new(placename_en: 'Chamber', location_code: 'TA0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TA01.TA0101'),
    Location.new(placename_en: 'Jhando Mari', location_code: 'TA02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TA01.TA02'),
    Location.new(placename_en: 'Tando Allahyar', location_code: 'TA03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TA01.TA03'),

    Location.new(placename_en: 'Tando Muhammad Khan', location_code: 'TMK01', admin_level: 2, type: 'district', hierarchy_path: 'TMK01'),

    Location.new(placename_en: 'Bulri Shah Karim', location_code: 'TMK0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TMK01.TMK0101'),
    Location.new(placename_en: 'KRGTando Ghulam Hyder', location_code: 'TMK02', admin_level: 2, type: 'tehsil', hierarchy_path: 'SIN.TMK01.TMK02'),
    Location.new(placename_en: 'Tando Muhammad Khan', location_code: 'TMK03', admin_level: 2, type: 'tehsil', hierarchy_path: 'SIN.TMK01.TMK03'),

    Location.new(placename_en: 'Badin', location_code: 'BD01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.BD01'),

    Location.new(placename_en: 'Badin', location_code: 'BD0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.BD01.BD0101'),
    Location.new(placename_en: 'Matli', location_code: 'BD02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.BD01.BD02'),
    Location.new(placename_en: 'Shaheed Fazal Rahu', location_code: 'BD03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.BD01.BD03'),
    Location.new(placename_en: 'Talhar', location_code: 'BD04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.BD01.BD04'),
    Location.new(placename_en: 'Tando Bago', location_code: 'BD05', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.BD01.BD05'),

    Location.new(placename_en: 'Thatta', location_code: 'TT01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.TT01'),

    Location.new(placename_en: 'Ghorabari', location_code: 'TT0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TT01.TT0101'),
    Location.new(placename_en: 'Keti Bunder', location_code: 'TT02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TT01.TT02'),
    Location.new(placename_en: 'Mirpur Sakro', location_code: 'TT03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TT01.TT03'),
    Location.new(placename_en: 'Thatta', location_code: 'TT04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TT01.TT04'),

    Location.new(placename_en: 'Sujawal', location_code: 'SJ01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.SJ01'),

    Location.new(placename_en: 'Jati', location_code: 'SJ0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SJ01.SJ0101'),
    Location.new(placename_en: 'Kharo Chan', location_code: 'SJ02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SJ01.SJ02'),
    Location.new(placename_en: 'Mirpur Bathoro', location_code: 'SJ03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SJ01.SJ03'),
    Location.new(placename_en: 'Shah Bunder', location_code: 'SJ04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SJ01.SJ04'),
    Location.new(placename_en: 'Sujawal', location_code: 'SJ05', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.SJ01.SJ05'),

    Location.new(placename_en: 'Mirpur Khas', location_code: 'MPK01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.MPK01'),

    Location.new(placename_en: 'Digri', location_code: 'MPK0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.MPK01.MPK0101'),
    Location.new(placename_en: 'Hussain Bux Marri', location_code: 'MPK02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.MPK01.MPK02'),
    Location.new(placename_en: 'Jhuddo', location_code: 'MPK03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.MPK01.MPK03'),
    Location.new(placename_en: 'Kot Ghulam Mohammad', location_code: 'MPK04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.MPK01.MPK04'),
    Location.new(placename_en: 'Mirpur Khas', location_code: 'MPK05', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.MPK01.MPK05'),
    Location.new(placename_en: 'Shujabad', location_code: 'MPK06', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.MPK01.MPK06'),
    Location.new(placename_en: 'Sindhri', location_code: 'MPK07', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.MPK01.MPK07'),

    Location.new(placename_en: 'Tharparkar', location_code: 'TPK01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.TPK01'),

    Location.new(placename_en: 'Chachro', location_code: 'TPK0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TPK01.TPK01'),
    Location.new(placename_en: 'Dhali', location_code: 'TPK02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TPK01.TPK02'),
    Location.new(placename_en: 'Diplo', location_code: 'TPK03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TPK01.TPK03'),
    Location.new(placename_en: 'Islamkot', location_code: 'TPK04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TPK01.TPK04'),
    Location.new(placename_en: 'Kaloi', location_code: 'TPK05', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TPK01.TPK05'),
    Location.new(placename_en: 'Mithi', location_code: 'TPK06', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TPK01.TPK06'),
    Location.new(placename_en: 'Nagar Parkar', location_code: 'TPK07', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.TPK01.TPK07'),

    Location.new(placename_en: 'Umerkot', location_code: 'UK01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.UK01'),

    Location.new(placename_en: 'Kunri', location_code: 'UK0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.UK01.UK0101'),
    Location.new(placename_en: 'Pithoro', location_code: 'UK02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.UK01.UK02'),
    Location.new(placename_en: 'Samaro', location_code: 'UK03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.UK01.UK03'),
    Location.new(placename_en: 'Umerkot', location_code: 'UK04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.UK01.UK04'),

    Location.new(placename_en: 'Karachi East', location_code: 'KE01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.KE01'),

    Location.new(placename_en: 'Ferozabad', location_code: 'KE0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KE01.KE0101'),
    Location.new(placename_en: 'Gulshan-E-Iqbal', location_code: 'KE02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KE01.KE02'),
    Location.new(placename_en: 'Gulzar-E-Hijri', location_code: 'KE03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KE01.KE03'),
    Location.new(placename_en: 'Jamshed Quarter', location_code: 'KE04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KE01.KE04'),

    Location.new(placename_en: 'Karachi West', location_code: 'KW01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.KW01'),

    Location.new(placename_en: 'Mauripur', location_code: 'KW0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KW01.KW0101'),
    Location.new(placename_en: 'Harbour', location_code: 'KW02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KW01.KW02'),
    Location.new(placename_en: 'Orangi', location_code: 'KW03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KW01.KW03'),
    Location.new(placename_en: 'Mominabad', location_code: 'KW04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KW01.KW04'),
    Location.new(placename_en: 'Baldia', location_code: 'KW05', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KW01.KW05'),
    Location.new(placename_en: 'Manghopir', location_code: 'KW06', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KW01.KW06'),

    Location.new(placename_en: 'Karachi South', location_code: 'KS1', admin_level: 2, type: 'district', hierarchy_path: 'SIN.KS1'),

    Location.new(placename_en: 'Aram Bagh', location_code: 'KS2', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KS1.KS2'),
    Location.new(placename_en: 'Civil Line', location_code: 'KS3', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KS1.KS3'),
    Location.new(placename_en: 'Garden', location_code: 'KS4', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KS1.KS4'),
    Location.new(placename_en: 'Lyari', location_code: 'KS5', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KS1.KS5'),
    Location.new(placename_en: 'Saddar Sub-Division', location_code: 'KS6', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KS1.KS6'),

    Location.new(placename_en: 'Karachi Central', location_code: 'KC01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.KC01'),

    Location.new(placename_en: 'Gulberg', location_code: 'KC0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KC01.KC01O1'),
    Location.new(placename_en: 'Liaquatabad', location_code: 'KC02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KC01.KC02'),
    Location.new(placename_en: 'Nazimabad', location_code: 'KC03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KC01.KC03'),
    Location.new(placename_en: 'New Karachi', location_code: 'KC04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KC01.KC04'),
    Location.new(placename_en: 'North Nazimabad', location_code: 'KC05', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KC01.KC05'),

    Location.new(placename_en: 'Malir', location_code: 'ML01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.ML01'),

    Location.new(placename_en: 'Airport', location_code: 'ML0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.ML01.ML0101'),
    Location.new(placename_en: 'Bin Qasim', location_code: 'ML02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.ML01.ML02'),
    Location.new(placename_en: 'Gadab', location_code: 'ML03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.ML01.ML03'),
    Location.new(placename_en: 'Ibrahim Hyderi', location_code: 'ML04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.ML01.ML04'),
    Location.new(placename_en: 'Murad Memon', location_code: 'ML05', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.ML01.ML05'),
    Location.new(placename_en: 'Shah Murad', location_code: 'ML06', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.ML01.ML06'),

    Location.new(placename_en: 'Korangi', location_code: 'KRG01', admin_level: 2, type: 'district', hierarchy_path: 'SIN.KRG01'),

    Location.new(placename_en: 'Korangi', location_code: 'KRG0101', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KRG01.KRG0101'),
    Location.new(placename_en: 'Landhi', location_code: 'Korangi02', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KRG01.KRG02'),
    Location.new(placename_en: 'Madol Colony', location_code: 'Korangi03', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KRG01.KRG03'),
    Location.new(placename_en: 'Shah Faisal', location_code: 'Korangi04', admin_level: 3, type: 'tehsil', hierarchy_path: 'SIN.KRG01.KRG04'),
  ]
  Location.locations_by_code = locations.map { |l| [l.location_code, l] }.to_h

  locations.each(&:name_from_hierarchy)

  locations.each(&:save!)
  GenerateLocationFilesService.generate
  end
end
