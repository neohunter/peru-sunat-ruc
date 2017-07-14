require "peru_sunat_ruc/version"
require "peru_sunat_ruc/connector"
require "peru_sunat_ruc/company"

module PeruSunatRuc
  def self.name_from(ruc_number)
    self.info_from(ruc_number).name
  end

  def self.info_from(ruc_number)
    Connector.get_info ruc_number
  end

  class InvalidRucNumber < StandardError
  end
end
