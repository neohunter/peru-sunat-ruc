$: << Dir.pwd + '/lib'
require 'pry'
require 'peru_sunat_ruc'

ruc_number = ARGV[0] || '20131312955'

result = PeruSunatRuc.name_from ruc_number

puts result