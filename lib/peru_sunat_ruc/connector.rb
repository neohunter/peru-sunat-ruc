# encoding: UTF-8
require 'mechanize'

class PeruSunatRuc::Connector
  URL_BASE = 'http://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc'

  def self.get_info(ruc)
    self.new(ruc).company
  end

  attr_reader :company
  def initialize(ruc)
    @agent = Mechanize.new
    @company = get_info(ruc)
  end

  def get_info(ruc)
    page = get_html_page ruc

    # ToDo: Si tiene unresultado valido?
    if page.body.to_s.include? 'ero y volver a ingresar.'
      raise 'Número de RUC Invalido'
    end

    PeruSunatRuc::Company.new({
      ruc_number: page.at('/html/body/table[1]/tr[1]/td[2]').text,
      name: page.at('/html/body/table[1]/tr[1]/td[2]').text.split('-').last.strip,
      address: page.at('/html/body/table[1]/tr[7]/td[2]').text,
      taxpayer_type: page.at('/html/body/table[1]/tr[2]/td[2]').text,
      taxpayer_status: page.at('/html/body/table[1]/tr[4]/td[2]').text,
      taxpayer_condition: page.at('/html/body/table[1]/tr[6]/td[2]').text.scan(/[A-Z][a-z]*\w+/),
      inscription_date: page.at('/html/body/table[1]/tr[3]/td[2]').text,      
      voucher_system: page.at('/html/body/table[1]/tr[8]/td[2]').text,
      accounting_system: page.at('/html/body/table[1]/tr[9]/td[2]').text,
      economic_activities: page.at('/html/body/table[1]/tr[10]/td[2]/select/option').text,
      affiliate_ple_since: page.at('/html/body/table[1]/tr[14]/td[2]').text,
      electronic_emisor: page.at('/html/body/table[1]/tr[13]/td[2]').text,
      activity_trade: page.at('/html/body/table[1]/tr[8]/td[4]').text,
      date_start_activities: page.at('/html/body/table[1]/tr[4]/td[4]').text
    })
  end

  private
    def captcha
      post('/captcha', 
        { accion: 'random' }
      ).body
    end

    def get_html_page(ruc) 
      post('/jcrS00Alias', {
        nroRuc: ruc,
        accion: 'consPorRuc',
        numRnd: captcha
      })
    end

    def url(path)
      URL_BASE + path
    end

    def post(path, data)
      @agent.post url(path), data
    end
end