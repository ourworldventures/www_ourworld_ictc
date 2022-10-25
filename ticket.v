module main

import vweb
import os
import json

pub fn ticket_front(qr string) string {
	slug := qr.all_after_last('_')
	return $tmpl('templates/ticket_front.html')
}

pub fn run_before() {

	mut qr_paths := os.walk_ext('qrs', 'png')
	mut html := ''
	os.rm('templates/tickets.html') or { panic(err) }
	mut index_file := os.create('templates/tickets.html') or {
		panic('Failed to create index.html file: $err')
	}
	println('debug:${typeof(index_file)}')
	println('debug: ${ticket_front('test')}')
	index_file.write_string('<div>') or { panic('Failed to write <div> to index.html file: $err') }
	for qr in qr_paths {
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


pub fn (mut app App) index() vweb.Result {
	return $vweb.html()
}

pub struct Registration {
	name string
	email string
	org_website string
	plus_one string
	receive_communication string
}

pub fn (mut app App) exists() vweb.Result {
	return $vweb.html()
}

['/register'; post]
pub fn (mut app App) register(name string, email string, org_website string, plus_one string, receive_communication string) vweb.Result {
	println(app.req.data)
	registration :=	Registration {
		name: name,
		email: email,
		org_website: org_website,
		plus_one: plus_one,
		receive_communication: receive_communication,
	}
	path := 'registrations/${email}.txt'
	if os.exists(path) { return app.exists()}
	os.write_file(path, json.encode(registration)) or {println('error')}
	return $vweb.html()
}