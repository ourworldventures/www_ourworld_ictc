

pub fn render_ticket(qr string) {
	slug := qr.all_after_last('_')
	$tmpl('./ticket.html')
}
