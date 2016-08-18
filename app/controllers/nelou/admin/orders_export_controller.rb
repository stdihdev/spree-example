require 'csv'

class Nelou::Admin::OrdersExportController < Spree::Admin::BaseController
  def index
    csv_string = ::CSV.generate(col_sep: ';') do |csv|
      csv << ['Rechnungsnummer', 'Rechnngsdatum', 'Betrag brutto', 'Waehrung', 'Name des Kunden', 'Bezahlart', 'Storniert']
      Spree::Order.complete.order(completed_at: :desc).each do |order|
        csv << [order.invoice_number, l(order.completed_at.to_date), order.total, order.currency, order.bill_address.name, order.payments.completed.any? && order.payments.completed.last.payment_method.present? ? order.payments.completed.last.payment_method.name : '-', order.refunds.any? ? 'Ja' : 'Nein']
      end
    end

    send_data csv_string, filename: "orders-nelou-#{Date.today}.csv"
  end
end
