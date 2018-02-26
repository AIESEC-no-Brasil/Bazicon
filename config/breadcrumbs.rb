crumb :payments do
  link "Pagamentos", payments_path
end

crumb :payment do |payment|
  link "Pagamento #{payment.customer_name}", payment
  parent :payments
end

crumb :payment_text do |text|
  link text
  parent :payments
end
