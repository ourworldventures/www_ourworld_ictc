import vweb

pub fn render_ticket(qr string) {
	slug := qr.all_after_last('_')
	$tmpl('./ticket.html')
}

pub fn (mut app App) index() vweb.Result {
	qrs := 
	return $vweb.html()
}
