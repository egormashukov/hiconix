# encoding: utf-8
# == Schema Information
#
# Table name: properties
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  measurement_unit :string(255)
#  hiconix_code     :string(255)
#  type             :string(255)
#  description      :text
#  desc_url         :string(255)
#  dynamic_string   :text             default("")
#  seo              :string(255)
#  tenant_id        :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class DynamicProperty < Property

  ACTION_TYPES = [["Математическое","math"],["Строковое","string"]]

  # after_create :replace_nullified_property_mu
  # before_save :clean_dynamic_string

  def parsed_dynamic_string
    begin
      JSON.parse(dynamic_string)
    rescue Exception
      {}
    end
  end

  def string_type?
    type_of_action == "string"
  end

  def math_type?
    type_of_action == "math"
  end

  def measurement_unit_cannot_be_converted?
    if string_type?
      true
    else
      super
    end
  end

# getters for attributes, parsed from dynamic_string
  [:type_of_action, :string_action, :math_action, :first_property_mu, :second_property_mu, :first_id, :first_mu, :second_id, :second_mu, :first_prop, :second_prop].each do |key|
    define_method key do
      parsed_dynamic_string[key.to_s]
    end
  end

  def id_from_property_mu(property_mu)
    property_mu.match(/\d+\(/).to_s.delete("(").to_i
  end

  # def mu_from_property_mu(property_mu)
  #   property_mu.match(/\(.+\)/).to_s.delete("(").delete(")")
  # end

  def first_property
    # if first_id
      Property.find(first_id)
    # else
      # Property.where(title: first_prop).first
    # end
  end

  def second_property
    # if second_id
      Property.find(second_id)
    # else
    #   Property.where(title: second_prop).first
    # end
  end



  def value_for_product(product_id, factor = 1.0, round_factor = 10)
    begin
      if first_property.dynamic?
        first_val = first_property.value_for_product(product_id)
      else
        first_val = ProductProperty.where(property_id: first_id, product_id: product_id).first.value
        if first_property.measurement_unit_cannot_be_converted?
          first_val = first_val.title
        else
          first_val = first_val.convert_into(first_mu)
          if first_val == first_val.to_i
            first_val = first_val.to_i
          end
        end
      end

      if second_property.dynamic?
        second_val = second_property.value_for_product(product_id)
      else
        second_val = ProductProperty.where(property_id: second_id, product_id: product_id).first.value
        if second_property.measurement_unit_cannot_be_converted?
          second_val = second_val.title
        else
          second_val = second_val.convert_into(second_mu)

          if second_val == second_val.to_i
            second_val = second_val.to_i
          end
        end
      end

      if math_type?
        (first_val.send(math_action, second_val) * factor).round(round_factor)
      elsif string_type?
        first_value = first_val.to_s
        second_value = second_val.to_s

        string_action.gsub("\#\{har1\}", first_value).gsub("\#\{har2\}", second_value)
      end
    rescue NoMethodError
      "не задано одно из значений, участвующих в характеристике"
    end
  end

  def parsed_hash(key, value)
    hash = parsed_dynamic_string
    hash[key] = value
    hash
  end

  def string_action=(string_action)
    hash = parsed_hash("string_action", string_action)
    write_attribute(:dynamic_string, hash.to_json)
  end

  def math_action=(math_action)
    hash = parsed_hash("math_action", math_action)
    write_attribute(:dynamic_string, hash.to_json)
  end

  def type_of_action=(type_of_action)
    hash = parsed_hash("type_of_action", type_of_action)
    write_attribute(:dynamic_string, hash.to_json)
  end

  # def first_mu=(first_mu)
  #   hash = parsed_hash("first_mu", first_mu)
  #   write_attribute(:dynamic_string, hash.to_json)
  # end

  # def second_mu=(second_mu)
  #   hash = parsed_hash("second_mu", second_mu)
  #   write_attribute(:dynamic_string, hash.to_json)
  # end

  def first_property_mu=(first_property_mu)
    hash = parsed_hash("first_property_mu", first_property_mu)
    hash["first_mu"] = first_property_mu
    write_attribute(:dynamic_string, hash.to_json)

    # hash = parsed_hash("first_property_mu", first_property_mu)
    # hash["first_id"] = id_from_property_mu(first_property_mu)
    # # hash["first_mu"] = mu_from_property_mu(first_property_mu)
    # write_attribute(:dynamic_string, hash.to_json)
  end

  def second_property_mu=(second_property_mu)
    hash = parsed_hash("second_property_mu", second_property_mu)
    hash["second_mu"] = second_property_mu
    write_attribute(:dynamic_string, hash.to_json)

    # hash = parsed_hash("second_property_mu", second_property_mu)
    # hash["second_id"] = id_from_property_mu(second_property_mu)
    # # hash["second_mu"] = mu_from_property_mu(second_property_mu)
    # write_attribute(:dynamic_string, hash.to_json)
  end

  def first_prop=(first_prop)
    hash = parsed_hash("first_prop", first_prop)
    hash["first_id"] = Property.where(title: first_prop).first.id
    hash.delete("first_property_mu")
    hash.delete("first_mu")
    write_attribute(:dynamic_string, hash.to_json)
  end

  def second_prop=(second_prop)
    hash = parsed_hash("second_prop", second_prop)
    hash["second_id"] = Property.where(title: second_prop).first.id
    hash.delete("second_property_mu")
    hash.delete("second_mu")
    write_attribute(:dynamic_string, hash.to_json)
  end

end
