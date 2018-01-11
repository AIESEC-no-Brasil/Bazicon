crumb :root do
  link "Home", root_path
end

crumb :payments do
  link "Pagamentos", payments_path
  parent :root
end

crumb :payment do |payment|
  link "Pagamento #{payment.customer_name}", payment
  parent :payments
end

crumb :payment_text do |text|
  link text
  parent :payments
end
