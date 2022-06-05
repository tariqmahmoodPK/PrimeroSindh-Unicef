# frozen_string_literal: true

json.set!(indicator.name, @indicator_stats[indicator.record_model.parent_form][indicator.name])
json.workflow do
  @indicator_stats["indicators"].each do |key, value|
    json.registration do
      json.set!("count", value) if key.to_s.eql?("Registration")
    end
    json.assessment do
      json.set!("count", value) if key.to_s.eql?("Assessment")
    end
    json.case_plan do
      json.set!("count", value) if key.to_s.eql?("Case Plan")
    end
    json.referrals do
      json.set!("count", value) if key.to_s.eql?("Referrals")
    end
    json.final_case_review do
      json.set!("count", value) if key.to_s.eql?("Final Case Review")
    end
    json.case_closure do
      json.set!("count", value) if key.to_s.eql?("Case Closure")
    end
  end
end
