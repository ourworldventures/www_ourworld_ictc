module main

import vweb
import os

pub fn ticket_front(qr string) string {
	slug := qr.all_after_last('_')
	return $tmpl('templates/ticket_front.html')
}

pub fn run_before() {
	qrs := ['test']
	mut html := ''
	os.rm('templates/tickets.html') or { panic(err) }
	mut index_file := os.create('templates/tickets.html') or {
		panic('Failed to create index.html file: $err')
	}
	println('debug:${typeof(index_file)}')
	println('debug: ${ticket_front('test')}')
	index_file.write_string('<div>') or { panic('Failed to write <div> to index.html file: $err') }
	for qr in qrs {
		index_file.write_string(ticket_front(qr)) or {
			panic('Failed to write qr: $qr to index.html file: $err')
		}
	}
	index_file.write_string('</div>') or {
		panic('Failed to write </div> to index.html file: $err')
	}
	index_file.close()
}

pub struct App {
	vweb.Context
}

pub fn new_app() &App {
	mut app := &App{}
	static_folder := os.resource_abs_path('./static')
	app.mount_static_folder_at(static_folder, '/static')
	return app
}

pub fn main() {
	run_before()
	mut app := new_app()
	vweb.run(app, 8000)
}

pub fn (mut app App) tickets() vweb.Result {
	return $vweb.html()
}

pub fn (mut app App) index() vweb.Result {
	return $vweb.html()
}
